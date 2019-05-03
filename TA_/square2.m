function [m3 m4] = square(A,B)
x1=A(1);
y1=A(2);
x2=B(1);
y2=B(2);

%Perpendicular to the line calculated before
mp = -(x2-x1)/(y2-y1); % m*mp=-1
const = y1 -mp * x1;

%Side length of the square we were looking before
dist = sqrt( (x1 - x2)^2 + (y1 - y2)^2 )*1.0;

a = (1+mp^2);
b = (-2*x1+2*mp*const-2*y1*mp);
c = (- dist^2 + x1^2 + y1^2 + const^2 - 2*y1*const);

%Final point of the square
x3 = (- b + sqrt((b)^2 - 4*a*c)) / (2*a);
y3 = (mp * x3 + const);


%Perpendicular to the line calculated before
% mp = -(x2-x1)/(y2-y1) Have already done before
const2 = y2 -mp * x2;

%Side length of the square we were looking before
% dist = sqrt( (x1-x2)^2 + (y1 - y2)^2 );

% a = (1+mp^2) I've already calculated this value
b2 = (-2*x2+2*mp*const2-2*y2*mp);
c2 = (- dist^2 + x2^2 + y2^2 + const2^2 - 2*y2*const2);

%Final point of the square
x4 = (- b2 + sqrt((b2)^2 - 4*a*c2)) / (2*a);
y4 = (mp * x4 + const2);

%Asignation of values
m3 = [x3 y3];
m4 = [x4 y4];

% plot(x3,y3,'*g')
% plot(x4,y4,'*g')