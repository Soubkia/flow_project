% Average Half BandWidth
function [AHBW_value] = ahbw(K)
include_flags;

AHBW_set=zeros(neq);
for i=1:neq
    AHBW_count=0;
    for j=1:neq
        if K(i,j)~=0
			AHBW_count=AHBW_count+1;
			AHBW_set(i,AHBW_count)=j-i;
        end
    end
end
AHBW_set=abs(AHBW_set);
max_all=max(AHBW_set');
AHBW_value=sum(max_all)/neq;
