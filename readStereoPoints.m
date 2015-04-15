function [points1, points2] = readStereoPoints(image1, image2)
% readStereoPoints Obtiene puntos de dos im�genes clicando sobre ellas.
%
% [points1, points2] = readStereoPoints(image1, image2)
%
% - image1 & image2: im�genes a procesar.
%
% Returns:
%
% - points1: puntos extra�dos de image1.
% - points2: puntos extra�dos de image2.
%
% See also ginput

    points1 = [];
    points2 = [];
    flag = true;

    figure; 
    
    while flag;
        imshow(image1);
        title('Click to get a point in the first image');        
        [x1, y1, button1] = ginput(1);
        
        if button1 == 1
            imshow(image2);
            title('Click to get a point in the second image');
            [x2, y2, button2] = ginput(1);
                
            if button2 == 1
                points1 = [points1; x1 y1];
                points2 = [points2; x2 y2];
            else
                flag = false;
            end
        else
            flag = false;
        end
    end
    
    close;
end