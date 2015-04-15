function boolean = num2bool(integer)
% num2bool Funci�n de utilidad para obtener un valor l�gico a partir
% del valor de un entero
%
% boolean = num2bool(integer)
%
% - intenger: n�mero entero a evaluar.
%
% Returns:
%
% - boolean: valor l�gico, false si integer = 0, true en otro caso.


if integer == 0
    boolean = false;
else
    boolean = true;
end