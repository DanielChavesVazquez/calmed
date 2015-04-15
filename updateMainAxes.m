function updateMainAxes(mainAxes, image, imagePoints)
% updateMainAxes Actualiza el contenido del eje central.
%
% updateMainAxes(mainAxes, imageName, imagePoints)
%
% - mainAxes: objeto axis.
% - image: imagen a mostrar.
% - imagePoints: puntos del patrón detectado (nx2).

if (strcmp(image, 'null'))
    cla;
    set(mainAxes, 'Visible', 'off');
    legend('off');
else
    % Update component state
    set(mainAxes, 'Visible', 'on');
    axes(mainAxes);
    cla;
    imshow(image, 'Parent', mainAxes);
    
    % Pattern detection info
    hold on;
    plot(imagePoints(:,1), imagePoints(:,2), 'go');
    plot(imagePoints(1,1), imagePoints(1,2), 'ro');
    legend('Detected points', 'Pattern origin');
    hold off;
    axis off;
end