function [M3,M4]=FromEndtoStart(M1,M2,x1,y1, numRedPoint)
% M1是一个图像对应的矩阵，黄点记为-1，红点记为-2,黄点Alter为-3；
% M2是一个存储距离的零矩阵，和一样大。
% x1是此时选取的门的横坐标
% y1是此时选取的门的纵坐标
% 请备份M1与M2
CellofMM1=cell(302,3);

step =1;
numYellowAlter = 0;
MM1=M1;
for IDMM11=1:size(MM1,1)
    for IDMM12=1:size(MM1,1)
        if (IDMM11~=x1)&&(IDMM12~=y1)&&(M1(IDMM11,IDMM12)==-1)
        MM1(IDMM11,IDMM12)=-2;
        end
    end
end
MM2=M2;
for i = -1*step:step
    for j = -1*step:step
        if MM1(x1+i, y1+j) == -2 
            MM2(x1+i, y1+j) = 1;
%             if max(abs(i),abs(j)) == step                
%                 M1(x1+i, y1+j) = -1;
%             else
%                 M1(x1+i, y1+j) = -3;
%             end
            MM1(x1+i, y1+j) = -1;
            numRedPoint = numRedPoint - 1;
        end
        MM1(x1, y1) = -3;
    end
end
coco=1;
gongcha = 0;
for i = 1:size(MM1,1)
    for j = 1:size(MM1,2)
        if MM1(i,j) == -1
            gongcha = gongcha + 1;
        end
    end
end
Z = gongcha
CellofMM1{1,1}=MM1;
CellofMM1{1,2}=numRedPoint;
CellofMM1{1,2}=MM2;
%  XY=find(M1(:,:)==-1);
%  LocationMatrix=zeros(size(XY,1),2);

% while numRedPoint>0
% for qwertyTemp = 1:3
%       A=i
%       B=numRedPoint
%       C=numYellowAlter
%             for ID1=1:size(XY,1)
%                 if XY(ID1)<=size(M1,2)
%                    LocationMatrix(ID1,2)=XY(ID1);
%                    LocationMatrix(ID1,1)=1;
%                 else 
%                   LocationMatrix(ID1,2)=mod(XY(ID1),size(M1,2));
%                   LocationMatrix(ID1,1)=(XY(ID1)-mod(XY(ID1),size(M1,2)))/size(M1,2);
%                 end
%             end
%             for ID1111=1:size(XY,1)
%                 for i = -1*step:step
%                    for j = -1*step:step
%                        if M1(LocationMatrix(ID1111,1)+i, LocationMatrix(ID1111,2)+j) == -2 
%                           M2(LocationMatrix(ID1111,1)+i, LocationMatrix(ID1111,2)+j) = M2(x1, LocationMatrix(ID1111,2)) + 1;
%                           if max(abs(i),abs(j)) == step                
%                               M1(LocationMatrix(ID1111,1)+i, LocationMatrix(ID1111,2)+j) = -1;
%                           else
%                               M1(LocationMatrix(ID1111,1)+i, LocationMatrix(ID1111,2)+j) = -3;
%                           end
%                              numRedPoint = numRedPoint - 1;
%                        end
%                            M1(LocationMatrix(ID1111,1), LocationMatrix(ID1111,2)) = -3;
%                            numYellowAlter = numYellowAlter +1; %
%                            XY(find(XY(:,:)==(LocationMatrix(ID1111,1)-1)*size(M1,2)+LocationMatrix(ID1111,2)))=[];
%                    end
%                 end
%             end
%             if size(XY,1)==0
%                 break
%             end
%             D=size(XY,1)
%             i=i+1;
% end
 qwer=1; 
while (gongcha>0)&&(qwer<=300)
    pause(0.02);
  gongchananhe=0;
    M1=CellofMM1{qwer,1};
    for ID1=1:size(MM1,1)
        for ID2=1:size(MM1,2)
            if MM1(ID1,ID2)==-1  %黄-绿
               Figure(ID1,ID2,1)=0;
               Figure(ID1,ID2,2)=0;
               Figure(ID1,ID2,3)=0;
            elseif MM1(ID1,ID2)==-2  %红-棕色
               Figure(ID1,ID2,1)=0;
               Figure(ID1,ID2,2)=0;
               Figure(ID1,ID2,3)=0; 
            elseif MM1(ID1,ID2)==-3  %黄改-
               Figure(ID1,ID2,1)=255;
               Figure(ID1,ID2,2)=255;
               Figure(ID1,ID2,3)=255;
            elseif MM1(ID1,ID2)==0  %黑
               Figure(ID1,ID2,1)=0;
               Figure(ID1,ID2,2)=0;
               Figure(ID1,ID2,3)=0;
            end
        end
    end
    imshow(Figure,'InitialMagnification','fit')
%     cd('C:\Users\ty\Desktop\CA2\Graph');  
%         imwrite(Figure,strcat('Figure-',num2str(coco),'.jpg'),'jpg');
%     cd .. 
%     hold;
    A=coco
    B=numRedPoint
    C=numYellowAlter
for i = 2:size(MM1,1)-1
    for j = 2:size(MM1,2)-1
        if MM1(i,j) == -1
            for i1 = -1*step:step
                for j1 = -1*step:step
                    if MM1(i+i1, j+j1) == -2 
                        MM2(i+i1, j+j1) = qwer + 1;
                        MM1(i+i1, j+j1) = -1;
                        numRedPoint = numRedPoint - 1;
                    end
                    
                end
            end
            MM1(i, j) = -3;
            numYellowAlter = numYellowAlter +1;
        end
    end
end
coco=coco+1;
for i = 1:size(MM1,1)
    for j = 1:size(MM1,2)
        if MM1(i,j) == -1
            gongchananhe = gongchananhe + 1;
        end
    end
end
Z = gongchananhe
CellofMM1{qwer+1,1}=MM1;
CellofMM1{qwer+1,2}=numRedPoint;
CellofMM1{qwer+1,3}=MM2;
 qwer=qwer+1
 if CellofMM1{qwer+1,2}==CellofMM1{qwer,2}
     break
 end
end

M3=CellofMM1{301,1};
M4=CellofMM1{301,3};