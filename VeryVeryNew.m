
%% Load the map and Read it
CellofMaps=cell(5,6);
% cd('C:\Users\ty\Desktop\CA2');
for ID=1:1
I=imread('MapPartAlter.png'); 
% I=imresize(I,[162,306]);
CellofMaps{ID,1}=I;
ObjectMap=CellofMaps{ID,1};
 for ID1 = 1:size(CellofMaps{ID,1},1)
     for ID2 = 1:size(CellofMaps{ID,1},2)
         if  ((ObjectMap(ID1,ID2,1)~=255)&&(ObjectMap(ID1,ID2,2)~=255)&&(ObjectMap(ID1,ID2,3)~=255))
            ObjectMap(ID1,ID2,1)=255;
            ObjectMap(ID1,ID2,2)=255;
            ObjectMap(ID1,ID2,3)=255;
         else
            ObjectMap(ID1,ID2,1)=0;
            ObjectMap(ID1,ID2,2)=0;
            ObjectMap(ID1,ID2,3)=0; 
         end
     end
 end
CellofMaps{ID,2}=ObjectMap;
CellofMaps{ID,3}=zeros(size(CellofMaps{ID,1},1),size(CellofMaps{ID,1},2)); 
CellofMaps{ID,4}=size(CellofMaps{ID,1},1)+size(CellofMaps{ID,1},2); %% The Biggest Distance
end
cd ..

%% Generate the Corresponding Space of Louvre and the bones
CellofRiskFactorDistribuition=cell(5,1);
CellofMapsWithBones=cell(5,2);
for ID=1:1
 InitialFactorDis=zeros(size(CellofMaps{ID,1},1),size(CellofMaps{ID,1},2)); 
 ObjectMap=CellofMaps{ID,2};
 for ID1=1:size(CellofMaps{ID,1},1)
     for ID2=1:size(CellofMaps{ID,1},2)
         if (ObjectMap(ID1,ID2,1)==0)&&(ObjectMap(ID1,ID2,2)==0)&&(ObjectMap(ID1,ID2,3)==0)
            InitialFactorDis(ID1,ID2)=CellofMaps{ID,4};%% Generate the Wall
         end
     end
 end
CellofRiskFactorDistribuition{ID,1}=InitialFactorDis;
ObjectMapGray=CellofMaps{ID,2};
ObjectMapGray1=im2bw(ObjectMapGray,0.88);         
ObjectMapGray2=bwmorph(ObjectMapGray1,'remove');   
ObjectMapGray3=bwmorph(ObjectMapGray1,'skel',Inf);  
CellofMapsWithBones{ID,1}=ObjectMapGray3;
CellofMapsWithBones{ID,2}=ObjectMapGray1;
end

