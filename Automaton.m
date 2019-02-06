function []=Automaton(A,B,C,L)

% A 地形矩阵：所有障碍物的值为99999，其余为0
% B 势能场分布图
% C 人员矩阵：初始时人员的分布，所有人的坐标为99999，其余为0
human = 99999;
for g=1:500
    pause(0.1);
    % 200次肯定可以结束，可以尝试用while，这里懒得了……
%imshow(max(A,C)==0,'InitialMagnification','fit')%取最大的作为人员在教室的分布，以及给出教室轮廓和障碍物图像
Graph=255*ones(size(A,1),size(A,2),3);
for ID1=1:size(A,1)
    for ID2=1:size(A,2)
        if A(ID1,ID2)==99999
           Graph(ID1,ID2,1)=0;
           Graph(ID1,ID2,2)=0;
           Graph(ID1,ID2,3)=0;
        elseif C(ID1,ID2)==99999
           Graph(ID1,ID2,1)=0;
           Graph(ID1,ID2,2)=0;
           Graph(ID1,ID2,3)=255; 
        end
    end
end
imshow(Graph,'InitialMagnification','fit')

% 其后两个参数是为了调整图像的大小
% pause(0.1);
C(find(L(:,:)==1))=0;
%给出教室的人员时间步更新
C=choic(B,C,human);

end