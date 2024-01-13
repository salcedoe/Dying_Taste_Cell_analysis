function TN = get_all_trace_names(SL, section)
% returns a trace table from the series file indicated by section number:
% - trace names, vertices, RGB values for fill and edge values

series_path = fullfile(SL.Properties.UserData.paths.series, SL.series_names{SL.series_index == section});
% y=file2str(series_path);

y = fileread(series_path);
xml=regexprep(y,'<[\/]{0,1}(\w*)[^\w\/> ]+(.*?)([ >])','<$1_$2$3');

% Get Contour Elements as a cell array
% contour elements contain all the pertinent information for a single trace
cstr = sprintf('<Contour.+?/>'); % a Countour element starts with <Contour and ends with />
contour_elements = regexp(xml,cstr,'match');
contour_names = string(regexp(contour_elements, '(?<=Contour name=").+?(?=")','match'))';

% Get number of vertices
ptstr = string(regexp(contour_elements, '(?<=points=").+?(?=")','match'))'; %[0-9,\s]
vert_count = count(ptstr,','); % number of commas = number of x,y vertices

% get edge
edgestr = regexp(contour_elements, '(?<=border=")[0-9.\s]+(?=")','match');
rgb_edge = single(cell2mat(cellfun(@(x) str2num(char(x)), edgestr','uni',false)));

% get fill
fillstr = regexp(contour_elements, '(?<=fill=")[0-9.\s]+(?=")','match');
no_fill = ~cellfun(@width,fillstr');
fillstr(no_fill) = {'0 0 0'};
rgb_fill = single(cell2mat(cellfun(@(x) str2num(char(x)), fillstr','uni',false)));

% Create table
TN = table(contour_names, vert_count, rgb_edge, rgb_fill,...
    'VariableNames', {'trace_name', 'vert_count','RGBfill', 'RGBedge'});

% Test for multiple traces with the same name
[~,uniq_idx] = unique(contour_names);

if numel(uniq_idx)<height(TN)    
    TTsum = varfun(@sum, TN(:,{'trace_name','vert_count'}), 'GroupingVariables', {'trace_name'});
    TN = join(TTsum, TN(uniq_idx, {'trace_name', 'RGBfill', 'RGBedge'}));
    TN.Properties.VariableNames = erase(TN.Properties.VariableNames,'sum_');
else
    TN.GroupCount = ones(height(TN),1);
end