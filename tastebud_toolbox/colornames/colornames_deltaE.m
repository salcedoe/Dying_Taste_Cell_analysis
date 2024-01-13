function colornames_deltaE(palette,rgb)
% Create a figure comparing the color difference (deltaE) calculations used in COLORNAMES.
%
% (c) 2017 Stephen Cobeldick
%
%%% Syntax:
%  colornames_deltaE(palette,rgb)
%
% Creates a figure showing the supplied colormap as horizontal color bands,
% overlaid with columns of the closest named colors from the selected
% palette. Each column shows one color difference (deltaE) calculation.
%
% Note: Requires the function COLORNAMES and its associated MAT file (FEX 48155).
%
% For more information on color difference concepts and formulae:
% https://en.wikipedia.org/wiki/Color_difference
% http://www.colorwiki.com/wiki/Delta_E:_The_Color_Difference
%
%% Examples %%
%
% colornames_deltaE('html4',jet(18))
%
% colornames_deltaE('x11',summer(18))
%
% colornames_deltaE('matlab',jet(18))
%
%% Input Arguments %%
%
% palette = String, the name of a palette supported by COLORNAMES.
% rgb     = Numeric Array, size Nx3, each row is an RGB triple (0<=rgb<=1).
%
% colornames_deltaE(palette,rgb)

% Get list of palettes and color difference metrics:
[fnm,fun] = colornames();
%
% Define default values:
if nargin<2
	N = 16;
	map = get(0,'defaultFigureColormap');
	rgb = interp1(linspace(1,N,size(map,1)),map,1:N);
end
if nargin<1
	palette = fnm{1+rem(round(now*1e7),numel(fnm))};
end
%
persistent fgh axh pth txh lbh
%
% Text lightness threshold:
thr = 0.54;
%
if isempty(fgh)||~ishghandle(fgh)
	fgh = figure('HandleVisibility','callback', 'IntegerHandle','off',...
		'NumberTitle','off', 'Name',mfilename, 'Color','white', 'Toolbar','none');
	axh = axes('Parent',fgh, 'Visible','off', 'XTick',[], 'YTick',[],...
		'Units','normalized', 'Position',[0,0,1,1]);
else
	delete(pth)
	delete(lbh)
	delete([txh{:}])
end
%
assert(ischar(palette)&&isrow(palette),'First input <palette> must be a string.')
idz = strcmpi(palette,fnm);
assert(any(idz),'Palette ''%s'' is not supported. Call COLORNAMES() to list all palettes.',palette)
set(fgh,'Name',sprintf('ColorNames DeltaE (palette = ''%s'')',fnm{idz}))
%
assert(ismatrix(rgb)&&size(rgb,2)==3&&isreal(rgb)&&all(0<=rgb(:)&rgb(:)<=1),...
	'Second input argument can be a colormap of RGB values (size Nx3).')
colormap(axh,rgb);
%
N = size(rgb,1);
x = [0;0;1;1];
y = [0;1;1;0];
X = repmat(x,1,N);
Y = bsxfun(@plus,y,N-1:-1:0);%0:N-1);
pth = patch(X,Y,1:N, 'Parent',axh, 'EdgeColor','none', 'FaceColor','flat', 'CDataMapping','direct');
%
dEn = numel(fun.deltaE);
[Nam,RGB] = cellfun(@(t)colornames(palette,rgb,t),fun.deltaE, 'UniformOutput',false);
BAW = cellfun(@(c)thr>c*[0.298936;0.587043;0.114021],RGB, 'UniformOutput',false);
%
tmp = @(s,c,b,n) text((2*n-1)*ones(1,N)/(2*dEn), mean(Y.',2), zeros(1,N), s,...
	'Parent',axh, 'HorizontalAlignment','center',...
	{'BackgroundColor'},num2cell(c,2), {'Color'},num2cell(b(:,[1,1,1]),2));
txh = cellfun(tmp, Nam, RGB, BAW, num2cell(1:dEn), 'UniformOutput',false);
%
set(axh,'YLim',[0,N+1]);
lbh = text((1:2:2*dEn)/(2*dEn), N+ones(1,dEn)/2, zeros(1,dEn), fun.deltaE(:),...
	'Parent',axh, 'HorizontalAlignment','center', 'Color','black');
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%colornames_deltaE