%function pre_process = preprocess_palm(~)

%Ekstrak Data Testing
datanama = dir(strcat('D:\Nuzul Kuliah\TA\PalmVein\*.jpg'));
for i=1:length(datanama)    
    tmp = strcat('D:\Nuzul Kuliah\TA\PalmVein\',datanama(i).name);
    fileo = strcat('D:\Nuzul Kuliah\TA\SmallData\', datanama(i).name);
    img_inn = imread(tmp);
    
%img_inn = imread('D:\KULIAH\SEMESTER 8\TA\DataPalm\001_l_940_02.jpg');
    %% CROPPING
    %%
    img = imrotate(img_inn,-90);
    
    %thresholding using Otsu's method
    level = graythresh(img);
    %convert to binary image
    imgbw_in = im2bw(img,level);

    % ROI - Noise Removal
    se = strel('disk',17);        
    imgbw = imopen(imgbw_in,se); %morfologi opening
%     imwrite(imgbw,fileo);
    ctrImg = zeros(size(imgbw,1),size(imgbw,2)); %matrix m x m
    
    %region of interest (r x c)
    [r c] = find(imgbw==1,1);
    ctrImg(r,c) = 1;
    coor = [r,c];
    startCoor = [r,c];

    maksCoorR = size(img,1);
    maksCoorC = size(img,2);  
    coorHalfWrist(1,1) = maksCoorR;
    coorHalfWrist(1,2) = maksCoorC/2;
    count = 1;

    % direction 8 connectivity
    dir = 7;
    indikator = 1;
    while indikator == 1
        % genap
        if mod(dir,2)==0
            startDir = mod(dir+7,8);
        else
        % ganjil
            startDir = mod(dir+6,8);
        end
        currentDir = startDir;
        for i=1:8
            if currentDir==8
                currentDir = 0;
            end
            switch (currentDir)
                case 0
                    posisi = [0,1];
                    dir = 0;
                case 1
                    posisi = [-1,1];
                    dir = 1;
                case 2
                    posisi = [-1,0];
                    dir = 2;
                case 3
                    posisi = [-1,-1];
                    dir = 3;
                case 4
                    posisi = [0,-1];
                    dir = 4;
                case 5
                    posisi = [1,-1];
                    dir = 5;
                case 6
                    posisi = [1,0];
                    dir = 6;
                case 7
                    posisi = [1,1];
                    dir = 7;
            end
            % checking border yang lain
            newCoor = coor + posisi;
            if newCoor(1,1) > 0 && newCoor(1,2) > 0 && newCoor(1,1) < maksCoorR && newCoor(1,2) < maksCoorC
                if imgbw(newCoor(1,1),newCoor(1,2))== 1
                    ctrImg(newCoor(1,1),newCoor(1,2))=1;
                    coor = newCoor;
                    a = (newCoor(1,1)-coorHalfWrist(1,1))^2;
                    b = (newCoor(1,2)-coorHalfWrist(1,2))^2;
                    distance = sqrt( a + b );
                    coorDis(count,1) = newCoor(1,1);
                    coorDis(count,2) = newCoor(1,2);
                    coorDis(count,3) = distance;
                    direction(count,1) = dir;
                    count= count + 1;
                    break;
                else
                    currentDir = currentDir + 1;
                end
            else
                currentDir = currentDir + 1;
            end
        end
        if startCoor == coor
            indikator = 0;
        end
    end

    % Distance Distribution Diagram
    for i = 1:size(coorDis(:,3))
        sumbuX(1,i) = i;
    end
    [r c] = find(coorDis(:,3) == min(coorDis(:,3)));
    newCoorDis = zeros(size(coorDis,1),size(coorDis,2),size(coorDis,3));
    newCoorDis(1:size(coorDis,1)-r+1,:) = coorDis(r:size(coorDis,1),:);
    newCoorDis(size(coorDis,1)-r+2:size(coorDis),:) = coorDis(1:r-1,:);
    %new
    zeroDis = 550;
    [r c] = find(newCoorDis(:,1)>zeroDis);
    newCoorDis(r,3) = 0;
    % mencari peak dari diagram - new
    output = fpeak(sumbuX,newCoorDis(:,3),50);
    % improve output -> salah satu dari 2 peak yang bernilai sama akan dihapus
    for i=1:size(output,1)-1
        if output(i,2)==output(i+1,2)
            output(i,3) = 1;
        else
            output(i,3) = 0;
        end
    end
    %output peak
    improveOut = find(output(:,3)==1);
    improveOut = sort(improveOut,'descend');
    for i=1:size(improveOut)
        output(improveOut(i,1),:)=[];
    end
    
    % ROI - menetukan titik P1 dan P2 dari distance diagram
    pixelP1 = output(3,1);
    pixelP2 = output(7,1);
    coorP1(1,1) =  newCoorDis(pixelP1,1);
    coorP1(1,2) =  newCoorDis(pixelP1,2);
    coorP2(1,1) =  newCoorDis(pixelP2,1);
    coorP2(1,2) =  newCoorDis(pixelP2,2);
    % kemiringan P1 dan P2
    temp = (coorP2(1,2)-coorP1(1,2))/(coorP2(1,1)-coorP1(1,1));
    rad = atan(temp);
    deg = rad/pi*180;
    newImg = imrotate(img,90-deg,'bilinear','crop');
    % ROI - new P1 dan new P2
    temp = zeros(size(img,1), size(img,2));
    temp(coorP1(1,1), coorP1(1,2)) = 1;
    temp(coorP2(1,1), coorP2(1,2)) = 1;
    tempRotate = imrotate(temp, 90-deg,'bilinear','crop');
    [i, j] = find(tempRotate);
    newCoorP1(1,1) = i(1);
    newCoorP1(1,2) = j(1);
    newCoorP2(1,1) = i(size(i,1));
    newCoorP2(1,2) = j(size(j,1));

    %plot([newCoorP1(1,2),newCoorP2(1,2)],[newCoorP1(1,1),newCoorP2(1,1)],'Color','r','LineWidth',2);
    % new P3 dan P4
    a = (newCoorP1(1,1)-newCoorP2(1,1))^2;
    b = (newCoorP1(1,2)-newCoorP2(1,2))^2;
    distance = sqrt( a + b );
    % ROI - output
    fiturI = imcrop(newImg, [newCoorP1(1,2), newCoorP1(1,1), distance , distance]);

    %% Resize Image interpolasi bikubik
    b = imresize(fiturI,[224 224]);

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