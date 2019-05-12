%     PREPROCESSING
img = imread('001_l_940_01.jpg');
level = rgb2gray(img);
%     Median Filter
immed = medfilt2(level,[10 10]);
imwrite(immed, 'medfil.jpg');
%     Adaptive Histeq
imadapt = adapthisteq(immed,'clipLimit',0.08,'Distribution','rayleigh');
imwrite(imadapt, 'adaptive.jpg');
%     Adaptive Noise Removal
imanr = wiener2(imadapt,[12 12]);
imwrite(imanr, 'noiserem.jpg');
%     Anisotropic Diffusion Filter
imadf = anisodiff2D(imanr, 50, 1/7, 20, 1);
imwrite(imadf, 'anistropic.jpg');
%     convert ke uint8
imapa= uint8(round(imadf-1));
%     Image Closing
se = strel('disk',3);
imageClose = imclose(imapa,se);
imwrite(imageClose, 'closing.jpg');
%     Substract Image
imsub = imsubtract(imageClose,imapa);
imwrite(imsub, 'substract.jpg');
%     Adjust Image
imadj = imadjust(imsub);
imwrite(imadj, 'adjust.jpg');
%     Image Resizing
img_in = imresize(imadj,[224 224]);
imshow(img_in);