function [VL, lysT] = get_lys_metrics(VL)
%GET_LYS_METRICS calculates lysosome metrics, like volume and surface area
%
% OUTPUTS
% - VL: updated VL table with new size labels column to indicate the
%       relative size of the lyosomes
% - lysT: lysosome table with metrics of the lysosomes

arguments
    VL table % vertices list table
end

idT = VL.Properties.UserData.idT;

% la = idT.Structure == "lysosome";
%
% idt = idT(la,:);
% idt = sortrows(idt,"Object");

la = ismember(VL.Object, idT.Lysosome);
stats = groupsummary(VL(la,:),"Object","max","SegmentLabel");
% objects = unique(stats.Object)';


count = sum(stats.max_SegmentLabel);

z = zeros(count,1);
s = strings(count,1);
c = categorical(NaN(count,1));

lysT = table(s,c,c,c,c,z,z, VariableNames=["Object","Health","Type","TasteBud","Dataset","Volume","SurfaceArea"]);
idx = 1; % running index

% fix below
% lysT = table;
% VL_lys = VL(VL.Structure=="lysosome",:); % subtable of lysosomes

% suppress alpha shape warnings
id = 'MATLAB:alphaShape:DupPointsBasicWarnId';
warning('off',id);

for m=1:height(idT)

    object = idT.Lysosome(m);
    vl = VL(VL.Object == object,:); % subtable of current object

    PC = pointCloud(vl{:,["x" "y" "z"]}); % convert to point cloud
    SegLbl = vl.SegmentLabel;

    %     count = max(SegLbl);
    %     z = zeros(count,1);
    %     typename = repmat(vl.Type(1),count,1);
    %     objname = repmat(vl.Object(1),count,1);
    %     t = table(objname,typename,z,z,z,'VariableNames',["Object","Type","SegmentLabel","Volume","SurfaceArea"]);

    for n=unique(SegLbl)'

        la = SegLbl == n;
        PCselect = select(PC,la);

        if isscalar(unique(PCselect.Location(:,3))) % if just one z slice
            pts = PCselect.Location;
            pts = [pts;...
                pts(:,1:2) pts(:,3)+10]; % duplicate points to the next slice to create cylinder
        else
            pts = PCselect.Location;
        end

        %3D analysis
        shp3d = alphaShape(pts); % originally a setting of 2

        %2D Analysis - areas of individual traces
        grp2d = findgroups(pts(:,3));
        area2d = zeros(max(grp2d),1);
        for g=unique(grp2d)'
            la = grp2d == g;
            p = pts(la,1:2);
            shp2d = alphaShape(p);
            area2d(g) = shp2d.area;
        end

        % finalize table entry
        lysT.Object(idx) = object;

        % idt_la = idT.Lysosome == object;
        lysT.Cell(idx) = idT.Cell(m);
        lysT.Health(idx) = idT.Health(m);
        lysT.Type(idx) = idT.Type(m);
        lysT.TasteBud(idx) = idT.TasteBud(m);
        lysT.Dataset(idx) = idT.Dataset(m);
        lysT.SegmentLabel(idx) = n;

        lysT.Volume(idx) = shp3d.volume;
        lysT.SurfaceArea(idx) = shp3d.surfaceArea;

        lysT.TraceSum(idx) = sum(area2d);
        lysT.TraceMax(idx) = max(area2d);
        lysT.TraceMean(idx) = mean(area2d);
        lysT.TraceCount(idx) = height(area2d);

        lysT.verts{idx} = shp3d.Points;

        %         t.faces{n} = shp.BoundaryFacets;
        idx = idx + 1;
    end %labels
end % objects
warning('on',id)

lysT(lysT.Volume == 0,:) = []; % remove any 0 volumes
lysT.SAV = lysT.SurfaceArea./lysT.Volume;
lysT.SAV = lysT.SurfaceArea ./ lysT.Volume;

% generate a size label
lysT = sortrows(lysT,"Volume");
lysT.SizeLabel = (1:height(lysT))';

VL.SizeLabel = zeros(height(VL),1);

for n=1:height(lysT)
    la = VL.Object == lysT.Object(n) & VL.SegmentLabel == lysT.SegmentLabel(n);
    VL.SizeLabel(la) = lysT.SizeLabel(n);
end

type = lysT.Type;
type(lysT.Health == "dying") = 'd';
lysT.PlotSort = categorical(type,{'d','I','II','III','IV'},'ordinal',true);
% lysT.PlotSort = categorical(lysT.Type,{'x','I','II','III','IV'},'ordinal',true);

% save
project_path = fileparts(VL.Properties.UserData.file); % same folder as the VL file
lysT.Properties.UserData.path = fullfile(project_path,"lysT.mat");
save(lysT.Properties.UserData.path,"lysT");

save(VL.Properties.UserData.file,"VL")

end