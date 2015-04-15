function m = measures (points)
% measures Calcula distancias entre puntos.
%
% m = measures (points)
%
% - points: matriz de puntos 3D (nx3).
%
% Returns:
%
% - m: matriz con las medidas.

    f = size(points, 1);
    m = zeros(f, f);
    
    for i = 1:f
        for j = i+1:f
                m(i,j) = measure(points(i,:), points(j,:));
        end
    end
end

function d = measure(p1, p2)
% measures Calcula la distancia entre dos puntos.
%
% d = measure (p1, p2)
%
% - p1: punto 3D (1x3).
% - p2: punto 3D (1x3).
%
% Returns:
%
% - d: distancia entre los dos puntos.

d = sqrt((p1(1) - p2(1))^2 + (p1(2) - p2(2))^2 + (p1(3) - p2(3))^2);
end