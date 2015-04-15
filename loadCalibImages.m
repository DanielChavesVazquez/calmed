function [imgPoints, boardSize, images, files] = loadCalibImages(pathname, filename)
% loadCalibImages Carga en memoria las im�genes indicadas en filename y
% a�ade aquellas en las que se detecte un patr�n de calibrado.
%
% [imgPoints, boardSize, images, files] = loadCalibImages(pathname, filename)
%
% - pathname: ruta del directorio en el que se encuentran las im�genes.
% - filename: cell array con los nombres de las im�genes
    
    imgPoints = [];
    images = {};
    files = {};
    j = 1;
    bp = waitbar(0,'Detecting patterns on files','Name', 'Please wait');    
    % Load images
    for i = 1:length(filename)
        
        file = [pathname,filename{i}];
        img = imread(file);
        
        [imagePoints, boardSize] = detectCheckerboardPoints(img);
        
        if ~isempty(imagePoints)
            imgPoints(:,:,j) = imagePoints;
            boardSize = boardSize;
            images{j} = imread(file);
            files{j} = filename{i};
            j = j+1;
        end
        % Waitbar update
        waitbar(i/length(filename),bp,sprintf('%d / %d images processed',i, length(filename)));
    end
            
    close(bp);

