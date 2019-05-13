%function pre_process = preprocess_palm(~)

%Ekstrak Data Testing
datanama = dir(strcat('D:\Nuzul Kuliah\TA\Output\*.jpg'));
for i=1:length(datanama)    
    tmp = strcat('D:\Nuzul Kuliah\TA\Output\',datanama(i).name);
    fileo = strcat('D:\Nuzul Kuliah\TA\resultMat\', datanama(i).name);
    img = imread(tmp);
    imgGray = rgb2gray(img);
    %% Resize Image interpolasi bikubik
    b = imresize(imgGray,[224 224]);

    %% PREPROCESSING
    %% Median Filter
    immed = medfilt2(b,[10 10]);
    
    %% Adaptive Histeq
    imadapt = adapthisteq(immed,'clipLimit',0.08,'Distribution','rayleigh');

    %% Adaptive Noise Removal
    imanr = wiener2(imadapt,[12 12]);

    %% Anisotropic Diffusion Filter
    imadf = anisodiff2D(imanr, 10, 1/7, 20, 1);
    % convert ke uint8
    imapa= uint8(round(imadf-1));

    %% Image Closing
    se = strel('disk',3);
    imageClose = imclose(imapa,se);

    %% Substract Image
    imsub = imsubtract(imageClose,imapa);
    
    %% Adjust Image
    imadj = imadjust(imsub);
    
    %% Image Resizing
    img_in = imresize(imadj,[224 224]);
    imshow(img_in);
     
    imwrite(img_in, fileo);
end