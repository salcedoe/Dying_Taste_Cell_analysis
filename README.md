# Dying Taste Cell analysis

Scripts and sample data featured in our "Death in the taste bud:
Morphological features of dying taste cells and implications for a novel role for Type I Cells." 

Courtney E. Wilson, Robert S. Lasher, Ernesto Salcedo, Ruibiao Yang, Yannick Dzowo, John C. Kinnamon, Thomas E. Finger.

## Additional Requirements

- [the MatGeom Library][1]
- [ManifoldPlus](https://github.com/hjwdzh/ManifoldPlus) - helps make watertight meshes
- [pyMeshFix](https://pymeshfix.pyvista.org) - helps make watertight meshes even more.
- [The Mathworks Lidar Toolbox](https://www.mathworks.com/products/lidar.html) - for surface mesh display, read, and write functions

## Computer Specifications

Software developed using MATLAB 2023b on a Macintosh computer with an Apple M1 Pro Apple silicon chip running OS X 14.2.1 (Sonoma). Trace Data collection was run on a PC computer running Windows 10Pro using Legacy Reconstruct: https://synapseweb.clm.utexas.edu 

## MATLAB online

You can review and run the scripts on MATLAB online by clicking on the following:

[![Open in MATLAB Online][image-1]][2]

Please note:
- You will need to sign up for [MATLAB Online][3] account if you don't have one already (contrary to popular belief, there is a free version). 

## Lysosome Analysis

Live scripts were run in this order

1. [generate_VL_lysT.mlx](/Lysosome%20Analysis/generate_VL_lysT.mlx) - Imports traces from Reconstruct into a MATLAB table, `VL`. Also generates a table, `lysT` that organizes the lysosome metrics, like volume.
2. [generate_cellMesh_cellT.mlx][4] - Generates 3D surface meshes of taste cells, which are save to the cellMeshes folder. Generates the `cellT` table that organizes calculated cell metrics, like volume and surface area.
3. [generate_dyingMesh_dyingT.mlx](/Lysosome%20Analysis/generate_dyingMesh_dyingT.mlx) - similar to the [generate_cellMesh_cellT.mlx][4] script, this script generates 3D surface meshes for dying cells and a MATLAB table, `dyingT`, that organizes the calculated metrics for dying cells.
4. [cell_viz_stats.mlx](/Lysosome%20Analysis/cell_viz_stats.mlx) - visualize cell surface meshes as MATLAB patch plots. Calculate the statistics on cell volumes.
5. [lys_viz_stats.mlx](/Lysosome%20Analysis/lys_viz_stats.mlx) - visualizes the lysosomes as 3D patch plots. Calculates the statistics on lysosome volumes.
6. [lys_cell_stats.mlx](/Lysosome%20Analysis/lys_cell_stats.mlx) - Calculates the stats on the lysosome per cell metrics (e.g. Total Lysosome volume per cell)



[1]: https://github.com/mattools/matGeom
[2]: https://matlab.mathworks.com/open/github/v1?repo=salcedoe/Dying_Taste_Cell_analysis&file=nuclei_display.mlx
[3]: https://www.mathworks.com/products/matlab-online.html
[4]: /Lysosome%20Analysis/generate_cellMesh_cellT.mlx

[image-1]: https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg

#MATLAB #Reconstruct