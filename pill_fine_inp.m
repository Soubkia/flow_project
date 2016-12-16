% material properties
k  = 1;        % thermal conductivity
D  = k*eye(2); % conduction matrix

% mesh specifications
nsd  = 2;         % number of space dimensions
nnp  = 651;     % number of nodal nodes
nel  = 1174;     % number of elements
nen  = 3;         % number of element nodes 
ndof = 1;         % degrees-of-freedom per node
neq  = nnp*ndof;  % number of equations


f = zeros(neq,1);         % initialize nodal flux vector
d = zeros(neq,1);         % initialize nodal temperature vector vector
K = zeros(neq);           % initialize stiffness matrix

flags = zeros(neq,1);     % array to set B.C flags 
e_bc  = zeros(neq,1);     % essential B.C array
n_bc  = zeros(neq,1);     % natural B.C array
P     = zeros(neq,1);     % initialize point source defined at a node 
s     = 6*ones(nen,nel);  % constant heat source defined over the nodes

ngp    = 2;           % number of gauss points in each direction

% essential BCs
nd   = 1;              % number of nodes on essential boundary
flags   = [0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];        % value is 2 if node is essential
e_bc = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];            % array of values alond e_bc


% what to plot
compute_flux = 'yes';
plot_mesh    = 'yes';
plot_nod     = 'yes';
plot_temp    = 'yes';
plot_flux    = 'yes';


% natural BC - defined on edges positioned on natural boundary
n_bc  = [47 46 45 44 43 42 41 3 94 93 92 91 90 89 88 8 10 111 117 113 116 114 115 112 5 148 154 150 153 151 152 149
5 47 46 45 44 43 42 41 10 94 93 92 91 90 89 88 111 112 11 114 117 115 116 113 148 149 16 151 154 152 153 150
1 1 1 1 1 1 1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 1 1 1 1 1 1 1
1 1 1 1 1 1 1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 1 1 1 1 1 1 1]; % node 1, node 2, value 1, value 2
        
nbe = 32;    % number of edges on the natural boundary


% mesh generation

