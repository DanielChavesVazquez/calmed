function image = readImage()
% readImage Carga una imagen desde archivo escogida por el usuario.
%
% image = readImage() 
%
% Returns: 
%
% - image: imagen cargada.

image = [];

[filename, pathname] = uigetfile( ...
    {  '*.tif','TIFF images (*.tif)'; ...
    '*.jpg;*.jpeg','JPG images (*.jpg, *.jpeg)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Pick a file');

if pathname ~= 0
    
    image = imread([pathname filename]);
    
end