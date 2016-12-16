% Solves for the element stiffness matricies in the physical domain.
 function [ke, fe] = heat2Delem(e)
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

Ae = 0.5 * ((x2 * y3 - x3 * y2) - (x1 * y3 - x3 * y1) + (x1 * y2 - x2 * y1));
B = [ (y2 - y3) (y3 - y1) (y1 - y2)
      (x3 - x2) (x1 - x3) (x2 - x1) ];
B = (1 / (2 * Ae)) .* B;
ke = B' * B * Ae;
fe = [ 0 0 0 ]';
