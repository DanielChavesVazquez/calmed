function M = triangulate(P1, m1, P2, m2)
% triangulate calcula la localización del punto 3D haciendo uso de dos vistas 2D
%
% M = triangulate(P1, m1, P2, m2)
%
% P1: matriz de proyección de la primera cámara.
% m1: localización del píxel (x1, y1) en la primera vista. (1x2).
% P2: matriz de proyección de la segunda cámara.
% m2: localización del píxel (x2, y2) en la segunda vista. (1x2).
%
% Returns:
%
% M: la coordenada (x, y, z) del punto 3D reconstruido. (1x3).

%% Primera cámara
% Calculamos el centro óptico. Será utilizado junto con m1 para tener una
% recta
C1 = inv(P1(1:3, 1:3)) * (-P1(:,4));
x1 = C1(1);
y1 = C1(2);
z1 = C1(3);
m1 = [m1'; 1];
% Estimamos el punto M a partir de m1
M1 = pinv(P1) * m1;
x2 = M1(1)/M1(4);
y2 = M1(2)/M1(4);
z2 = M1(3)/M1(4);

%% Segunda cámara
% Calculamos el centro óptico. Será utilizado junto con m2 para tener una
% recta
C2 = inv(P2(1:3, 1:3)) * (-P2(:,4));
x3 = C2(1);
y3 = C2(2);
z3 = C2(3);
m2 = [m2'; 1];
% Estimamos el punto M a partir de m2
M2 = pinv(P2) * m2;
x4 = M2(1)/M2(4);
y4 = M2(2)/M2(4);
z4 = M2(3)/M2(4);

%  r = recta del punto (x1,y1,z1) al punto (x2,y2,z2)
%  s = recta del punto (x3,y3,z3) al punto (x4,y4,z4)
%
%  Esta funcion calcula el punto de interseccion de r y s
%  Si no se cortan, busca el punto medio en la zona más cercana
%
%  Los parametros pueden ser vectores, y los hace para diferentes 
% casos de forma vectorial
%
ux=x2-x1; uy=y2-y1; uz=z2-z1;  % u = vector director recta r
vx=x4-x3; vy=y4-y3; vz=z4-z3;  % v = vector director recta s

% Un punto generico de r es: (x1+ux*lambda , y1+uy*lambda , z1+uz*lambda)
% Un punto generico de s es: (x3+vx*mu , y3+vy*mu , z3+vz*mu)
% La recta perpendicular por la zona mas cercana sera de la forma:
%          PQ = (x1+ux*lambda - x3-vx*mu , y1+uy*lambda - y3-vy*mu , z1+uz*lambda - z3-vz*mu)
% Obligamos a que PQ sea perpendicular a u ==> prod. escalar PQ.u=0 ==> ecuacion primera
% Obligamos a que PQ sea perpendicular a v ==> prod. escalar PQ.v=0 ==> ecuacion segunda
%
% Resolvemos el sistema, y obtenemos lambda y mu
% Ec 1:  ux*(x1+ux*lambda-x3-vx*mu) + uy*(y1+uy*lambda-y3-vy*mu) + uz*(z1+uz*lambda-z3-vz*mu) =0
% Ec 2:  vx*(x1+ux*lambda-x3-vx*mu) + vy*(y1+uy*lambda-y3-vy*mu) + vz*(z1+uz*lambda-z3-vz*mu) =0
%
%                                  |  A    B  |   |lambda|   | E |
% Lo ponemos en forma matricial :  |          | * |      | = |   |
%                                  |  C    D  |   |  mu  |   | F |

A =  ux.*ux + uy.*uy + uz.*uz;   % Termino en lambda                          - Ec 1
B = -ux.*vx - uy.*vy - uz.*vz;   % Termino en mu                              - Ec 1
E = -(ux.*x1 - ux.*x3 + uy.*y1 - uy.*y3 + uz.*z1 - uz.*z3); % Termino indep.  - Ec 1

C = vx.*ux + vy.*uy + vz.*uz;   % Termino en lambda                           - Ec 2
D = -vx.*vx - vy.*vy - vz.*vz;   % Termino en mu                              - Ec 2
F = -(vx.*x1 - vx.*x3 + vy.*y1 - vy.*y3 + vz.*z1 - vz.*z3); % Termino indep.  - Ec 2

% Resolvemos el sistema de ecuaciones
lambda = -(B.*F - D.*E)./(A.*D - B.*C);
mu     =  (A.*F - C.*E)./(A.*D - B.*C);

% Obtenemos el punto medio entre el punto más cercano de r a s, y el más
% cercano de s a r
M = [(x1+ux.*lambda + x3+vx.*mu)/2, (y1+uy.*lambda + y3+vy.*mu)/2, (z1+uz.*lambda + z3+vz.*mu)/2];
%M = [x1+ux.*lambda, y1+uy.*lambda, z1+uz.*lambda];
%M = [x3+vx.*mu, y3+vy.*mu, z3+vz.*mu];