%% Generate the People
TheNumberofPeople=[100 100 100 100 100];
CellofGenerateLocation=cell(5,2);
for ID=1:1
    InitialLocationofPeople=zeros(size(CellofMaps{ID,1},1),size(CellofMaps{ID,1},2)); 
    GenerateLocationX=randi([1 size(CellofMaps{ID,1},1)],1,TheNumberofPeople(ID));
    GenerateLocationY=randi([1 size(CellofMaps{ID,1},2)],1,TheNumberofPeople(ID));
    GenerateLocationXY=cell(TheNumberofPeople(ID),1);
    for IDLocation=1:TheNumberofPeople(ID)
        GenerateLocationXY{IDLocation,1}=[GenerateLocationX(IDLocation) GenerateLocationY(IDLocation)];
    end
    CellofGenerateLocation{ID,1}=GenerateLocationXY;
    InitialFactorDis=CellofRiskFactorDistribuition{ID,1};
    NeedtoDelete=zeros(TheNumberofPeople(ID),1);
    for IDLocation=1:TheNumberofPeople(ID)
        TestLocation=GenerateLocationXY{IDLocation,1};
        if (InitialFactorDis(TestLocation(1),TestLocation(2))==CellofMaps{ID,4})
            NeedtoDelete(IDLocation,1)=1;
        elseif (0<TestLocation(1)+1<=size(CellofMaps{ID,2},1))&&(0<TestLocation(2)+1<=size(CellofMaps{ID,2},2))
            if (InitialFactorDis(TestLocation(1)+1,TestLocation(2)+1)==CellofMaps{ID,4})
            NeedtoDelete(IDLocation,1)=1;
            end
        elseif (0<TestLocation(1)+1<=size(CellofMaps{ID,2},1))&&(0<TestLocation(2)<=size(CellofMaps{ID,2},2))
            if (InitialFactorDis(TestLocation(1)+1,TestLocation(2))==CellofMaps{ID,4})
            NeedtoDelete(IDLocation,1)=1;
            end
        elseif (0<TestLocation(1)<=size(CellofMaps{ID,2},1))&&(0<TestLocation(2)+1<=size(CellofMaps{ID,2},2))
            if (InitialFactorDis(TestLocation(1),TestLocation(2)+1)==CellofMaps{ID,4})
            NeedtoDelete(IDLocation,1)=1;
            end    
        elseif (0<TestLocation(1)-1<=size(CellofMaps{ID,2},1))&&(0<TestLocation(2)-1<=size(CellofMaps{ID,2},2))
            if (InitialFactorDis(TestLocation(1)-1,TestLocation(2)-1)==CellofMaps{ID,4})
            NeedtoDelete(IDLocation,1)=1;
            end 
        elseif (0<TestLocation(1)-1<=size(CellofMaps{ID,2},1))&&(0<TestLocation(2)<=size(CellofMaps{ID,2},2))
            if (InitialFactorDis(TestLocation(1)-1,TestLocation(2))==CellofMaps{ID,4})
            NeedtoDelete(IDLocation,1)=1;
            end
        elseif (0<TestLocation(1)<=size(CellofMaps{ID,2},1))&&(0<TestLocation(2)-1<=size(CellofMaps{ID,2},2))
            if (InitialFactorDis(TestLocation(1),TestLocation(2)-1)==CellofMaps{ID,4})
            NeedtoDelete(IDLocation,1)=1;
            end
        end
    end
    GenerateLocationXY(find(NeedtoDelete(:)==1))=[];
    while size(GenerateLocationXY,1)<size(CellofGenerateLocation{ID,1},1)
          NewGenerateLocationX=randi([1 size(CellofMaps{ID,1},1)],1,1);
          NewGenerateLocationY=randi([1 size(CellofMaps{ID,1},2)],1,1);
          RepeatOrNot=zeros(size(GenerateLocationXY,1),1);
          for IDRepeat=1:size(GenerateLocationXY,1)
              NeedtoTest=GenerateLocationXY{IDRepeat,1};
              if (NewGenerateLocationX==NeedtoTest(1))&&(NewGenerateLocationY==NeedtoTest(2))
                 RepeatOrNot(IDRepeat,1)=1;
              end
          end
          if (InitialFactorDis(NewGenerateLocationX,NewGenerateLocationY)~=CellofMaps{ID,4})&&(sum(sum(RepeatOrNot))==0)
              GenerateLocationXY{end+1,1}=[NewGenerateLocationX NewGenerateLocationY];
          end
    end
    CellofGenerateLocation{ID,2}=GenerateLocationXY;
    InitialLocationMap=CellofMaps{ID,2};
    Bones=CellofMapsWithBones{ID,1};
    for ID1=1:size(InitialLocationMap,1)
        for ID2=1:size(InitialLocationMap,2)
            if  Bones(ID1,ID2)==1
                InitialLocationMap(ID1,ID2,1)=255;
                InitialLocationMap(ID1,ID2,2)=0;
                InitialLocationMap(ID1,ID2,3)=0;
            end
        end
    end
        CellofMaps{ID,6}=InitialLocationMap;
    for IDPeople=1:TheNumberofPeople(ID)
        PickedLocation=GenerateLocationXY{IDPeople,1};
        InitialLocationofPeople(PickedLocation(1),PickedLocation(2))=1;
        InitialLocationMap(PickedLocation(1),PickedLocation(2),1)=0;
        InitialLocationMap(PickedLocation(1),PickedLocation(2),2)=255;
        InitialLocationMap(PickedLocation(1),PickedLocation(2),3)=255;
    end
     CellofMaps{ID,5}=InitialLocationMap;
end

