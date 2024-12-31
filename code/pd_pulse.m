function x=pd_pulse(t,delay,type,alphad,alphaf,fd)
 if nargin<6
    omegad=0;
else
    omegad=2*pi*fd;
end
index=find((t-delay)<0);
x(index)=0;
index=find((t-delay)>=0);
 switch type
    case '1'
        x(index)=exp(-alphad*(t(index)-delay))-exp(-alphaf*(t(index)-delay));
    case '2'
        phi=atan(omegad/alphaf);
        x(index)=exp(-alphad*(t(index)-delay)).*cos(omegad*(t(index)-delay)-phi)-exp(-alphaf*(t(index)-delay)).*cos(phi);
 end
 x=x/max(abs(x));
