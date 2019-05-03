function [degree] = degree_rot(m1,m2,m3,m4);

x1=m1(1);
y1=m1(2);
x2=m2(1);
y2=m2(2);
x3=m3(1);
y3=m3(2);
x4=m4(1);
y4=m4(2);


% if ((x1 -x4) > (y4 - y1)) 
%     rad = atan( (x1 - x3) / (y3 - y1));
% elseif ((x1 -x4) < (y4 - y1)) 
%     rad = - atan( (x1 - x4) / (y4 - y1));
% else 
%     rad = 0;
%  end
if x1>x2
rad=atan((x1-x2)/(y2-y1));
rad=rad-pi/2;
elseif x2>x1
rad=atan((x2-x1)/(y1-y2));
rad=rad-pi/2;
else
rad=pi/2;
end
degree = 180*rad / pi;

% degree=degree+90;