%% Where is the Gate
    CellofGatePosition=cell(5,1);
    for ID=1:1
         GatePosition=zeros(size(CellofMaps{ID,1},1),size(CellofMaps{ID,1},2));
        InitialLocationMap=CellofMaps{ID,6};
       for ID1=1:size(CellofMaps{ID,1},1)
         for ID2=1:size(CellofMaps{ID,1},2)
             ObjectMapofGate=CellofMaps{ID,1};
            if (ObjectMapofGate(ID1,ID2,1)==237)&&(ObjectMapofGate(ID1,ID2,2)==28)&&(ObjectMapofGate(ID1,ID2,3)==36)&&(InitialLocationMap(ID1,ID2,1)==255)&&(InitialLocationMap(ID1,ID2,2)==0)&&(InitialLocationMap(ID1,ID2,3)==0)
                 InitialLocationMap(ID1,ID2,1)=255;
                 InitialLocationMap(ID1,ID2,2)=255;
                 InitialLocationMap(ID1,ID2,3)=0; 
                 GatePosition(ID1,ID2)=1;
                 Bones(ID1,ID2)=0;
            end
         end
       end
       FindofYelllow=find(GatePosition(:,:)==1);
       for ID33=1:size(FindofYelllow,1)
           FindofYelllow(ID33,2)=mod(FindofYelllow(ID33,1),size(CellofMaps{ID,1},2));
           FindofYelllow(ID33,1)=(FindofYelllow(ID33,1)-FindofYelllow(ID33,2))/size(CellofMaps{ID,1},2);
       end
%        DisofYellow=zeros(size(PositionofYellow,1),size(PositionofYellow,1));
%        for ID55=1:size(PositionofYellow,1)
%            for ID66=1:size(PositionofYellow,1)
%                DisofYellow(ID55,ID66)=(PositionofYellow(ID55,1)-PositionofYellow(ID66,1))^2+(PositionofYellow(ID55,2)-PositionofYellow(ID66,2))^2;
%            end
%        end
          MatrxiUsedToRecord=zeros(size(InitialLocationMap,1),size(InitialLocationMap,2));
%                 for ID1=1:size(FindofYelllow,1)                 
%                             if (InitialLocationMap(FindofYelllow(ID1,1)+WhatTOPlus(1,IDP1),FindofYelllow(ID1,2)+WhatTOPlus(1,IDP2),1)~=255)&&(InitialLocationMap(FindofYelllow(ID1,1)+WhatTOPlus(1,IDP1),FindofYelllow(ID1,2)+WhatTOPlus(1,IDP2),2)~=0)&&(InitialLocationMap(FindofYelllow(ID1+WhatTOPlus(1,IDP1),1)+1,FindofYelllow(ID1,2)+WhatTOPlus(1,IDP2),3)~=0)
%                                MatrxiUsedToRecord(FindofYelllow(ID1,1),FindofYelllow(ID1,2))=1;
%                             end
%                 end
                for ID1=1:size(FindofYelllow,1)                 
                        if  (size(find(Bones(FindofYelllow(ID1,1)-1:FindofYelllow(ID1,1)+1,FindofYelllow(ID1,2)-1:FindofYelllow(ID1,2)+1)==1),1)==1)&&(Bones(FindofYelllow(ID1,1),FindofYelllow(ID1,2))==1)
                                InitialLocationMap(FindofYelllow(ID1,1),FindofYelllow(ID1,2),1)=255;
                                InitialLocationMap(FindofYelllow(ID1,1),FindofYelllow(ID1,2),2)=0;
                                InitialLocationMap(FindofYelllow(ID1,1),FindofYelllow(ID1,2),3)=0;
                                MatrxiUsedToRecord(FindofYelllow(ID1,1),FindofYelllow(ID1,2))=1;
                        end
                end
          imshow(InitialLocationMap,'InitialMagnification','fit');
          CellofMaps{ID,5}=InitialLocationMap;
      CellofGatePosition{ID,1}=GatePosition; 
             GateID=zeros(size(CellofMaps{ID,1},1),size(CellofMaps{ID,1},2));
      for ID1=1:size(CellofMaps{ID,1},1)
          for ID2=1:size(CellofMaps{ID,1},2)
              GateID(ID1,ID2)=(ID1-1)*size(CellofMaps{ID,1},2)+ID2;
          end
      end
      IDofGate=GateID(find(GatePosition(:,:)==1));
    end
    
