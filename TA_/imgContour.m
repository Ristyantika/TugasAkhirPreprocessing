
% load('file_name.mat');
file1=strcat('D:\Nuzul Kuliah\TA\dataset\001_l_940_01.jpg');
img=imread(file1);
im0=img;
im=im0;
%file_name=get(handles.text2,'string');
%% ANISOTROPIC FILTER TO HAVE A BETTER EDGE DETECTION

%Anisotropic diffusion filter to preserve edges
im=anisodiff2D(im, 10, 1/7, 20, 1);
im = uint8(round(im - 1)); % Convert double to uint8

% %axes(handles.axes2)
% %imshow(im)
% % hold on
% % im=edge(im);
% %% find the contours of the palm with x and y data
% %[C1,H1]=imcontour(im,'r');
% [C1,H1]=imcontour(im);
% H1=get(H1,'children');
% % pause
% ref=1;
% longests=[0];
% for h=1:2
%     for i=1:(length(H1))
%         xi=get(H1(i),'xdata');
%         yi=get(H1(i),'ydata');
%             if length(xi) > length(ref)
%                 ref=xi;
%                 if (h==1)
%                 maxContourX = xi;
%                 maxContourY = yi;
%                 longests = i;
%                 else
%                     if (longests ~= i)
%                     maxContourX2 = xi;
%                     maxContourY2 = yi;
%                     end
%                 end
%             end
%     end
%     ref=1;
% end
% axes(handles.axes1)
% imshow(im)
% hold on
% plot(maxContourX,maxContourY,'*g');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%interestPoint%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% j=1;
% for i=15:length(maxContourX)-10
%     if maxContourX(i) ~= maxContourX(i-1)
%     if (maxContourX(i)>=(maxContourX(i-2))) && ((maxContourX(i))>=(maxContourX(i+2))) && (maxContourX(i)>=(maxContourX(i-3))) && (maxContourX(i))>=(maxContourX(i+3)) && (maxContourX(i)>=(maxContourX(i-4))) && (maxContourX(i))>=(maxContourX(i+4)) &&  maxContourX(i)>=(maxContourX(i-5)) && (maxContourX(i)) >=  (maxContourX(i+5))&& maxContourX(i) >= (maxContourX(i-6)) && (maxContourX(i)) >=  (maxContourX(i+6)) && maxContourX(i) >= (maxContourX(i-7)) && (maxContourX(i)) >=  (maxContourX(i+7))&& maxContourX(i) >= (maxContourX(i-8))  && (maxContourX(i))>=(maxContourX(i+8)) && maxContourX(i)>=(maxContourX(i-9)) && (maxContourX(i))>=(maxContourX(i+9))&& (maxContourX(i))>(maxContourX(i-10)) && (maxContourX(i))>(maxContourX(i+10))&& (maxContourX(i))>(maxContourX(i+11))&& (maxContourX(i))>(maxContourX(i-11)) && (maxContourX(i))>(maxContourX(i+12)) && (maxContourX(i))>(maxContourX(i-12)) && (maxContourX(i))>(maxContourX(i+13)) && (maxContourX(i))>(maxContourX(i-13)) && (maxContourX(i))>(maxContourX(i+14)) && (maxContourX(i))>(maxContourX(i-14))
%         interestPointX(j) = maxContourX(i);
%        	interestPointY(j) = maxContourY(i);
%         j=j+1;
%     end
%     end
% end
% % pause
% m=1;
% k=1;
% 
% finalPointX(m)=interestPointX(1,k);
% finalPointY(m)=interestPointY(1,k);
% 
% lastpoint=0;
% 
% while k <= (j-1)
%     p=k;
%     jump=0;
%     while p<=(j-1)
%     if p~=k
%     if (interestPointX(1,k) < interestPointX(1,p) + 10) && (interestPointX(1,k) > interestPointX(1,p) - 10)
%         if (interestPointY(1,k) < interestPointY(1,p) + 10) && (interestPointY(1,k) > interestPointY(1,p) - 10)
%             jump=jump+1;
%         end
%     end
%     end
%     p=p+1;
%     end
%     
%     
%     finalPointX(m)=interestPointX(1,k);
%     finalPointY(m)=interestPointY(1,k);
%     
%     k=k+jump;
%     k=k+1;
%     m=m+1;
% end
% 
% for i=1:3
%     [v(i),ind] = min(finalPointX);
%     w(i)=finalPointY(ind);  
%     finalPointX(ind) = [] ; % remove
%     finalPointY(ind) = [] ;
% end
% 
% 
% % axes(handles.axes3)
% % imshow(im)
% % hold on
% % plot(v,w,'*y');
% 
% 
% %% First intersection line between the edge and the web LEFT HAND
% 
% for i=1:3
%     [y(i),ind] = max(w);
%     x(i)=v(ind);  
%     v(ind) = [] ; % remove
%     w(ind) = [] ;
% end
% 
% pointFound=0;
% i=x(1);
% yy = (y(2) - y(1)).*(i - x(1))./(x(2) - x(1)) + y(1);
% m=(y(2)-y(1))/(x(2)-x(1));
% borde1 = [0 0];
% margin =1;
% 
% while (yy < 560) && (yy>5) && (pointFound ==0)
%     control = yy;
%     for j=1:(length(maxContourX)-1)
%         distanceX=sqrt(round(i)^2-(maxContourX(j)^2));
%         distanceY=sqrt((round(yy))^2-((maxContourY(j))^2));
%         if (round((maxContourX(j)))==round(i) && round((maxContourY(j)))==round(yy)) || (round((maxContourX(j)))==(round(i)+1) && round((maxContourY(j)))==(round(yy)+1)) || (round((maxContourX(j)))==(round(i)-1) && round((maxContourY(j)))==(round(yy)-1)) 
%             borde1 = [i yy];
%             pointFound = 1;
%         end
%     end
%     if m>0
%         i=i+1;
%         yy = (y(1) - y(2)).*(i - x(2))./(x(1) - x(2)) + y(2);
%         if (yy >= control + 2 )
%             yy = control + 1;
%             i=i-1;
%         end
%     end
%     if m<0
%         i=i-1;
%         yy = (y(1) - y(2)).*(i - x(2))./(x(1) - x(2)) + y(2);
%         if (yy >= control + 2 )
%             yy = control + 1;
%             i=i+1;
%         end    
%     end
%     if m == 0
%         yy=yy+1;
%     end
%     if (margin < 20)
%         pointFound=0;
%     end
%     margin = margin + 1;
% end
% %  plot(borde1(1),borde1(2),'*y')
%  
% %% Second intersection line between the edge and the web
% i = round(x(3)-1);
% yy = (y(2) - y(3)).*(i - x(3))./(x(2) - x(3)) + y(3);
% m=(y(2)-y(3))/(x(2)-x(3));
% borde2 = [0 0];
% 
% while (yy < 576) && (yy>5) % && (pointFound ==0)
%     control = yy;
%     for j=1:(length(maxContourX)-1)
%         if (round((maxContourX(j)))==round(i) && round((maxContourY(j)))==round(yy)) || (round((maxContourX(j)))==(round(i)+1) && round((maxContourY(j)))==(round(yy)+1)) || (round((maxContourX(j)))==(round(i)-1) && round((maxContourY(j)))==(round(yy)-1)) || (round((maxContourX(j)))==(round(i)+2) && round((maxContourY(j)))==(round(yy)+2)) || (round((maxContourX(j)))==(round(i)-2) && round((maxContourY(j)))==(round(yy)-2)) || (round((maxContourX(j)))==(round(i)+3) && round((maxContourY(j)))==(round(yy)+3)) || (round((maxContourX(j)))==(round(i)-3) && round((maxContourY(j)))==(round(yy)-3)) || (round((maxContourX(j)))==(round(i)+4) && round((maxContourY(j)))==(round(yy)+4)) || (round((maxContourX(j)))==(round(i)-4) && round((maxContourY(j)))==(round(yy)-4)) || (round((maxContourX(j)))==(round(i)+5) && round((maxContourY(j)))==(round(yy)+5)) || (round((maxContourX(j)))==(round(i)-5) && round((maxContourY(j)))==(round(yy)-5))
%             borde2=[];
%             borde2 = [i yy];
%             pointFound = 1;
%         end
%     end
%     if m<0
%     i=i+1;
%     yy = (y(3) - y(2)).*(i - x(2))./(x(3) - x(2)) + y(2);
%     if (yy <= control - 2 )
%         yy = control - 1;
%         i=i-1;
%     end
%     end
%     if m>0
%             i=i-1;
%             yy = (y(3) - y(2)).*(i - x(2))./(x(3) - x(2)) + y(2);
%             if (yy <= control - 2 )
%                 yy = control - 1;
%                 i=i+1;
%             end
%     end
% end
% % plot(borde2(1),borde2(2),'*y')
% % 
% % 
% % axes(handles.axes3)
% 
% pLine1 = [x(1) x(2) x(3)];
% pLine2 = [y(1) y(2) y(3)];
% 
% % plot(pLine1,pLine2)
% 
% pExtX1 = [x(1) borde1(1)];
% pExtY1 = [y(1) borde1(2)];
% pExtX2 = [x(3) borde2(1)];
% pExtY2 = [y(3) borde2(2)];
% % plot(pExtX1,pExtY1,'r')
% % plot(pExtX2,pExtY2,'r')
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%finalRegion%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %axes(handles.axes6)
% %imshow(im)
% % hold on
% 
% % plot(borde2(1),borde2(2),'*y')
% % plot(borde1(1),borde1(2),'*y')
% 
% % PAINT HERE THE MOST INTEREST POINTS
% 
% 
% v1=[x(1) y(1)];
% v2=[x(3) y(3)];
% 
% %% Draw the rectangle of decision and image rotation
% [m1 m2]=middlepoint2(v1,v2,borde1,borde2);
% [m3 m4]=square2(m1,m2);
% degree=degree_rot(m1,m2,m3,m4);
% 
% wow = imrotate(im0,degree); 
% 
% axes(handles.axes2)
% 
% imshow(wow);
% 
% 
% [out_image_m,out_ref_points_m] = rotate_image(degree, im0, [m1(1),m2(1),m3(1),m4(1);m1(2),m2(2),m3(2),m4(2)]);
% 
% hold on;
% 
% plot(out_ref_points_m(1,1),out_ref_points_m(2,1),'*y');
% plot(out_ref_points_m(1,2),out_ref_points_m(2,2),'*y');
% plot(out_ref_points_m(1,3),out_ref_points_m(2,3),'*y');
% plot(out_ref_points_m(1,4),out_ref_points_m(2,4),'*y');
% 
% % axes(handles.axes3)
% fPoint1=[m1(1) m2(1)];
% fPoint2=[m1(2) m2(2)];
% fPoint3=[m3(1) m4(1)];
% fPoint4=[m3(2) m4(2)];
% fPoint5=[m1(1) m3(1)];
% fPoint6=[m1(2) m3(2)];
% fPoint7=[m2(1) m4(1)];
% fPoint8=[m2(2) m4(2)];
% 
% % plot(fPoint1,fPoint2);
% % plot(fPoint3,fPoint4);
% % plot(fPoint5,fPoint6);
% % plot(fPoint7,fPoint8);
% 
% pLine1 = [x(1) x(2) x(3)];
% pLine2 = [y(1) y(2) y(3)];
% 
% % plot(pLine1,pLine2,'r')
% % plot(x(1),y(1),'*w')
% % plot(x(2),y(2),'*w')
% % plot(x(3),y(3),'*w')
% pExtX1 = [x(1) borde1(1)];
% pExtY1 = [y(1) borde1(2)];
% pExtX2 = [x(3) borde2(1)];
% pExtY2 = [y(3) borde2(2)];
% % plot(pExtX1,pExtY1,'r')
% % plot(pExtX2,pExtY2,'r')
% 
% 
% axes(handles.axes2)
% 
% %%%%%%draw the rectangle
% finalPoints1=[out_ref_points_m(1,1) out_ref_points_m(1,2)];
% finalPoints2=[out_ref_points_m(2,1) out_ref_points_m(2,2)];
% plot(finalPoints1,finalPoints2,'g'); %top
% finalPoints3=[out_ref_points_m(1,1) out_ref_points_m(1,3)];
% finalPoints4=[out_ref_points_m(2,1) out_ref_points_m(2,3)];
% plot(finalPoints3,finalPoints4,'g'); %left
% finalPoints5=[out_ref_points_m(1,3) out_ref_points_m(1,4)];
% finalPoints6=[out_ref_points_m(2,3) out_ref_points_m(2,4)];
% plot(finalPoints5,finalPoints6,'g'); %bottom
% finalPoints7=[out_ref_points_m(1,2) out_ref_points_m(1,4)];
% finalPoints8=[out_ref_points_m(2,2) out_ref_points_m(2,4)];
% plot(finalPoints7,finalPoints8,'g'); %right
% 
% % uiwait(msgbox('Crop the image by drawing a box, then right-clicking and choosing crop image'));
% % croppedImage = imcrop();
% 
% 
% topLine = round(out_ref_points_m(1,3));
% display(topLine);
% bottomLine = round(out_ref_points_m(1,4));
% display(bottomLine);
% leftColumn = round(out_ref_points_m(2,1));
% display(leftColumn);
% rightColumn = round(out_ref_points_m(2,3));
% display(rightColumn);
% width = bottomLine - topLine + 1;
% height = rightColumn - leftColumn + 1;
% croppedImage = imcrop(wow, [topLine, leftColumn, width,height]);
% axes(handles.axes3)
% imshow(croppedImage);
% 
% savename = strcat('D:\Nuzul Kuliah\TA\newMethod\',file_name);
% imwrite(croppedImage, savename);


