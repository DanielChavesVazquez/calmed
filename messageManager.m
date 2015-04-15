function messageManager(parent, severity, message)
% messageManager Gestiona los mensajes de la aplicación.
%
% messageManager(parent, severity, message)
%
% - parent: componente de la UI en la que se insertan los mensajes.
% - severity: gravedad del mensaje (info, warning, error, success).
% - message: mensaje mostrado.

if strcmp(severity,'info')
    set(parent,'String',message, 'ForegroundColor', 'blue');
    
else if strcmp(severity,'warning')
        set(parent,'String',message, 'ForegroundColor', 'yellow');
        
    else if strcmp(severity,'error')
            set(parent,'String',message, 'ForegroundColor', 'red');
            
        else if strcmp(severity,'success')
                set(parent,'String',message, 'ForegroundColor', 'green');
            end
        end
    end
end