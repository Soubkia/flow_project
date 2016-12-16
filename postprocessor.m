% plot temperature and flux
function postprocess(d);
include_flags

% plot the temperature field
if strcmpi(plot_temp,'yes')==1;  
%   d1 = d(ID);
   figure(2); 
   for e=1:nel
	   XX = [x(IEN(1,e))  x(IEN(2,e))  x(IEN(3,e))  x(IEN(1,e))];
	   YY = [y(IEN(1,e))  y(IEN(2,e))  y(IEN(3,e))  y(IEN(1,e))];
	   dd = [d(IEN(1,e)) d(IEN(2,e)) d(IEN(3,e)) d(IEN(1,e))];
	   patch(XX,YY,dd);hold on;  
   end
title('Potential flow'); xlabel('X'); ylabel('Y'); colormap jet; colorbar;
axis equal
end

%Compute flux at gauss points
if strcmpi(compute_flux,'yes')==1;  
	fprintf(1,'\n                     Flux at Gauss Points \n')
	fprintf(1,'----------------------------------------------------------------------------- \n')
	for e=1:nel
	fprintf(1,'Element  %d \n',e)
	fprintf(1,'-------------\n')
		get_flux(d,e);
	end
end

%Plot velocity potential around FGH by angle
figure(3);
fgh = [ ];
radius = 1.25;
tlrnc = 0.1;
for e=1:nel
    nodes = [ x(IEN(1,e)) y(IEN(1,e));
              x(IEN(2,e)) y(IEN(2,e));
              x(IEN(3,e)) y(IEN(3,e)); ];
    for n=1:3
        xn = nodes(n,1);
        yn = nodes(n,2);
        dist = sqrt(xn*xn + yn*yn);
        ng = acos(xn/radius)*180/pi;
        if dist <= radius + tlrnc && dist >= radius - tlrnc && ng >= 0
            fgh = [ fgh; [ ng d(IEN(n,e)) ]; ];
        end
    end
end
fgh = sortrows(fgh,1);
plot(fgh(:,1), fgh(:,2));
xlim([0,180]); ylim([min(d),max(d)]);
title('Velocity Potential along FGH');
xlabel('Angle'); ylabel('Velocity potential');

%Plot velocity potential around EE' FF' GG'
figure(4)
EE = [ ];
FF = [ ];
GG = [ ];
tlrnc = 0.1;
for e=1:nel
    nodes = [ x(IEN(1,e)) y(IEN(1,e));
              x(IEN(2,e)) y(IEN(2,e));
              x(IEN(3,e)) y(IEN(3,e)); ];
    for n=1:3
        xn = nodes(n,1);
        yn = nodes(n,2);
        if yn == 0
            EE = [ EE; [ xn d(IEN(n,e)) ]; ];
        end
        if xn == 0
            FF = [ FF; [ yn d(IEN(n,e)) ]; ];
        end
        if abs(xn - yn) < tlrnc
            GG = [ GG; [ xn d(IEN(n,e)) ]; ];
        end
    end
end

EE = sortrows(EE,1);
subplot(3,1,1);
plot(EE(:,1), EE(:,2));
xlim([-5, 5]); ylim([min(d),max(d)]);
title("Velocity Potential along EE'");
xlabel('X'); ylabel('Velocity potential');
FF = sortrows(FF,1);
subplot(3,1,2);
plot(FF(:,1), FF(:,2));
xlim([-2.5, 2.5]); ylim([min(d),max(d)]);
title("Velocity Potential along FF'");
xlabel('Y'); ylabel('Velocity potential');
GG = sortrows(GG,1);
subplot(3,1,3);
plot(GG(:,1), GG(:,2));
xlim([min(GG(:,1)), max(GG(:,1))]); ylim([min(d),max(d)]);
title("Velocity Potential along GG'");
xlabel('X'); ylabel('Velocity potential');
