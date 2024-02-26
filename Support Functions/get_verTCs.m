function [VL, fTL] = get_verTCs(SL, fTL, load_last)
%GET_VERTCS imports data from Reconstruct series files and returns table of indicated traces with vertices and colors. 
%   note: vertices values are in pixels (image dimensions * image
%   magnification). fTL field correction should be a ratio of xy to z 
%   (eg 8n/80 = 0.1). This may need to be manually set

% INPUTS
% - SL: Series List
% - fTL: Filtered trace list. Anything found in the fTL.Properties.Description
%                               are added to the file name
% - load_last: load the last saved vertices list file (as opposed to
%               importing the data). Much faster since you are just loading
%               a mat file. Only works if you have previously imported
% 
% OUTPUTS
% - VL: Vertices List
% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado School of Medicine

VLfile = fullfile(SL.Properties.UserData.paths.series, ['VerticesList'  fTL.Properties.Description '.mat']);

if nargin>2 && load_last && exist(VLfile,'file')
    load(VLfile, 'VL')
    disp('VL loaded from File')
    return
end

if ~exist(SL.Properties.UserData.paths.series,'dir') || ~exist('colornames','file')
    disp('series folder not found or colornames function missing')
    return
end

% preallocate Vertices List table
[VL, fTL] = preallocate_VL(fTL,SL);
vlidx = 1;

% rstr = sprintf('<Contour name="%s".+?/>',trace_name);

series_range = single(unique(cell2mat(fTL.Indices)))';

% Preallocate
width_height = []; % width and height of image
files_table = table(series_range', strings(numel(series_range),1),...
    'VariableNames', {'z','img_file'}); % contains the image file names

