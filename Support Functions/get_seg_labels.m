function VL = get_seg_labels(VL)
%GET_SEG_LABELS clusters seg labels by geometric distance and gives each
%lysosome a size label (relative size overall). 
% Size Label: a numeric ranking of lysosome volume (1 = smallest, height of table = largest), used for color maps


VL.SegmentLabel = zeros(height(VL),1);
for n=unique(VL.Object)'

    la = VL.Object==n;

    PC = pointCloud(VL{la,["x" "y" "z"]}); % convert to point cloud

    minDistance = 25;
    labels = pcsegdist(PC,minDistance);
    VL.SegmentLabel(la) = labels;
end

end