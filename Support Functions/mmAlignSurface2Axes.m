function [Verts, Vd] = mmAlignSurface2Axes(Verts)
%MMALIGNSURFACE2AXES transforms the vertices so that the direction of most
%variance is aligned to the x-axis. Based on the following discussion:
% https://www.mathworks.com/matlabcentral/answers/66051-how-do-i-move-a-cloud-of-points-in-3d-so-that-they-are-centered-along-the-x-axis
% INPUT and OUTPUT
% - Vert: Vertices to be transform

[~,~,Vd]=svd(Verts,0); % Find the direction of most variance
Verts =  Verts * Vd; %V(:,1) is the direction of most variance