%% Where is the Path and Generate the Field
    CellofBonesPosition=cell(5,3);
    BonesPosition=zeros(size(CellofMaps{ID,1},1),size(CellofMaps{ID,1},2));
    CellofCellofField=cell(5,2);
    for ID=1:1
       ObjectMapofThisFloor=CellofMaps{ID,5};
       CellofField=cell(size(IDofGate,1),2);
       for ID1=1:size(CellofMaps{ID,1},1)
         for ID2=1:size(CellofMaps{ID,1},2)
            ObjectMap=CellofMaps{ID,6};
            if (ObjectMap(ID1,ID2,1)==255)&&(ObjectMap(ID1,ID2,2)==0)&&(ObjectMap(ID1,ID2,3)==0)
                BonesPosition(ID1,ID2)=1;
            else
                BonesPosition(ID1,ID2)=5000;
            end
         end
       end
      RecordOfBones=find(BonesPosition(:,:)==1);
      MatrixofBonesLocation=zeros(size(RecordOfBones,1),2);
      for IDRecord=1:size(RecordOfBones,1)
          if RecordOfBones(IDRecord)<=size(CellofMaps{ID,1},2)
             MatrixofBonesLocation(IDRecord,1)=1;
             MatrixofBonesLocation(IDRecord,2)=RecordOfBones(IDRecord);
          else 
             MatrixofBonesLocation(IDRecord,2)=mod(RecordOfBones(IDRecord),size(CellofMaps{ID,1},2));
             MatrixofBonesLocation(IDRecord,1)=(RecordOfBones(IDRecord)-mod(RecordOfBones(IDRecord),size(CellofMaps{ID,1},2)))/size(CellofMaps{ID,1},2);
          end
      end
      DistanceBetweenBones=zeros(size(RecordOfBones,1),size(RecordOfBones,1));
      for IDDB1=1:size(RecordOfBones,1)
          for IDDB2=1:size(RecordOfBones,1)
              DistanceBetweenBones(IDDB1,IDDB2)=abs(MatrixofBonesLocation(IDDB1,1)-MatrixofBonesLocation(IDDB2,1))+abs(MatrixofBonesLocation(IDDB1,2)-MatrixofBonesLocation(IDDB2,2));
          end
      end
      CellofBonesPosition{ID,1}=BonesPosition;
      CellofBonesPosition{ID,2}=DistanceBetweenBones;
      BonesID=zeros(size(CellofMaps{ID,1},1),size(CellofMaps{ID,1},2));
      for ID1=1:size(CellofMaps{ID,1},1)
          for ID2=1:size(CellofMaps{ID,1},2)
              BonesID(ID1,ID2)=(ID1-1)*size(CellofMaps{ID,1},2)+ID2;
          end
      end
      DangerField=zeros(size(CellofMaps{ID,1},1),size(CellofMaps{ID,1},2));
      SpaceUsedforAnalyze1=zeros(size(CellofMaps{ID,1},1),size(CellofMaps{ID,1},2));
      for IDDraw1=1:size(CellofMaps{ID,1},1)
          for IDDraw2=1:size(CellofMaps{ID,1},2)
              if GatePosition(IDDraw1,IDDraw2)==1
                  SpaceUsedforAnalyze1(IDDraw1,IDDraw2)=-1;
              elseif BonesPosition(IDDraw1,IDDraw2)==1
                  SpaceUsedforAnalyze1(IDDraw1,IDDraw2)=-2;
              end
          end
      end    
      SpaceUsedforAnalyze2=zeros(size(CellofMaps{ID,1},1),size(CellofMaps{ID,1},2));
      for IDDraw1=1:size(CellofMaps{ID,1},1)
          for IDDraw2=1:size(CellofMaps{ID,1},2)
              if GatePosition(IDDraw1,IDDraw2)==1
                  SpaceUsedforAnalyze2(IDDraw1,IDDraw2)=1;
              end
          end
      end   
      for IDGateSelected=1:1
          if IDofGate(IDGateSelected,1)<=size(CellofMaps{ID,1},2)
              XofGate=1;
              YofGate=IDofGate(IDGateSelected,1);
          else
              YofGate=mod(IDofGate(IDGateSelected,1),size(CellofMaps{ID,1},2));
              XofGate=(IDofGate(IDGateSelected,1)-mod(IDofGate(IDGateSelected,1),size(CellofMaps{ID,1},2)))/size(CellofMaps{ID,1},2);
          end
          Bones=CellofMapsWithBones{ID,1};
          NumRedPoint=sum(sum(Bones));
          [SpaceUsedforAnalyze3,SpaceUsedforAnalyze4]=FromEndtoStart(SpaceUsedforAnalyze1,SpaceUsedforAnalyze2,XofGate,YofGate,NumRedPoint);
          DangerField=SpaceUsedforAnalyze4;
          ObjectMapGray1=CellofMaps{ID,2};
          InitialLocationMap=CellofMaps{ID,5};
          DangerField1=DangerField;
          for ID1=9:size(DangerField1,1)-9
              for ID2=9:size(DangerField1,2)-9
                  if (ObjectMapGray1(ID1,ID2,1)==255)&&(ObjectMapGray1(ID1,ID2,2)==255)&&(ObjectMapGray1(ID1,ID2,3)==255)&&(BonesPosition(ID1,ID2)~=1)
                        DisSpace=ones(size(DangerField1,1),size(DangerField1,2))*999999;
                            for IDSearch1=ID1-8:ID1+8
                              for IDSearch2=ID2-8:ID2+8
                                 if BonesPosition(IDSearch1,IDSearch2)==1
                                   DisSpace(IDSearch1,IDSearch2)=abs(ID1-IDSearch1)+abs(ID2-IDSearch2);
                                 end
                              end
                            end
                            RecordDistance=min(min(DisSpace));
                            [XWanted YWanted]=find(DisSpace(:,:)==min(min(DisSpace)));
                            DangerField1(ID1,ID2)=DangerField1(XWanted(1),YWanted(1))+RecordDistance;                       
                  end
              end
            DisPlayX=ID1
          end
