function [SL,TL] = get_series_contents(series_path, load_file)
%GET_SERIES_CONTENTS scans indicated Reconstruct Project folder for the required series files and
%compiles necessary data
% INPUTS:
% - series_path (ch array): path the folder 
% - load_file (boolean): if true, loads previously created files
%
% OUTPUTS:
% - SL (table): series list, contains file names and corresponding section indices
%               - SL USERDATA: TN - a table containing all the unique trace names in each series file
% - TL (table): trace list, a table containing trace info
% ---
% AUTHOR: Ernesto Salcedo, PhD
% SITE: University of Colorado School of Medicine

%% GET paths

if load_file && exist(fullfile(series_path, 'SeriesTrace.mat'),'file')
    load(fullfile(series_path, 'SeriesTrace.mat'),'SL', 'TL')

    if ~strcmp(SL.Properties.UserData.paths.series, series_path)
        SL.Properties.UserData.paths.series = series_path;
        SL.Properties.UserData.paths.analysis = fileparts(mfilename('fullpath'));
        save(fullfile(series_path, 'SeriesTrace.mat'), 'SL', 'TL')
    end

    disp('loading saved trace and series info...')
    return
end

%% series file names
% find extentions that are numbers
content_series = dir(fullfile(series_path,'*.*'));
content_series([content_series.isdir]) = [];
exts = extractAfter(string({content_series.name}'),'.');
extASnums = str2double(exts);
[series_section_index,sort_idx] = sort(extASnums);
content_series = content_series(sort_idx);

SL = table(string({content_series.name}'), series_section_index,...
    'VariableNames', {'series_names', 'series_index'});

SL(isnan(SL.series_index),:) = [];

paths.analysis = fileparts(mfilename('fullpath')); % get directory of current folder;
paths.series = series_path;
SL.Properties.UserData.paths = paths;

%%
SL.trace_count = zeros(height(SL),1,'uint16');

hwb = waitbar(0, 'Counting unique traces in all trace files...');
for n=1:height(SL)
    tn = get_all_trace_names(SL, SL.series_index(n)); % from a single file
    tn_uniq = unique(tn.trace_name);
    SL.trace_count(n) = numel(tn_uniq);
    waitbar(n/height(SL),hwb, sprintf('Slice %d',n) ) % 'getting trace counts for preallocation...'
end
delete(hwb)

%% Get trace names
total_trace_count = sum(SL.trace_count);
TN = table(strings(total_trace_count, 1), zeros(total_trace_count,1,'uint16'), strings(total_trace_count, 1),...
    zeros(total_trace_count,3,'single'),  zeros(total_trace_count,3,'single'), ...
    'VariableName',{'series_name','series_index','trace_name','RGBfill','RGBedge'});

TNidx = [0; cumsum(SL.trace_count)];
hwb = waitbar(0, 'Compiling unique traces from all trace files...');
for n=1:height(SL)    
tn = get_all_trace_names(SL, SL.series_index(n)); % from a single file
[tn_uniq,ia] = unique(tn.trace_name);

TN(TNidx(n)+1:TNidx(n+1),:) = [table(repmat(SL.series_names(n), SL.trace_count(n), 1), repmat(SL.series_index(n), SL.trace_count(n), 1), tn_uniq, ...
    'VariableName',{'series_name','series_index','trace_name'}) tn(ia,{'RGBfill','RGBedge'})];

waitbar(n/height(SL),hwb, 'Compiling unique traces from all trace files...')
end
delete(hwb)

%% Get Trace List

[Object, ia, ic] = unique(TN.trace_name,'first');

Indices = cell(numel(Object),1);
for n=1:numel(Object)
    Indices{n} = TN.series_index(TN.trace_name == Object(n));
end

Count = accumarray(ic,1);
Start = TN.series_index(ia);
[~,ia] = unique(TN.trace_name,'last');
End = TN.series_index(ia);
TL = [table(Object, Start, End, Indices, Count) TN(ia,{'RGBfill','RGBedge'})];

%%
save(fullfile(series_path, 'SeriesTrace.mat'), 'SL', 'TL')