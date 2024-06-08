% py.importlib.import_module("pyacvd")
import pyacvd.*
import pyvista.*
%% 
import pymeshfix.* 
import numpy.*

mshfx = py.pymeshfix.MeshFix(pyvarV, pyvarF);
%% 
mshfx.repair()
%% 
py.pymeshfix.clean_from_arrays(pyvarV, pyvarF)
%% 

[v,f]=pyrun(pymeshfix.clean_from_arrays,double(mesh.Vertices), double(mesh.Faces))
%% 
pcd = py.open3d.geometry.PointCloud()
pcd.points = py.open3d.utility.Vector3dVector(vCell)
%% 

py.open3d.io.write_point_cloud("tastecell.pcd", pcd)
%% 
eagle = py.open3d.data.EaglePointCloud()
pcd = py.open3d.io.read_point_cloud(eagle.path)


%% 

mesh = py.open3d.geometry.TriangleMesh.create_from_point_cloud_poisson(pcd, depth = int8(9))

%% 
% Import pymeshfix module
pymeshfix = py.importlib.import_module('pymeshfix');

% Clean mesh from file and save to another file
pymeshfix.clean_from_file('input.ply', 'output.ply');

%% 
from pyvista import examples
%% 
mesh = py.pyvista.examples.download_cow();
m = single(mesh.points); % returns vertices
%% 
mesh = py.pyvista.read("/Users/ernesto/PythonScripts/pyacvdTest/cow.stl");
%% 

pyvista.set_plot_theme("document")

% # download cow mesh
cow = examples.download_cow()

% cpos = [
%     (15.974333902609903, 8.426371781546546, -17.12964912391155),
%     (0.7761263847351074, -0.4386579990386963, 0.0),
%     (-0.23846635120392892, 0.9325600395795517, 0.2710453318595791),
% ]
% 
% 
% % # plot original mesh
% cow.plot(
%     show_edges=True,
%     color="w",
%     cpos=cpos,
%     screenshot="/home/alex/afrl/python/source/pyacvd/docs/images/cow.png",
% )
% 
% cpos = [
%     (7.927519161395299, 3.54223003919585, -4.1077249997544545),
%     (2.5251427740425236, 0.3910539874485469, 1.9812043586464985),
%     (-0.23846635120392892, 0.9325600395795517, 0.2710453318595791),
% ]
% 
% cow.plot(
%     show_edges=True,
%     color="w",
%     cpos=cpos,
%     screenshot="/home/alex/afrl/python/source/pyacvd/docs/images/cow_zoom.png",
% )
% 
% % # mesh is not dense enough for uniform remeshing
% % # must be an all triangular mesh to sub-divide
% cow.tri_filter(inplace=True)
% cow.subdivide(4, inplace=True)
% 
% clus = pyacvd.Clustering(cow)
% clus.cluster(20000)