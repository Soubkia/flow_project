% partition and solve the system of equations
function [d] = solvedr(K,f)
include_flags;

% satisfy boundary conditions
for n=1:neq
   if (flags(n) == 2)
         f = f - K(:,n)*e_bc(n);                  
         K(n,:) = zeros(1,neq);
         K(:,n) = zeros(neq,1);
         K(n,n) = 1.0;
         f(n)   = e_bc(n);
   end
end


% solve the FE system
d = K \ f;