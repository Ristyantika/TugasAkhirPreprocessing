%# Load image and convert to [0,1].
A = im2double(imread('010_l_940_02.jpg'));
%# Any large (relative to objects) structuring element will do.
%# Try sizes up to about half of the image size.
se = strel('square',50);
%# Removes uneven lighting and enhances contrast.
B = imdivide(A,imclose(A,se));
%# Otsu's method works well now.
C = B > graythresh(B);
D = bwdist(~C);
DL = watershed(D);
imshow(DL==0);