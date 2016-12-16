%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Heat conduction in 2D (Chapter 8)         %
% Haim Waisman, Columbia University         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all; 

% include global variables
include_flags;

% Preprocessing
[K,f,d] = preprocessor;

% Evaluate element conductance matrix, nodal source vector and assemble
for e = 1:nel        
    
    sctr = IEN(:,e);

	if strcmpi(use_iso_tri, 'yes') == 1
		[ke, fe] = heat2DelemBonus(e);
	else
		[ke, fe] = heat2Delem(e);
	end

    K(sctr,sctr) = K(sctr,sctr) + ke;
    f(sctr)      = f(sctr) + fe;    
end
fprintf('Average Half Bandwidth: %d\n', ahbw(K));

% Compute and assemble nodal boundary flux vector and point sources
f = src_and_flux(f);

% Solution
d = solvedr(K,f);

% Postprocessor
postprocessor(d);
