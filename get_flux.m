% Gets and plots the flux by direct construction in the physical domain.
% Minimal modifications made. Can be toggled for use by setting `compute_flux`
% equal to "yes" in any `_inp.m` file.
function get_flux(d,e);
include_flags;


% get coordinates of element nodes 
sctr = IEN(:,e);  
de = d(sctr);    % extract temperature at  element nodes
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

X(1,:) =  [ mean(C(:,1)) mean(C(:,2)) ];  % centroid of the triangle
q(:,1) =  -D*B*de;                        % compute the flux 

q_x = q(1,:);
q_y = q(2,:);

%          #x-coord     y-coord    q_x(eta,psi)  q_y(eta,psi)
flux_e1  = [X(:,1)       X(:,2)        q_x'              q_y'];
fprintf(1,'\t\t\tx-coord\t\t\t\ty-coord\t\t\t\tq_x\t\t\t\t\tq_y\n');
fprintf(1,'\t\t\t%f\t\t\t%f\t\t\t%f\t\t\t%f\n',flux_e1');

if strcmpi(plot_flux,'yes')==1 & strcmpi(plot_mesh,'yes') ==1;  
    figure(1); 
    quiver(X(:,1),X(:,2),q_x',q_y',0.3,'k');
    plot(X(:,1),X(:,2),'rx');
    title('Heat Flux');
    xlabel('X');
    ylabel('Y');
end

