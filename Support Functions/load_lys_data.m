function [VL, cellT, idT] = load_lys_data(paths)

        if exist(fullfile(paths.lysosome,"lysosomesVL.mat"),"file")
            load(fullfile(paths.lysosome,"lysosomesVL.mat"),"-mat","VL")  % load VL
            load(fullfile(paths.lysosome,'cellT.mat'),"-mat","cellT") %cellT
            idT = VL.Properties.UserData.idT;
        end
end

