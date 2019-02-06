function [D]=choic(Obst ,D, human)
%%
size1 = size(D,1);
size2 = size(D,2);
% Obst(9:2:25,[5 11 12 18])=Obst(9:2:25,[5 11 12 18]);
% Obst(5,1)=0;
% D=zeros(size1,size2);
%D(9:2:25,[4 5 6 10 11 12 13 17 18 19])=human;

X=zeros(size1,size2); 
Y=zeros(size1,size2);
Z=rand(size1,size2);
H=zeros(size1,size2);
%A(5,1)=0;
%D(5,1)=0;
%X(5,1)=0;
%Y(5,1)=0;
%Z(5,1)=0;

for x=2:(size1-1) 
    for y=2:(size2-1) 
        if D(x,y)==human
            E=max(Obst,D);
            F=E((x-1):1:(x+1),(y-1):(y+1));
            F(2,2)=Obst(x,y);
            G=sort(F);
            b=G(1,:);
            d=sort(b);
            if length(find(F==d(1)))==1 
                [r,c]=find(F==d(1));
                if r==2&&c==2 
                    X(x,y)=D(x,y);
                    Y(x,y)=x*sqrt(2)+y*sqrt(3);
                else p=x-2+r; 
                    q=y-2+c;
                    if p~=1
                        X(p,q)=human;
                        Y(x,y)=p*sqrt(2)+q*sqrt(3);
                    else X(x,y)=D(x,y);
                        Y(x,y)=x*sqrt(2)+y*sqrt(3);
                    end
                end
            else length(find(F==d(1)))==2;
                [r,c]=find(F==d(1));
                s=rand(1);
                if s>0.5
                    p=x-2+r(1);
                    q=y-2+c(1);
                    if p~=1
                        X(p,q)=human;
                        Y(x,y)=p*sqrt(2)+q*sqrt(3);
                    else X(x,y)=D(x,y);
                        Y(x,y)=x*sqrt(2)+y*sqrt(3);
                    end
                else
                    p=x-2+r(2);
                    q=y-2+c(2);
                    if p~=1;
                        X(p,q)=human;
                        Y(x,y)=p*sqrt(2)+q*sqrt(3);
                    else X(x,y)=D(x,y);
                        Y(x,y)=x*sqrt(2)+y*sqrt(3);
                    end
                end
            end
        end
    end
end
for x=2:(size1-1)
    for y=2:size2
        if X(x,y)>0
            Y1=Y((x-1):1:(x+1),(y-1):(y+1));
            Y2=Z((x-1):1:(x+1),(y-1):(y+1));
            w=x*sqrt(2)+y*sqrt(3);
           
            t=max(max((Y1==w).*Y2));
            [r1,c1]=find((Y1==w).*Y2==t);
            H(x-2+r1,y-2+c1)=human;
        end
    end
end

for x=2:(size1-1)
    for y=1
        if X(x,y)>0
            Y1=Y((x-1):1:(x+1),y:(y+1)); 
            Y2=Z((x-1):1:(x+1),y:(y+1));
            w=x*sqrt(2)+y*sqrt(3);
            %(Y1==w)*Y2;
            t=max(max((Y1==w).*Y2));
            [r1,c1]=find((Y1==w).*Y2==t);
            H(x-2+r1,c1)=human;
        end
    end
end
D=D+X-H;
end
