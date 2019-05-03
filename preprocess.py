# -*- coding: utf-8 -*-
"""
Created on Tue Mar  5 16:55:32 2019

@author: nuzulristy
"""

import glob
import os
import numpy as np
import cv2
import imutils
import math
from scipy import misc

img_dir = "dataset"

data_path = os.path.join(img_dir,'*.jpg')
files = glob.glob(data_path)
print(files)

class_data = []
dir_result = "result"
for f1 in files:
    original_img = cv2.imread(f1)
    head, tail = os.path.split(f1)
    name = tail.split('_')
    class_data.append(name[0])
    folderName = dir_result + '\\\\' + tail
    
    #rotate image
    img_rotate = imutils.rotate_bound(original_img, 90)
    
    #graylevel image
    img_gray = cv2.cvtColor(img_rotate, cv2.COLOR_BGR2GRAY)
    
    #otsu's thresholding
    blur = cv2.GaussianBlur(img_gray,(5,5),0)
    ret3,img_thresh = cv2.threshold(blur,0,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)
    
    #morphological opening
    sz = 25
    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (2*sz-1, 2*sz-1))
    opening = cv2.morphologyEx(img_thresh, cv2.MORPH_OPEN, kernel)
    
    img = np.array(opening)
    column = np.argwhere(np.any(img==255, axis = 0))[0]
    c = column[0]
    row_columnX = img[:,3:4]
    print(row_columnX.shape)
    row = np.argwhere(np.any(row_columnX==255, axis = 1))[0]
    r = row[0]
    print(c)
    print(r)
    ctrImg = np.zeros(img.shape)
    print(img.shape)
    height, width = img.shape
    ctrImg[r,c] = 255
    coor = [r,c]
    startCoor = [r,c]
    print(ctrImg[r,c])
    print(coor)
    try_img = np.zeros(img.shape)
    for i in range(height - r):
        for j in range(width - c):
            try_img[i+r][j+c] = 255
    cv2.imwrite(os.path.join(dir_result, "try.jpg"), try_img)
    
    maksCoorR, maksCoorC = img.shape
    coorHalfWrist = [int(maksCoorR), int(maksCoorC/2)]
    print(coorHalfWrist)
    try1_img = np.zeros(img.shape)
    for i in range(coorHalfWrist[0]):
        for j in range(coorHalfWrist[1]):
            try1_img[i][j] = 255
    cv2.imwrite(os.path.join(dir_result, "try1.jpg"), try1_img)
    
    newCoor = [0,0]
    coorDis = []
    direction = []
    dire = 7
    indikator = 1
    count = 0
    counts = 0
    while indikator == 1:
        counts += 1
        if dire % 2 == 0:
            startDir = (dire+7) % 8
        else:
            startDir = (dire+6) % 8
        currentDir = startDir
        for i in range(8):
            if currentDir == 8:
                currentDir = 0
            if currentDir == 0:
                posisi = [0, 1]
            elif currentDir == 1:
                posisi = [-1, 1]
            elif currentDir == 2:
                posisi = [-1, 0]
            elif currentDir == 3:
                posisi = [-1, -1]
            elif currentDir == 4:
                posisi = [0, -1]
            elif currentDir == 5:
                posisi = [1, -1]
            elif currentDir == 6:
                posisi = [1, 0]
            elif currentDir == 7:
                posisi = [1, 1]
            dire = currentDir
    #         print("posisi")
    #         print(posisi)
    #         print("coor")
    #         print(coor)
            newCoor[0] = coor[0] + posisi[0]
            newCoor[1] = coor[1] + posisi[1]
    #         print("newCoor")
    #         print(newCoor)
            if newCoor[0] >= 0 and newCoor[1] >= 0 and newCoor[0] < maksCoorR-1 and newCoor[1] < maksCoorC-1:
                if img[newCoor[0], newCoor[1]] == 255:
                    ctrImg[newCoor[0], newCoor[1]] = 255
                    coor[0] = newCoor[0]
                    coor[1] = newCoor[1]
    #                 print(newCoor)
                    a = math.pow((newCoor[0] - coorHalfWrist[0] + 1),2)
                    b = math.pow((newCoor[1] - coorHalfWrist[1] + 1),2)
                    c = a + b
    #                 print(c)
                    distances = math.sqrt(c)
                    coorDis.append([])
                    direction.append([])
                    coorDis[count].append(newCoor[0])
                    coorDis[count].append(newCoor[1])
                    coorDis[count].append(distances)
                    direction[count].append(dire)
                    count += 1
                    break
                else:
                    currentDir += 1
            else:
                currentDir += 1
        if startCoor == coor:
            indikator = 0
    cv2.imwrite(os.path.join(dir_result, tail), ctrImg)
    
    # Distance Distribution Diagram
    sumbuX = []
    sumbuX = np.arange(len(coorDis))
    sumbuX = np.array(sumbuX)
    minDistance = np.amin(coorDis, axis =0)[2]
    indexDistance = np.argwhere(coorDis == minDistance)
    r = indexDistance[0][0]
    c = 0
    print(indexDistance)
    print(minDistance)
    
    newCoorDis = []
    for i in range(len(coorDis) - r):
        newCoorDis.append(coorDis[i+r])
    for i in range(r):
        newCoorDis.append(coorDis[i])
    newCoorDis = np.array(newCoorDis)
    print(len(newCoorDis))
    
    whiteDis = float(550)
    r = []
    c = []
    for i in range(len(newCoorDis)):
        if newCoorDis[i][0] > whiteDis:
            newCoorDis[i][2] = 0
    print(newCoorDis)
    distancess = []
    for i in range(len(newCoorDis)):
        distancess.append(newCoorDis[i][2])
    distancess = np.array(distancess)