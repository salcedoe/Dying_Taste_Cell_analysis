function fTL = filter_trace_list(SL, TL, filter_str,exact_match)
%FILTER_TRACE_LIST create a filtered trace list from the TL table
% INPUTS:
% TL (table)          - Trace list 
% SL (table)          - Series List
% filter_str (string) - a string array contains object names (or substrings) 
%                       to be matched 
% exact_match (bool)  - true means find only exact matches (ignoring case), 
%                       while false indicates match substrings using
%                       contains
% OUTPUT:
% fTL (table): a subset of TL based on Object name matches


% build logical array of matches
row_la = false(height(TL),1); % initialize logical array
for n=1:numel(filter_str)
    if exact_match
        row_la = row_la | lower(TL.Object) == lower(filter_str(n)); 
    else % substring match ignore case
        row_la = row_la | contains(TL.Object, filter_str(n),'IgnoreCase',true);
    end
end

% create filtered list
fTL = TL(row_la,:); % create filter Trace List from logical array

% make sure filtered list is not empty
if isempty(fTL)
    beep
    disp('object not found')
    return
end

% add series information to fTL properties
series_range = min(fTL.Start):max(fTL.End);
actual_series_la = ismember(series_range,SL.series_index); % not all sections mapped
series_range(~actual_series_la)=[];
fTL.Properties.UserData.series_range = series_range;

