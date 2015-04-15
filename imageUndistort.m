function [imageRect, P] = imageUndistort(image, cameraParams)
% imageUndistort Elimina la distorsi�n de la lente de la image original 
% y calcula la matriz de proyecci�n.
%
% [imageRect, P] = imageUndistort(image, cameraParams)
%
% - image: imagen con distorsi�n.
% - cameraParams: par�metros de calibraci�n.
%
% Returns:
%
% - imageRect: imagen sin distorsi�n.
% - P: matriz de proyecci�n o matriz vac�a.
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