x   = [0.0 0.0 5.0 0.589246213 5.0 0.0 0.0 -5.0 -0.589246213 -5.0 -5.0 -0.58926034 -1.17850661 0.58926034 1.17850661 5.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.277777791 0.555555582 0.833333313 1.11111116 1.38888884 1.66666663 1.94444442 2.22222233 2.5 2.77777767 3.05555558 3.33333325 3.61111116 3.88888884 4.16666651 4.44444466 4.72222233 5.0 5.0 5.0 5.0 5.0 5.0 5.0 0.392830819 0.196415409 4.70594978 4.41189957 4.11784935 3.82379889 3.52974868 3.23569846 2.94164824 2.64759803 2.35354781 2.05949759 1.76544726 1.47139692 1.17734671 0.88329649 0.0 0.0 0.0 0.0 0.0 0.0 0.0 -0.277777791 -0.555555582 -0.833333313 -1.11111116 -1.38888884 -1.66666663 -1.94444442 -2.22222233 -2.5 -2.77777767 -3.05555558 -3.33333325 -3.61111116 -3.88888884 -4.16666651 -4.44444466 -4.72222233 -5.0 -5.0 -5.0 -5.0 -5.0 -5.0 -5.0 -0.392830819 -0.196415409 -4.70594978 -4.41189957 -4.11784935 -3.82379889 -3.52974868 -3.23569846 -2.94164824 -2.64759803 -2.35354781 -2.05949759 -1.76544726 -1.47139692 -1.17734671 -0.88329649 -5.0 -5.0 -5.0 -5.0 -5.0 -5.0 -5.0 -4.70588255 -4.41176462 -4.11764717 -3.82352948 -3.52941179 -3.2352941 -2.94117641 -2.64705873 -2.35294127 -2.05882359 -1.7647059 -1.47058821 -1.17647064 -0.882352948 -0.588235319 -0.294117659 -0.196420118 -0.392840236 -0.883883476 -1.17850661 -1.30054343 -0.98208648 -0.785666347 0.196420118 0.392840236 0.883883476 1.17850661 1.30054343 0.98208648 0.785666347 5.0 5.0 5.0 5.0 5.0 5.0 5.0 4.70588255 4.41176462 4.11764717 3.82352948 3.52941179 3.2352941 2.94117641 2.64705873 2.35294127 2.05882359 1.7647059 1.47058821 1.17647064 0.882352948 0.588235319 0.294117659 0.206585705 0.216756001 0.226926297 0.237096593 0.247266889 0.257437199 0.26760748 0.413171411 0.433512002 0.453852594 0.474193186 0.494533777 0.514874399 0.535214961 0.619757116 0.650268018 0.680778861 0.711289763 0.741800666 0.772311568 0.802822471 0.911773324 0.940250158 0.968726993 0.997203767 1.02568066 1.0541575 1.08263433 1.20378947 1.23023224 1.256675 1.28311777 1.30956054 1.3360033 1.36244607 1.49580574 1.52021444 1.54462314 1.56903183 1.59344053 1.61784923 1.64225793 1.78782189 1.81019652 1.83257115 1.85494578 1.87732053 1.89969516 1.92206979 2.07983804 2.10017872 2.12051916 2.14085984 2.16120052 2.18154097 2.20188165 2.37185431 2.3901608 2.40846729 2.42677379 2.44508052 2.46338701 2.48169351 2.66387057 2.68014288 2.69641542 2.71268797 2.72896028 2.74523282 2.76150537 2.9558866 2.97012496 2.98436356 2.99860191 3.01284027 3.02707863 3.04131722 3.24790287 3.26010728 3.27231145 3.28451586 3.29672027 3.30892467 3.32112908 3.53991914 3.55008936 3.56025958 3.57043004 3.58060026 3.59077048 3.6009407 3.83193517 3.84007144 3.84820771 3.85634398 3.86448026 3.87261653 3.88075256 4.12395144 4.13005352 4.13615561 4.14225817 4.14836025 4.15446234 4.16056442 4.41596746 4.42003584 4.42410374 4.42817211 4.43224001 4.43630838 4.44037628 4.70798397 4.71001768 4.71205187 4.71408606 4.71612024 4.71815395 4.72018814 -0.206585705 -0.216756001 -0.226926297 -0.237096593 -0.247266889 -0.257437199 -0.26760748 -0.413171411 -0.433512002 -0.453852594 -0.474193186 -0.494533777 -0.514874399 -0.535214961 -0.619757116 -0.650268018 -0.680778861 -0.711289763 -0.741800666 -0.772311568 -0.802822471 -0.911773324 -0.940250158 -0.968726993 -0.997203767 -1.02568066 -1.0541575 -1.08263433 -1.20378947 -1.23023224 -1.256675 -1.28311777 -1.30956054 -1.3360033 -1.36244607 -1.49580574 -1.52021444 -1.54462314 -1.56903183 -1.59344053 -1.61784923 -1.64225793 -1.78782189 -1.81019652 -1.83257115 -1.85494578 -1.87732053 -1.89969516 -1.92206979 -2.07983804 -2.10017872 -2.12051916 -2.14085984 -2.16120052 -2.18154097 -2.20188165 -2.37185431 -2.3901608 -2.40846729 -2.42677379 -2.44508052 -2.46338701 -2.48169351 -2.66387057 -2.68014288 -2.69641542 -2.71268797 -2.72896028 -2.74523282 -2.76150537 -2.9558866 -2.97012496 -2.98436356 -2.99860191 -3.01284027 -3.02707863 -3.04131722 -3.24790287 -3.26010728 -3.27231145 -3.28451586 -3.29672027 -3.30892467 -3.32112908 -3.53991914 -3.55008936 -3.56025958 -3.57043004 -3.58060026 -3.59077048 -3.6009407 -3.83193517 -3.84007144 -3.84820771 -3.85634398 -3.86448026 -3.87261653 -3.88075256 -4.12395144 -4.13005352 -4.13615561 -4.14225817 -4.14836025 -4.15446234 -4.16056442 -4.41596746 -4.42003584 -4.42410374 -4.42817211 -4.43224001 -4.43630838 -4.44037628 -4.70798397 -4.71001768 -4.71205187 -4.71408606 -4.71612024 -4.71815395 -4.72018814 -0.249068752 -0.204705238 -0.222408444 -0.237732664 -1.27277613 -3.08870769 -3.67655683 -4.59634733 -4.27484369 -2.79473567 -1.61289799 -3.97091079 -3.38262701 -2.50248003 -2.21549916 -3.97221303 -3.67670751 -1.32637262 -3.38239288 -2.79415774 -2.500103 -2.20602107 -1.91190195 -1.61922395 -0.716103017 -0.458379984 -3.08825135 -1.03700066 -4.27928448 -4.75614929 -4.72975063 -4.73299217 -1.13056898 -1.51362014 -1.46693122 -0.645371795 -0.458864629 -0.168229908 -0.432918042 -1.02023447 -1.92325199 -2.94206333 -2.65237808 -3.23564982 -4.12004232 -3.82426691 -3.52936316 -2.37454605 -4.60150003 -2.94132209 -2.3512218 -2.05334425 -3.52929044 -3.82696557 -2.64712262 -1.7582866 -1.46861553 -1.1955843 -0.935606956 -3.23529124 -4.1277957 -0.894539595 -4.73658228 -4.73045921 -4.45328856 -1.40760183 -1.65300679 -0.680567324 -0.381592333 -4.46046972 -1.79464579 -1.31523752 -1.71599567 -1.84302306 -2.09804916 -3.08923674 -3.38242149 -3.67879677 -2.79915595 -2.51355219 -3.97482157 -3.6815145 -3.38332939 -3.08886743 -2.79536152 -1.8950845 -1.59347022 -2.50028682 -2.2029264 -3.98075867 -4.45298958 -4.45984364 -4.46601486 -2.05774546 -3.82788157 -2.9439826 -3.82467413 -3.53011918 -2.65293598 -2.65133595 -2.3677218 -4.23257875 -2.94324803 -3.23629093 -1.09430742 -3.23628068 -3.53136635 -2.01404762 -4.24004984 -4.75595951 -4.15090132 -4.14703274 -2.79957819 -3.09035683 -3.67165399 -2.51401615 -3.38267803 -2.10546803 -2.33423138 -3.92442894 -2.27583647 -2.26688528 0.249818057 0.213152185 0.248328447 1.27274156 3.67681241 4.59633732 4.27482271 3.97114921 3.38272667 2.50069189 2.2082684 1.6094048 3.08874774 1.91272938 2.79475474 1.61890018 3.67635083 3.97213721 3.38229156 2.7941494 2.50008178 2.20601988 1.912305 1.3274821 0.734109402 0.484858513 3.08823395 1.03243434 4.27924919 4.75613546 4.72967386 4.73291445 1.12838602 1.50633264 1.45963514 0.651837885 0.171137452 0.261271596 0.455453843 1.02022755 3.82286215 3.529423 2.64826941 2.35691214 3.2358551 4.12019539 2.06550312 2.9421618 4.6014924 3.8266263 2.35173392 2.05345035 2.94129229 1.47082067 1.75715256 3.52959132 2.64714098 0.535965204 1.18586075 0.878234804 3.23528504 4.12758064 0.88530004 4.7365489 4.73041439 4.45308208 1.40666044 1.62894928 0.388443291 0.681358337 4.46037197 1.76782835 1.31241262 1.70294964 1.82467723 3.38249588 2.79622793 3.08955121 3.67830825 2.51052594 2.23806381 3.97440553 3.38194776 2.79420853 3.08850503 2.49351549 1.58963037 3.68076086 2.18697381 1.88318801 3.98022819 4.45296574 4.4597168 4.46581364 2.01571441 3.53146768 3.53192019 3.8246057 3.82769465 2.33483863 2.64304304 2.65642929 3.23661566 4.23243284 2.94393492 2.4145937 3.23616767 1.07803881 2.94111848 4.23973608 4.7559433 1.94918907 4.15057373 4.14677095 2.18213058 3.67181563 3.38290906 2.50439215 2.79639769 3.08952379 3.92429209];
y   = [-0.589246213 -2.5 -2.5 0.0 0.0 0.589246213 2.5 2.5 0.0 0.0 -2.5 -1.17850661 -0.58926034 1.17850661 0.58926034 2.5 -0.828090429 -1.0669347 -1.30577886 -1.54462314 -1.78346729 -2.02231145 -2.26115584 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.1875 -1.875 -1.5625 -1.25 -0.9375 -0.625 -0.3125 -0.196415409 -0.392830819 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.828090429 1.0669347 1.30577886 1.54462314 1.78346729 2.02231145 2.26115584 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.1875 1.875 1.5625 1.25 0.9375 0.625 0.3125 0.196415409 0.392830819 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -2.5 -0.785666347 -0.98208648 -1.30054343 -1.17850661 -0.883883476 -0.392840236 -0.196420118 0.785666347 0.98208648 1.30054343 1.17850661 0.883883476 0.392840236 0.196420118 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 -0.656226993 -0.919623137 -1.18301928 -1.44641542 -1.70981157 -1.97320771 -2.23660374 -0.484363496 -0.772311568 -1.06025958 -1.34820771 -1.63615572 -1.92410386 -2.21205187 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 -0.3125 -0.625 -0.9375 -1.25 -1.5625 -1.875 -2.1875 0.656226993 0.919623137 1.18301928 1.44641542 1.70981157 1.97320771 2.23660374 0.484363496 0.772311568 1.06025958 1.34820771 1.63615572 1.92410386 2.21205187 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 0.3125 0.625 0.9375 1.25 1.5625 1.875 2.1875 -1.16470861 -1.62949896 -1.88878322 -2.16101623 -0.294077754 -0.254806489 -0.255533934 -0.276826739 -0.270957142 -0.255178332 -0.289847076 -0.258891404 -0.255035102 -0.254824549 -0.262132376 -2.2439115 -2.24492574 -2.24074054 -2.24520612 -2.24512005 -2.24476027 -2.24420404 -2.24348044 -2.24185753 -2.18735123 -2.27507877 -2.2452209 -2.22595382 -2.2316134 -1.99019194 -1.09048951 -1.40932226 -1.50818694 -1.14797819 -0.580948293 -1.51982236 -2.01175404 -1.41569245 -1.72072053 -0.176667631 -0.273601204 -0.510283709 -0.509218037 -0.510092437 -0.530074835 -0.517252624 -0.511768937 -0.507055283 -2.22249198 -1.99018419 -1.98383379 -1.97653532 -1.99011993 -1.98675168 -1.98858726 -1.97469795 -1.97990549 -1.97975802 -1.94016755 -1.99029803 -1.97174537 -1.64482093 -1.72279429 -0.778188765 -1.25297225 -1.44783568 -0.85555166 -1.83743942 -1.43815827 -1.91926217 -0.562128127 -1.7304064 -1.41730058 -1.13039005 -0.529750049 -0.765431941 -0.764545798 -0.769515812 -0.763362944 -0.752545536 -0.782701671 -1.73295879 -1.73995161 -1.74230039 -1.73977351 -1.69517589 -1.70755363 -1.72756433 -1.70621502 -1.72221327 -0.582020819 -0.925694227 -1.5786761 -1.39719033 -1.48478293 -1.01219392 -1.02558208 -1.0162468 -1.48797214 -1.00389993 -1.46845138 -0.778262377 -1.49720049 -1.01286185 -1.76066792 -1.4981364 -1.49573302 -0.846490383 -1.72754192 -0.514907241 -1.44187534 -1.0661726 -1.25164211 -1.25493729 -1.2560091 -1.24205768 -1.2556541 -1.12289035 -0.991389513 -1.25488448 -1.24439585 -0.725446165 1.16345608 1.622244 1.87850988 0.294059813 0.255377263 0.276813179 0.270940989 0.258736014 0.255091161 0.256115913 0.268536329 0.29317078 0.25524497 0.283553123 0.255668581 2.24227548 2.24475813 2.24337268 2.24502993 2.24505711 2.24475408 2.24416709 2.243083 2.24226832 2.24333715 2.2799561 2.24510241 2.23555207 2.23118949 1.99003732 1.09048223 1.40923631 1.5030967 1.15245032 0.586566925 1.49366677 1.41223741 2.1567142 1.69446242 0.176664039 0.514413714 0.511181116 0.512423873 0.529338896 0.510671318 0.530331075 0.553468943 0.51132369 2.22229075 1.98595035 1.98465002 1.97626579 1.9899621 1.98294353 1.97473145 1.98906398 1.98864698 1.9918685 1.98105824 1.93965757 1.98985827 1.9709965 1.62339938 1.72256327 0.778163552 1.25325894 1.44850934 0.863165021 1.42742884 1.74861097 1.91883409 0.570888877 1.73034263 1.42589784 1.13869655 0.766355217 0.766242921 0.76628083 0.77205956 0.77019006 0.80127126 0.784363031 1.74064231 1.73838222 1.74341667 1.72486949 1.70905185 1.73615611 1.70777392 1.70272005 1.72445369 0.582012355 0.92591387 1.5786711 1.42401981 1.0214169 1.49882889 1.02973032 1.48914587 1.44729006 1.48131645 1.00336659 1.01665843 0.778937459 1.01105118 0.983956039 1.50148988 1.75551093 1.49639392 1.72798324 0.514897823 0.841691494 1.44391131 1.06827354 1.12274563 1.2608242 1.2599299 1.21534526 1.24463916 1.25502706 1.25837708];

