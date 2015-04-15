function boolean = num2bool(integer)
% num2bool Función de utilidad para obtener un valor lógico a partir
% del valor de un entero
%
% boolean = num2bool(integer)
%
% - intenger: número entero a evaluar.
%
% Returns:
%
% - boolean: valor lógico, false si integer = 0, true en otro caso.


if integer == 0
    boolean = false;
else
    boolean = true;
end