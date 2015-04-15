function [imageRect, P] = imageUndistort(image, cameraParams)
% imageUndistort Elimina la distorsión de la lente de la image original 
% y calcula la matriz de proyección.
%
% [imageRect, P] = imageUndistort(image, cameraParams)
%
% - image: imagen con distorsión.
% - cameraParams: parámetros de calibración.
%
% Returns:
%
% - imageRect: imagen sin distorsión.
% - P: matriz de proyección o matriz vacía.
%
% See also undistortImage, detectCheckerboardPoints, extrinsics,
% cameraMatrix



P = [];

imageRect = undistortImage(image, cameraParams, 'OutputView', 'full');
imagePoints = detectCheckerboardPoints(imageRect);

if ~isempty(imagePoints)
    
    [rotationMatrix, translationVector] = extrinsics(imagePoints, cameraParams.WorldPoints, cameraParams);
    P = cameraMatrix(cameraParams, rotationMatrix, translationVector);
    
end