hw = waitbar(0,'Reading Master Sections');
for si = series_range
    
    % read file
    path_series = fullfile(SL.Properties.UserData.paths.series, SL.series_names{SL.series_index == si});
    filestr = fileread(path_series);
    xml=regexprep(filestr,'<[\/]{0,1}(\w*)[^\w\/> ]+(.*?)([ >])','<$1_$2$3'); % clean up xml
        
    % get contour cells containing the named trace
    cstr = sprintf('<Contour.+?/>'); % Header for contours (traces)
    contour_elements = regexp(xml,cstr,'match'); % cell array of all contour elements in file    
    contour_names = regexp(contour_elements, '(?<=Contour name=").+?(?=")','match');
        
    % get image size from domain contour
    if isempty(width_height) && any(string(contour_names) == 'domain1') % points in domain element contain the width and heigh of image
        width_height = max(cell2mat(get_points(contour_elements(string(contour_names) == 'domain1'))))+1;
    end
    
    % if no matching object names found in contour elements, continue
    name_la = ismember(string(contour_names), fTL.Object);    
    if ~any(name_la)
        continue
    end
    
    % get tif name for current series
    img_element = regexp(xml, '<Image.+?/>','match');
    img_file = string(regexp(img_element, '(?<=src=").+?(?=")','match','once'));
    files_table.img_file(series_range == si) = img_file(1);
    
    % remove all contour elements that don't match Object names in sTL.Object
    contour_names(~name_la) = [];
    contour_elements(~name_la) = []; % get rid of non-matching names
    
    % get pts stored 
    ptsc = get_points(contour_elements); % returns cell array
    % pts = cell2mat(ptsc);
    % pts = unique(pts,"rows"); %removes duplicate vertices

    % create names and contours id for each vertex. 
    %   note: the same contour id is contiguous
    [sz,~] = cellfun(@size,ptsc);
    Object_names = arrayfun(@(x,y) repmat(x,y,1),string(contour_names)',sz,'uni',false);
    contour_id = arrayfun(@(x,y) repmat(x,y,1),(1:numel(contour_names))',sz,'uni',false);
    
    % added 5-08-2023 to handle duplicate traces
    vl = [array2table(cat(1,Object_names{:}),'VariableNames', {'Object'}) ...
          array2table(cell2mat(ptsc),'VariableNames',{'x','y'})];

    [~,uci] = unique(vl,"rows"); % get unique indices

    vl = vl(sort(uci),:);
    contour_id = cell2mat(contour_id);
    vl.contour_id = contour_id(sort(uci));
    vl = movevars(vl,"contour_id",After="Object");
  
    vl.z = repmat(si,height(vl),1);
    
    VL(vlidx:vlidx+height(vl)-1,{'Object','contour_id','x', 'y', 'z'}) = vl;
    vlidx = vlidx+height(vl);
    
    waitbar( (si-series_range(1)) / range(series_range), hw,...
        sprintf('Section: %d / %d', si-series_range(1),range(series_range)));
    
end
delete(hw)

% Add meta properties
VL.Properties.UserData.img_mag = str2num(regexp(xml,'(?<=Image mag=").+?(?=")','match','once'));
VL.Properties.UserData.section_thickness = str2num(regexp(xml,'(?<=thickness=").+?(?=")','match','once'));

if isfield(fTL.Properties.UserData,'zCorrection')
    VL.Properties.UserData.zCorrection = fTL.Properties.UserData.zCorrection;
else
    VL.Properties.UserData.zCorrection = 0.1; % otherwise assume 8nm/80nm
end

VL.Properties.UserData.width = width_height(1);
VL.Properties.UserData.height = width_height(2);

files_table(files_table.img_file == "",:) = [];
VL.Properties.UserData.file_table = files_table;

% correct image mag
VL.x = VL.x / VL.Properties.UserData.img_mag;
VL.y = VL.y / VL.Properties.UserData.img_mag;

VL.Properties.UserData.bounding_box = [floor(min(VL.x)) floor(min(VL.y)) min(VL.z)...
    ceil(range(VL.x)) ceil(range(VL.y)) range(VL.z)];

% Correct Z position
VL.z = VL.z / VL.Properties.UserData.zCorrection;

% remove empty rows
la = strlength(VL.Object) == 0;
VL(la,:) = [];

% add color names to fTL
% requires the colornames function
fTL.rgb_name = string(colornames('MATLAB', double(fTL.RGBfill == max(fTL.RGBfill,[],2))));
VL.Properties.UserData.fTL = fTL;
VL.Properties.UserData.file = VLfile;

fprintf('\n **IMPORT COMPLETE** \n Saved as: %s \n Image Magnification: %2.4f \n Section Thickness: %2.4f\n',...
    VLfile,...
    VL.Properties.UserData.img_mag,...
    VL.Properties.UserData.section_thickness)

save(VLfile, 'VL')
end

% --------------------
% SUB-functions 
% --------------------

function pts = get_points(contour_elements)
% get points
ptstr = regexp(contour_elements, '(?<=points=").+?(?=")','match'); %[0-9,\s]
cpts = cellfun(@(x) regexprep(x,',',';'), ptstr);
pts = cellfun(@str2num, cpts','uni',false);
end

function [VL, fTL] = preallocate_VL(fTL,SL)
% Preallocation STEP
% Find the total number of vertices
% Create a new table called VL

fTL.vert_total = zeros(height(fTL),1);
% series_range = fTL.Properties.UserData.series_range;
series_range = single(unique(cell2mat(fTL.Indices)))';
hwb = waitbar(0, 'Counting vertices in all trace files...');
for n=series_range
    
    TN = get_all_trace_names(SL, n); % returns trace names from a given series file
    sTN = TN(ismember(TN.trace_name, fTL.Object), :); % just the trace_names found in fTL
    
    if isempty(sTN)
        continue
    end
    
    Lia = ismember(fTL.Object, sTN.trace_name);
    fTL.vert_total(Lia) = fTL.vert_total(Lia) + sTN.vert_count;
    
    %     fill_edge_la = Lia & sum(table2array(sTL(:,{'RGBfill', 'RGBedge'})),2)==0; % edges that need to be filled
    fTL(Lia,{'RGBfill', 'RGBedge'}) = sTN(:,{'RGBfill', 'RGBedge'});
    
    waitbar((n-series_range(1))/range(series_range),hwb, 'getting counts for preallocation...')
end
delete(hwb)

vert_count = sum(fTL.vert_total);
VL = [array2table(strings(vert_count,1),'VariableNames', {'Object'}) ...
    array2table(zeros(vert_count, 4),'VariableNames', {'contour_id','x', 'y', 'z', })];
end
