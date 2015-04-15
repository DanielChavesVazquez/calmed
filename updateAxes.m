function updateAxes(imageAxes, image, points)
% updateAxes Actualiza la información del eje
%
% updateAxes(imageAxes, image, points)
%
% - imageAxes: objeto axis. 
% - image: imagen a cargar en el eje.
% - points: puntos de interés recogidos para la imagen (nx2).

    axes(imageAxes);
    imshow(image, 'Parent', imageAxes);

    if ~isempty(points)

        hold on;
        plot(points(:,1), points(:,2), 'g.');

        for i = 1 : size(points, 1)
            text(points(i,1) + 2, points(i,2) + 2, num2str(i), 'Color', 'g');
        end

        hold off;
        axis off;
    end
end