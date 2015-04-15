function p3d = triangulations(P1, points1, P2, points2)
% triangulations Función de utilidad creada para realizar múltiples 
% triangulaciones.
%
% p3d = triangulations(P1, points1, P2, points2)
%
% - P1: matriz de proyección de la primera camara.
% - points1: puntos de la primera vista (nx2).
% - P2: matriz de proyección de la segunda camara.
% - points2: puntos de la segunda vista (nx2).
%
% Returns:
%
% - p3d: puntos 3D calculados usando triangulación (nx3).
%
% See also triangulate

    p3d = zeros(size(points1,1), 3);

    for i = 1:size(points1, 1)
        p3d(i,:) = triangulate(P1', points1(i,:), P2', points2(i,:));
    end

end