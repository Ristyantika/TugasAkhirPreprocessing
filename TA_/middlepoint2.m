function [m1 m2]=middlepoint(v1,v2,borde1,borde2)

%Side length of the square we were looking before
if v1(1)<borde1(1)
point1=abs((v1-borde1)*0.2);
point1=[point1(1)+v1(1) point1(2)+v1(2)];
% plot(point1(1),point1(2),'*g');
elseif v1(1)>borde1(1)
    point1=abs((v1-borde1)*0.2);
    point1=[v1(1)-point1(1) point1(2)+v1(2)];
%     plot(point1(1),point1(2),'*g');
else
    point1=abs((v1-borde1)*0.2);
    point1=[v1(1) point1(2)+v1(2)];
%     plot(point1(1),point1(2),'*g');
end

if v2(1)>borde2(1)
point2=abs((v2-borde2)*0.3);
point2=[borde2(1)+point2(1) point2(2)+borde2(2)];
% plot(point2(1),point2(2),'*g');
elseif  v2(1)<borde2(1)
point2=abs((v2-borde2)*0.3);
point2=[borde2(1)-point2(1) point2(2)+borde2(2)];
% plot(point2(1),point2(2),'*g');
end
m1=point1;
m2=point2;