%          DangerGraph=mapminmax(DangerField1,0,255);
          DangerGraph=DangerField1;
          GraphNeedforField=zeros(size(DangerField1,1),size(DangerField1,2),3);
          for IDG1=1:size(DangerField1,1)
              for IDG2=1:size(DangerField1,2)
                  if DangerField1(IDG1,IDG2)==0
                     GraphNeedforField(IDG1,IDG2,1)=255;
                     GraphNeedforField(IDG1,IDG2,2)=255;
                     GraphNeedforField(IDG1,IDG2,3)=255; 
                  else
                     GraphNeedforField(IDG1,IDG2,1)=255-min(DangerGraph(IDG1,IDG2)*3,255);
                     GraphNeedforField(IDG1,IDG2,2)=30;
                     GraphNeedforField(IDG1,IDG2,3)=min(DangerGraph(IDG1,IDG2)*3,255);
                  end
              end
          end 
          CellofField{IDGateSelected,1}=DangerField1; 
          CellofField{IDGateSelected,2}=GraphNeedforField;
      end
       CellofCellofField{ID,1}=CellofField;
    end
    
%% Let's Run, there is something bad
for ID=1:1
    NeededSpaceDistributation=ones(size(CellofMaps{ID,2},1),size(CellofMaps{ID,2},2))*99999;
    SpaceDistributation=CellofMaps{ID,2};
    for ID1=1:size(SpaceDistributation,1)
        for ID2=1:size(SpaceDistributation,2)
            if (SpaceDistributation(ID1,ID2,1)==255)&&(SpaceDistributation(ID1,ID2,2)==255)&&(SpaceDistributation(ID1,ID2,3)==255)
                NeededSpaceDistributation(ID1,ID2)=0;
            end
        end
    end
    
    NeededHumanDistributation=zeros(size(CellofMaps{ID,2},1),size(CellofMaps{ID,2},2));
    for ID3=1:size(GenerateLocationXY,1)
        XYP=GenerateLocationXY{ID3,1};
        XP=XYP(1,1);
        YP=XYP(1,2);
        NeededHumanDistributation(XP,YP)=99999;
    end
    
    CellofField=CellofCellofField{ID,1};
    NeededDangerField=CellofField{1,1};
    for ID1=1:size(NeededDangerField,1)
        for ID2=1:size(NeededDangerField,2)
            if NeededDangerField(ID1,ID2)==0
                NeededDangerField(ID1,ID2)=99999;
            end
        end
    end
    
    ObjectMapofGate=CellofMaps{ID,1};
    NeededGateDistributation=zeros(size(CellofMaps{ID,2},1),size(CellofMaps{ID,2},2));
    for ID1=1:size(NeededGateDistributation,1)
        for ID2=1:size(NeededGateDistributation,1)
            if (ObjectMapofGate(ID1,ID2,1)==238)&&(ObjectMapofGate(ID1,ID2,2)==21)&&(ObjectMapofGate(ID1,ID2,3)==30)
                NeededGateDistributation(ID1,ID2)=1;
            end
        end
    end
    
end
    
 Automaton(NeededSpaceDistributation,NeededDangerField,NeededHumanDistributation,NeededGateDistributation);    
    
    
    
