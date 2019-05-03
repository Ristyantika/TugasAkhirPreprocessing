%% loading the image  and displaying it
    load('file_name.mat');
    file1=strcat('..\PalmVein\2.cropped\',file_name);
    I=imread(file1);
    
%% normalize the ROI's size using cubic interpolation
    I = imresize(I,[256 256],'bicubic');  
    savename = strcat('..\PalmVein\3.resized\',file_name);
    imwrite(I, savename);
    
%% applying median filter to the image and displaying it 
    B = medfilt2(I,[10 10]);
    savename = strcat('..\PalmVein\1.praproses\','medfilt2.jpg');
    imwrite(B, savename);

%%adaptive histeq and adaptive noise removal
    B = adapthisteq (B, 'clipLimit', 0.08, 'Distribution', 'rayleigh');
    savename = strcat('..\PalmVein\1.praproses\','adapthisteq.jpg');
    imwrite(B, savename);
    B = wiener2(B,[12 12]);
    savename = strcat('..\PalmVein\1.praproses\','wiener2.jpg');
    imwrite(B, savename);
    savename = strcat('..\PalmVein\3.resized\',file_name);
    imwrite(B, savename); 
     
%% Anisotropic diffusion filter to preserve edges
    B = anisodiff2D(B, 10, 1/7, 20, 1);
    B = uint8(round(B - 1)); % Convert double to uint8
    savename = strcat('..\PalmVein\1.praproses\','anisodiff.jpg');
    imwrite(B, savename);
     
%% Defining a morphological structural element
    SE = strel('disk', 5, 0);
    est_bkg = imclose(B, SE);
    savename = strcat('..\PalmVein\1.praproses\','imclose.jpg');
    imwrite(est_bkg, savename);
    
%% Subtracting the original Image from the background
    normed = imsubtract(est_bkg, B);
    savename = strcat('..\PalmVein\1.praproses\','imsubtract.jpg');
    imwrite(normed, savename);
    normed = imadjust(normed);
   
    axes(handles.axes4)
    imshow(normed) 
    savename = strcat('..\PalmVein\4.subtract\',file_name);
    imwrite(normed, savename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LEVEL 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Wavelet
    X=normed;
    nColors = 256;  %# Number of colors in colormap
    nLevel = 1;
    cA = cell(0,nLevel);    %# Approximation coefficients
    cH = cell(0,nLevel);    %# Horizontal detail coefficients
    cV = cell(0,nLevel);    %# Vertical detail coefficients
    cD = cell(0,nLevel);    %# Diagonal detail coefficients
    startImage = X;
    for iLevel = 1:nLevel,
        [cA{iLevel},cH{iLevel},cV{iLevel},cD{iLevel}] = dwt2(startImage,'db1');
        startImage = cA{iLevel};
    end
    tiledImage = wcodemat(cA{nLevel},nColors);
    for iLevel = nLevel:-1:1,
        tiledImage1 = [wcodemat(cA{iLevel},nColors) wcodemat(cH{iLevel},nColors); wcodemat(cV{iLevel},nColors) wcodemat(cD{iLevel},nColors)];
    end
    axes(handles.axes5);
    imshow(uint8(tiledImage1));
    savename = strcat('..\PalmVein\5.haarm1\',file_name);
    waveletTransform=(uint8(cA{nLevel}));
%     waveletTransform=(uint8(tiledImage1));
    imwrite(waveletTransform, savename);

%% LBP operator    
    LBP_1= efficientLBP_1(waveletTransform,[2,3]);  %note this filter dimentions aren't legete...
    savename = strcat('..\PalmVein\8a.lbp\',file_name);
    imwrite(LBP_1, savename);
    tic;
    
%% LLBP method, N=7
    lbpV7 = efficientLBP_1(waveletTransform,[7 1], true);
    lbpH7 = efficientLBP_1(waveletTransform,[1 7], true);
    llbp7 = sqrt(double(lbpH7.^2 + lbpV7.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp7-1\',file_name);
    imwrite(llbp7, savename);
%% LLBP method, N=9
    lbpV9 = efficientLBP_1(waveletTransform,[13 1], true);
    lbpH9 = efficientLBP_1(waveletTransform,[1 13], true);
    llbp9 = sqrt(double(lbpH9.^2 + lbpV9.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp9-1\',file_name);
    imwrite(llbp9, savename);
%% LLBP method, N=11
    lbpV11 = efficientLBP_1(waveletTransform,[11 1], true);
    lbpH11 = efficientLBP_1(waveletTransform,[1 11], true);
    llbp11 = sqrt(double(lbpH11.^2 + lbpV11.^2)); 
    effTime=toc; 
    axes(handles.axes6);
    imshow(llbp11);
    savename = strcat('..\PalmVein\6a.llbp11-1\',file_name);
    imwrite(llbp11, savename);
%% LLBP method, N=13
    lbpV13 = efficientLBP_1(waveletTransform,[13 1], true);
    lbpH13 = efficientLBP_1(waveletTransform,[1 13], true);
    llbp13 = sqrt(double(lbpH13.^2 + lbpV13.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp13-1\',file_name);
    imwrite(llbp13, savename);
 %% LLBP method, N=15
    lbpV15 = efficientLBP_1(waveletTransform,[13 1], true);
    lbpH15 = efficientLBP_1(waveletTransform,[1 13], true);
    llbp15 = sqrt(double(lbpH15.^2 + lbpV15.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp15-1\',file_name);
    imwrite(llbp15, savename); 
%% LLBP method, N=17
    lbpV17 = efficientLBP_1(waveletTransform,[17 1], true);
    lbpH17 = efficientLBP_1(waveletTransform,[1 17], true);
    llbp17 = sqrt(double(lbpH17.^2 + lbpV17.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp17-1\',file_name);
    imwrite(llbp17, savename);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LEVEL 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Wavelet
    X=normed;
    nColors = 256;  %# Number of colors in colormap
    nLevel = 2;
    cA = cell(0,nLevel);    %# Approximation coefficients
    cH = cell(0,nLevel);    %# Horizontal detail coefficients
    cV = cell(0,nLevel);    %# Vertical detail coefficients
    cD = cell(0,nLevel);    %# Diagonal detail coefficients
    startImage = X;
    for iLevel = 1:nLevel,
        [cA{iLevel},cH{iLevel},cV{iLevel},cD{iLevel}] = dwt2(startImage,'db1');
        startImage = cA{iLevel};
    end
    tiledImage = wcodemat(cA{nLevel},nColors);
    for iLevel = nLevel:-1:1,
        tiledImage1 = [wcodemat(cA{iLevel},nColors) wcodemat(cH{iLevel},nColors); wcodemat(cV{iLevel},nColors) wcodemat(cD{iLevel},nColors)];
    end
%     axes(handles.axes5);
%     imshow(uint8(tiledImage1));
    savename = strcat('..\PalmVein\5.haarm2\',file_name);
    waveletTransform2=(uint8(cA{nLevel}));
    imwrite(waveletTransform2, savename);
    tic;

%% LLBP method, N=7
    lbpV7 = efficientLBP_1(waveletTransform2,[7 1], true);
    lbpH7 = efficientLBP_1(waveletTransform2,[1 7], true);
    llbp7 = sqrt(double(lbpH7.^2 + lbpV7.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp7-2\',file_name);
    imwrite(llbp7, savename);
%% LLBP method, N=9
    lbpV9 = efficientLBP_1(waveletTransform2,[13 1], true);
    lbpH9 = efficientLBP_1(waveletTransform2,[1 13], true);
    llbp9 = sqrt(double(lbpH9.^2 + lbpV9.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp9-2\',file_name);
    imwrite(llbp9, savename);
%% LLBP method, N=11
    lbpV11 = efficientLBP_1(waveletTransform2,[11 1], true);
    lbpH11 = efficientLBP_1(waveletTransform2,[1 11], true);
    llbp11 = sqrt(double(lbpH11.^2 + lbpV11.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp11-2\',file_name);
    imwrite(llbp11, savename);
%% LLBP method, N=13
    lbpV13 = efficientLBP_1(waveletTransform2,[13 1], true);
    lbpH13 = efficientLBP_1(waveletTransform2,[1 13], true);
    llbp13 = sqrt(double(lbpH13.^2 + lbpV13.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp13-2\',file_name);
    imwrite(llbp13, savename);
 %% LLBP method, N=15
    lbpV15 = efficientLBP_1(waveletTransform2,[13 1], true);
    lbpH15 = efficientLBP_1(waveletTransform2,[1 13], true);
    llbp15 = sqrt(double(lbpH15.^2 + lbpV15.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp15-2\',file_name);
    imwrite(llbp15, savename); 
%% LLBP method, N=17
    lbpV17 = efficientLBP_1(waveletTransform2,[17 1], true);
    lbpH17 = efficientLBP_1(waveletTransform2,[1 17], true);
    llbp17 = sqrt(double(lbpH17.^2 + lbpV17.^2)); 
    effTime=toc; 
%     imshow(llbp17);
    savename = strcat('..\PalmVein\6a.llbp17-2\',file_name);
    imwrite(llbp17, savename);
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LEVEL 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Wavelet
    X=normed;
    nColors = 256;  %# Number of colors in colormap
    nLevel = 3;
    cA = cell(0,nLevel);    %# Approximation coefficients
    cH = cell(0,nLevel);    %# Horizontal detail coefficients
    cV = cell(0,nLevel);    %# Vertical detail coefficients
    cD = cell(0,nLevel);    %# Diagonal detail coefficients
    startImage = X;
    for iLevel = 1:nLevel,
        [cA{iLevel},cH{iLevel},cV{iLevel},cD{iLevel}] = dwt2(startImage,'db1');
        startImage = cA{iLevel};
    end
    tiledImage = wcodemat(cA{nLevel},nColors);
    for iLevel = nLevel:-1:1,
        tiledImage1 = [wcodemat(cA{iLevel},nColors) wcodemat(cH{iLevel},nColors); wcodemat(cV{iLevel},nColors) wcodemat(cD{iLevel},nColors)];
    end
%     axes(handles.axes5);
%     imshow(uint8(tiledImage1));
    savename = strcat('..\PalmVein\5.haarm3\',file_name);
    waveletTransform3=(uint8(cA{nLevel}));
    imwrite(waveletTransform3, savename);
    tic;

%% LLBP method, N=7
    lbpV7 = efficientLBP_1(waveletTransform3,[7 1], true);
    lbpH7 = efficientLBP_1(waveletTransform3,[1 7], true);
    llbp7 = sqrt(double(lbpH7.^2 + lbpV7.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp7-3\',file_name);
    imwrite(llbp7, savename);
%% LLBP method, N=9
    lbpV9 = efficientLBP_1(waveletTransform3,[13 1], true);
    lbpH9 = efficientLBP_1(waveletTransform3,[1 13], true);
    llbp9 = sqrt(double(lbpH9.^2 + lbpV9.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp9-3\',file_name);
    imwrite(llbp9, savename);
%% LLBP method, N=11
    lbpV11 = efficientLBP_1(waveletTransform3,[11 1], true);
    lbpH11 = efficientLBP_1(waveletTransform3,[1 11], true);
    llbp11 = sqrt(double(lbpH11.^2 + lbpV11.^2)); 
    effTime=toc; 
%     imshow(llbp11);
    savename = strcat('..\PalmVein\6a.llbp11-3\',file_name);
    imwrite(llbp11, savename);
%% LLBP method, N=13
    lbpV13 = efficientLBP_1(waveletTransform3,[13 1], true);
    lbpH13 = efficientLBP_1(waveletTransform3,[1 13], true);
    llbp13 = sqrt(double(lbpH13.^2 + lbpV13.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp13-3\',file_name);
    imwrite(llbp13, savename);
 %% LLBP method, N=15
    lbpV15 = efficientLBP_1(waveletTransform3,[13 1], true);
    lbpH15 = efficientLBP_1(waveletTransform3,[1 13], true);
    llbp15 = sqrt(double(lbpH15.^2 + lbpV15.^2)); 
    effTime=toc; 
    savename = strcat('..\PalmVein\6a.llbp15-3\',file_name);
    imwrite(llbp15, savename); 
%% LLBP method, N=17
    lbpV17 = efficientLBP_1(waveletTransform3,[17 1], true);
    lbpH17 = efficientLBP_1(waveletTransform3,[1 17], true);
    llbp17 = sqrt(double(lbpH17.^2 + lbpV17.^2)); 
    effTime=toc; 
%     imshow(llbp17);
    savename = strcat('..\PalmVein\6a.llbp17-3\',file_name);
    imwrite(llbp17, savename);
    
%% read feature of input image
    load('file_name.mat');
    file1=strcat('..\PalmVein\6a.llbp11-3\',file_name);
    featureLLBP=imread(file1);
    featureSize=size(featureLLBP);
    features=reshape(featureLLBP,1,featureSize(1)*featureSize(1));
    save ('features','features');

    
    
    
    
    
    

