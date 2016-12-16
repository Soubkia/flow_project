% Solves for element stiffness matricies using isoparametric triangles in the
% natural domain. Can be toggled for use by setting `use_iso_tri` equal to
% "yes" in any `_inp.m` file.
function [ke, fe] = heat2DelemBonus(e)
include_flags;

ke  = zeros(nen,nen);    % initialized element conductance matrix
fe  = zeros(nen,1);      % initialize element nodal source vector

% get coordinates of element nodes 
je = IEN(:,e);  
C  = [x(je); y(je)]'; 

x1 = C(1,1);
x2 = C(2,1);
x3 = C(3,1);
y1 = C(1,2);
y2 = C(2,2);
y3 = C(3,2);

GNe = [ -1 1 0
        -1 0 1 ]; % GNe turns out to be a constant in the natural domain
Ae = 0.5 * 1 * 1;
J = GNe * [ x1 y1
            x2 y2
            x3 y3 ];
Be = inverse(J) * GNe;
ke = Be' * Be * det(J) * Ae;
fe = [ 0 0 0 ]';