IEN = [1 17 171
171 49 1
17 18 172
172 171 17
18 19 173
173 172 18
19 20 174
174 173 19
20 21 175
175 174 20
21 22 176
176 175 21
22 23 177
177 176 22
23 2 24
24 177 23
49 171 178
178 48 49
171 172 179
179 178 171
172 173 180
180 179 172
173 174 181
181 180 173
174 175 182
182 181 174
175 176 183
183 182 175
176 177 184
184 183 176
177 24 25
25 184 177
48 178 185
185 4 48
178 179 186
186 185 178
179 180 187
187 186 179
180 181 188
188 187 180
181 182 189
189 188 181
182 183 190
190 189 182
183 184 191
191 190 183
184 25 26
26 191 184
4 185 192
192 63 4
185 186 193
193 192 185
186 187 194
194 193 186
187 188 195
195 194 187
188 189 196
196 195 188
189 190 197
197 196 189
190 191 198
198 197 190
191 26 27
27 198 191
63 192 199
199 62 63
192 193 200
200 199 192
193 194 201
201 200 193
194 195 202
202 201 194
195 196 203
203 202 195
196 197 204
204 203 196
197 198 205
205 204 197
198 27 28
28 205 198
62 199 206
206 61 62
199 200 207
207 206 199
200 201 208
208 207 200
201 202 209
209 208 201
202 203 210
210 209 202
203 204 211
211 210 203
204 205 212
212 211 204
205 28 29
29 212 205
61 206 213
213 60 61
206 207 214
214 213 206
207 208 215
215 214 207
208 209 216
216 215 208
209 210 217
217 216 209
210 211 218
218 217 210
211 212 219
219 218 211
212 29 30
30 219 212
60 213 220
220 59 60
213 214 221
221 220 213
214 215 222
222 221 214
215 216 223
223 222 215
216 217 224
224 223 216
217 218 225
225 224 217
218 219 226
226 225 218
219 30 31
31 226 219
59 220 227
227 58 59
220 221 228
228 227 220
221 222 229
229 228 221
222 223 230
230 229 222
223 224 231
231 230 223
224 225 232
232 231 224
225 226 233
233 232 225
226 31 32
32 233 226
58 227 234
234 57 58
227 228 235
235 234 227
228 229 236
236 235 228
229 230 237
237 236 229
230 231 238
238 237 230
231 232 239
239 238 231
232 233 240
240 239 232
233 32 33
33 240 233
57 234 241
241 56 57
234 235 242
242 241 234
235 236 243
243 242 235
236 237 244
244 243 236
237 238 245
245 244 237
238 239 246
246 245 238
239 240 247
247 246 239
240 33 34
34 247 240
56 241 248
248 55 56
241 242 249
249 248 241
242 243 250
250 249 242
243 244 251
251 250 243
244 245 252
252 251 244
245 246 253
253 252 245
246 247 254
254 253 246
247 34 35
35 254 247
55 248 255
255 54 55
248 249 256
256 255 248
249 250 257
257 256 249
250 251 258
258 257 250
251 252 259
259 258 251
252 253 260
260 259 252
253 254 261
261 260 253
254 35 36
36 261 254
54 255 262
262 53 54
255 256 263
263 262 255
256 257 264
264 263 256
257 258 265
265 264 257
258 259 266
266 265 258
259 260 267
267 266 259
260 261 268
268 267 260
261 36 37
37 268 261
53 262 269
269 52 53
262 263 270
270 269 262
263 264 271
271 270 263
264 265 272
272 271 264
265 266 273
273 272 265
266 267 274
274 273 266
267 268 275
275 274 267
268 37 38
38 275 268
52 269 276
276 51 52
269 270 277
277 276 269
270 271 278
278 277 270
271 272 279
279 278 271
272 273 280
280 279 272
273 274 281
281 280 273
274 275 282
282 281 274
275 38 39
39 282 275
51 276 283
283 50 51
276 277 284
284 283 276
277 278 285
285 284 277
278 279 286
286 285 278
279 280 287
287 286 279
280 281 288
288 287 280
281 282 289
289 288 281
282 39 40
40 289 282
50 283 47
47 5 50
283 284 46
46 47 283
284 285 45
45 46 284
285 286 44
44 45 285
286 287 43
43 44 286
287 288 42
42 43 287
288 289 41
41 42 288
289 40 3
3 41 289
6 64 290
290 96 6
64 65 291
291 290 64
65 66 292
292 291 65
66 67 293
293 292 66
67 68 294
294 293 67
68 69 295
295 294 68
69 70 296
296 295 69
70 7 71
71 296 70
96 290 297
297 95 96
290 291 298
298 297 290
291 292 299
299 298 291
292 293 300
300 299 292
293 294 301
301 300 293
294 295 302
302 301 294
295 296 303
303 302 295
296 71 72
72 303 296
95 297 304
304 9 95
297 298 305
305 304 297
298 299 306
306 305 298
299 300 307
307 306 299
300 301 308
308 307 300
301 302 309
309 308 301
302 303 310
310 309 302
303 72 73
73 310 303
9 304 311
311 110 9
304 305 312
312 311 304
305 306 313
313 312 305
306 307 314
314 313 306
307 308 315
315 314 307
308 309 316
316 315 308
309 310 317
317 316 309
310 73 74
74 317 310
110 311 318
318 109 110
311 312 319
319 318 311
312 313 320
320 319 312
313 314 321
321 320 313
314 315 322
322 321 314
315 316 323
323 322 315
316 317 324
324 323 316
317 74 75
75 324 317
109 318 325
325 108 109
318 319 326
326 325 318
319 320 327
327 326 319
320 321 328
328 327 320
321 322 329
329 328 321
322 323 330
330 329 322
323 324 331
331 330 323
324 75 76
76 331 324
108 325 332
332 107 108
325 326 333
333 332 325
326 327 334
334 333 326
327 328 335
335 334 327
328 329 336
336 335 328
329 330 337
337 336 329
330 331 338
338 337 330
331 76 77
77 338 331
107 332 339
339 106 107
332 333 340
340 339 332
333 334 341
341 340 333
334 335 342
342 341 334
335 336 343
343 342 335
336 337 344
344 343 336
337 338 345
345 344 337
338 77 78
78 345 338
106 339 346
346 105 106
339 340 347
347 346 339
340 341 348
348 347 340
341 342 349
349 348 341
342 343 350
350 349 342
343 344 351
351 350 343
344 345 352
352 351 344
345 78 79
79 352 345
105 346 353
353 104 105
346 347 354
354 353 346
347 348 355
355 354 347
348 349 356
356 355 348
349 350 357
357 356 349
350 351 358
358 357 350
351 352 359
359 358 351
352 79 80
80 359 352
104 353 360
360 103 104
353 354 361
361 360 353
354 355 362
362 361 354
355 356 363
363 362 355
356 357 364
364 363 356
357 358 365
365 364 357
358 359 366
366 365 358
359 80 81
81 366 359
103 360 367
367 102 103
360 361 368
368 367 360
361 362 369
369 368 361
362 363 370
370 369 362
363 364 371
371 370 363
364 365 372
372 371 364
365 366 373
373 372 365
366 81 82
82 373 366
102 367 374
374 101 102
367 368 375
375 374 367
368 369 376
376 375 368
369 370 377
377 376 369
370 371 378
378 377 370
371 372 379
379 378 371
372 373 380
380 379 372
373 82 83
83 380 373
101 374 381
381 100 101
374 375 382
382 381 374
375 376 383
383 382 375
376 377 384
384 383 376
377 378 385
385 384 377
378 379 386
386 385 378
379 380 387
387 386 379
380 83 84
84 387 380
100 381 388
388 99 100
381 382 389
389 388 381
382 383 390
390 389 382
383 384 391
391 390 383
384 385 392
392 391 384
385 386 393
393 392 385
386 387 394
394 393 386
387 84 85
85 394 387
99 388 395
395 98 99
388 389 396
396 395 388
389 390 397
397 396 389
390 391 398
398 397 390
391 392 399
399 398 391
392 393 400
400 399 392
393 394 401
401 400 393
394 85 86
86 401 394
98 395 402
402 97 98
395 396 403
403 402 395
396 397 404
404 403 396
397 398 405
405 404 397
398 399 406
406 405 398
399 400 407
407 406 399
400 401 408
408 407 400
401 86 87
87 408 401
97 402 94
94 10 97
402 403 93
93 94 402
403 404 92
92 93 403
404 405 91
91 92 404
405 406 90
90 91 405
406 407 89
89 90 406
407 408 88
88 89 407
408 87 8
8 88 408
448 139 140
449 107 106
454 420 453
498 462 490
436 130 131
435 124 428
410 21 20
447 445 411
425 424 121
97 10 111
416 97 111
472 113 439
500 499 472
473 439 440
457 118 119
528 519 503
421 101 415
422 104 418
423 105 422
423 106 105
419 413 108
413 109 108
448 413 139
518 111 112
500 472 439
440 439 114
471 116 438
437 120 424
457 438 117
118 117 11
427 425 122
493 492 458
418 103 414
509 496 497
451 418 450
502 481 482
460 459 430
430 429 126
431 430 127
442 137 138
432 129 426
513 467 470
433 131 132
445 434 412
23 133 2
17 1 134
134 18 17
409 18 134
446 19 409
446 20 19
411 21 410
412 22 411
409 135 12
409 134 135
140 9 110
448 140 110
477 446 409
409 19 18
444 12 136
467 466 436
412 23 22
411 22 21
434 133 412
412 133 23
419 108 107
413 13 139
414 103 102
421 102 101
415 101 100
420 100 99
417 98 416
416 98 97
420 99 417
417 99 98
429 428 125
418 104 103
443 13 413
443 413 419
439 113 114
420 415 100
485 484 452
421 414 102
456 422 451
422 105 104
483 479 449
449 106 423
424 120 121
425 121 122
427 122 123
486 485 455
513 480 466
426 129 130
435 123 124
452 450 414
428 124 125
429 125 126
430 126 127
487 450 484
431 127 128
464 460 431
432 431 128
495 481 494
432 128 129
466 465 426
434 433 132
476 433 445
434 132 133
445 412 411
468 461 427
435 427 123
436 426 130
436 131 433
469 424 462
437 119 120
438 116 117
457 117 118
499 417 416
440 114 115
471 440 115
478 457 437
441 136 137
474 137 442
475 138 443
511 493 507
443 138 13
479 419 449
477 410 446
470 136 441
445 433 434
447 411 410
446 410 20
477 409 12
477 447 410
476 470 467
448 110 109
448 109 413
449 419 107
483 423 456
450 418 414
452 414 421
488 451 487
451 422 418
455 421 415
468 435 458
462 425 461
453 420 417
506 486 505
454 415 420
455 452 421
455 415 454
509 507 496
456 423 422
457 119 437
478 437 469
458 435 428
463 428 429
459 429 430
460 430 431
464 431 432
516 475 479
461 425 427
468 427 435
489 486 454
462 424 425
463 458 428
463 429 459
465 464 432
495 465 480
465 432 426
495 474 481
466 426 436
467 436 433
476 445 447
476 444 470
492 491 468
525 523 515
501 471 478
469 437 424
470 444 136
513 470 441
471 115 116
478 471 438
518 472 499
472 112 113
510 499 500
517 478 469
474 441 137
481 474 442
475 442 138
479 475 443
476 467 433
476 447 444
477 12 444
477 444 447
478 438 457
517 501 478
479 443 419
482 481 442
480 465 466
480 441 474
495 494 464
482 442 475
516 479 483
508 487 504
483 449 423
530 483 456
484 450 452
485 452 455
486 455 454
491 490 461
489 454 453
523 506 505
502 497 494
487 451 450
527 526 516
488 456 451
520 510 500
503 498 490
490 462 461
491 461 468
492 468 458
525 515 514
493 458 463
514 492 511
496 463 459
521 511 507
497 460 494
494 460 464
495 464 465
495 480 474
496 493 463
497 496 459
497 459 460
502 494 481
519 517 498
498 469 462
499 453 417
518 499 416
500 439 473
520 505 489
501 473 440
501 440 471
526 482 516
527 508 524
515 490 491
528 520 519
504 487 484
512 484 485
505 486 489
520 489 510
525 512 506
506 485 486
524 507 509
507 493 496
508 488 487
521 508 504
509 497 502
529 502 526
510 489 453
510 453 499
522 504 512
511 492 493
512 504 484
512 485 506
513 441 480
513 466 467
514 491 492
522 514 511
515 503 490
515 491 514
530 516 483
516 482 475
517 469 498
519 498 503
518 416 111
518 112 472
519 473 501
519 501 517
520 500 473
520 473 519
524 521 507
522 521 504
522 511 521
525 522 512
528 523 505
523 503 515
529 526 527
524 508 521
525 514 522
525 506 523
526 502 482
530 527 516
527 488 508
529 527 524
528 503 523
528 505 520
529 524 509
529 509 502
530 456 488
530 488 527
532 68 67
546 165 166
554 166 167
543 55 539
549 547 159
586 580 547
544 60 59
570 534 146
548 158 547
64 6 141
141 65 64
531 65 141
567 66 531
567 67 66
533 68 532
531 142 14
531 141 142
147 4 63
570 147 63
50 5 148
536 50 148
595 150 561
623 622 595
621 580 618
579 155 156
612 609 571
539 54 535
540 58 57
541 58 540
544 59 541
542 534 61
534 62 61
570 63 62
641 148 149
623 595 561
562 561 151
594 153 560
559 157 548
579 560 154
155 154 16
572 535 571
545 56 543
543 56 55
587 551 581
551 550 162
619 616 581
582 581 552
552 551 163
553 165 546
554 546 166
590 589 558
556 555 169
599 569 532
568 556 170
568 69 533
170 7 70
599 567 531
531 66 65
566 14 143
600 566 593
568 170 70
533 69 68
542 61 60
534 15 146
535 54 53
538 53 52
537 51 536
536 51 50
538 52 537
537 52 51
561 150 151
538 535 53
557 161 550
539 55 54
574 540 573
545 57 56
544 542 60
541 59 58
565 15 534
565 534 542
575 539 572
649 632 635
577 541 574
625 619 620
578 543 575
545 540 57
589 584 554
585 546 584
547 158 159
549 159 160
651 643 629
548 157 158
557 160 161
609 606 572
550 161 162
551 162 163
552 163 164
610 573 607
553 552 164
564 144 145
553 164 165
617 584 603
558 167 168
638 603 589
590 555 588
555 168 169
556 169 170
588 533 569
639 614 631
557 549 160
558 554 167
558 168 555
592 548 580
559 156 157
560 153 154
579 154 155
576 571 538
562 151 152
594 562 152
601 579 559
563 143 144
597 144 564
598 145 565
616 614 587
565 145 15
602 542 544
599 532 567
593 143 563
567 532 67
599 531 14
568 70 69
588 568 533
588 556 568
569 533 532
570 62 534
570 146 147
571 535 538
576 538 537
591 557 583
572 539 535
573 540 545
578 545 543
650 633 647
574 541 540
575 543 539
647 626 646
622 537 536
596 561 562
602 544 577
577 544 541
608 575 606
578 573 545
579 156 559
601 559 592
580 548 547
586 547 549
581 551 552
582 552 553
585 553 546
642 598 602
583 557 550
587 583 550
584 546 554
617 597 604
620 619 582
585 582 553
591 586 549
628 626 609
587 550 551
648 636 632
600 590 588
588 555 556
589 554 558
590 558 555
600 593 590
638 590 593
591 549 557
650 647 637
624 594 601
592 559 548
593 566 143
638 593 563
594 152 153
601 594 560
641 595 622
595 149 150
634 622 623
640 601 592
597 563 144
604 597 564
598 564 145
602 598 565
599 14 566
599 566 569
600 588 569
600 569 566
601 560 579
640 624 601
602 565 542
605 604 564
603 584 589
603 563 597
620 585 617
605 564 598
642 577 611
611 577 574
606 575 572
609 572 571
607 573 578
608 607 578
608 578 575
633 606 626
612 571 576
618 586 613
631 616 630
610 574 573
645 611 636
611 574 610
644 634 623
629 618 627
613 586 591
615 591 583
614 583 587
616 587 581
615 613 591
615 583 614
619 581 582
630 619 625
617 585 584
617 603 597
646 626 628
618 580 586
620 582 585
625 604 605
620 617 604
625 620 604
643 640 621
621 592 580
622 576 537
641 622 536
623 561 596
644 628 612
624 596 562
624 562 594
645 642 611
648 645 636
626 606 609
628 609 612
627 618 613
637 613 615
644 612 634
651 644 643
629 621 618
646 629 627
645 630 625
630 616 619
648 631 630
631 614 616
632 610 607
635 607 608
650 639 649
633 608 606
634 612 576
634 576 622
635 632 607
635 608 633
636 611 610
636 610 632
637 627 613
639 637 615
638 563 603
638 589 590
639 615 614
649 639 631
640 592 621
643 621 629
641 536 148
641 149 595
642 605 598
642 602 577
643 596 624
643 624 640
644 623 596
644 596 643
645 625 605
645 605 642
647 646 627
651 646 628
647 633 626
647 627 637
649 648 632
648 630 645
649 631 648
650 649 635
650 635 633
650 637 639
651 629 646
651 628 644
]';

% function to plot the mesh
plotmesh;
