function data = readMatFile()
% readMatFile Carga datos desde archivo.
%
% data = readMatFile() 
%
% Returns:
%
% - data: datos cargados.


data = [];

[filename, pathname] = uigetfile( ...
    {  '*.mat','MATLAB files (*.mat)';
    '*.*',  'All Files (*.*)'}, ...
    'Pick a file');

if pathname ~= 0
    
    data = load([pathname filename]);
    
end