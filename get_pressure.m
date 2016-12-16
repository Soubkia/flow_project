function [pressure] = get_pressure(d,e);
include_flags;


% get coordinates of element nodes 
sctr = IEN(:,e);  
de = d(sctr); % extract velocity potential at element nodes
C  = [x(sctr); y(sctr)]'; 

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

q(:,1) =  -D*B*de; % compute the flux 
q_x = q(1,:);
q_y = q(2,:);

const = 5;
pressure = const - 0.5*(q_x^2 + q_y^2); % from bernoulli
