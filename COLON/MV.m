clc;
clear;
close all;
load('test10.mat');
data=test10;
Label=data(:,11);

[n,m]=size(data);
rows=(1:n);  
testcount=floor((0.2)*n);

for fold=1 : 100
test_rows=randsample(rows,testcount);
train_rows=setdiff(rows,test_rows);
column=1;    
  for k=1: 10

    test=data(test_rows,:);
    train=data(train_rows,:);
    xtest=test(:,1:k);
    ytest=test(:,m);
    xtrain=train(:,1:k);
    ytrain=train(:,m);
%  NB=NaiveBayes.fit(xtrain,ytrain);
%      out=NB.predict(xtest);
      mysvm=svmtrain(xtrain,ytrain,'kernel_function','linear','boxconstraint',2);
      out=svmclassify(mysvm,xtest);
%  DT=ClassificationTree.fit(xtrain,ytrain);
%  out=DT.predict(xtest);
      for g=1 :testcount
         mv(g,column)=out(g,1);
      end
      column=column+1;
   end
one=0;  zero=0;
for i=1 :testcount
    for j=1 :10 
        if mv(i,j)==0 
            zero=zero+1;
        else
            one=one+1;
        end
    end
    if one > zero
        mv(i,11)=1;
    end
    if zero > one
        mv(i,11)=0;
    end
    if zero == one 
        z=rand;
        if z>0.5  
            mv(i,11)=1;
        else
          mv(i,11)=0;
        end
    end
    one=0;  zero=0;
end
sum=0;
    for j=1 : testcount
        if mv(j,11)==ytest(j)
            sum=sum+1;
        end
    end
    mvacc(fold)=sum/testcount;
 %%% TP - TN - FP -FN  
    TP(fold)=0;  TN(fold)=0;  FP(fold)=0;  FN(fold)=0;  
    for j=1 : testcount
        %TP%
        if mv(j,11)==0 && ytest(j)==0
           TP(fold)=TP(fold)+1;
        end
        %TN%
        if mv(j,11)==1 && ytest(j)==1
           TN(fold)=TN(fold)+1;
        end
        %FP%
        if mv(j,11)==0 && ytest(j)==1
           FP(fold)=FP(fold)+1;
        end
        %FN%
        if mv(j,11)==1 && ytest(j)==0
           FN(fold)=FN(fold)+1;
        end
    end
    mvsen(fold)= TP(fold)/(TP(fold)+FN(fold));
%     SenAr=SEN+SenAr;
    mvspe(fold)= TN(fold)/(TN(fold)+FP(fold));
%     SpeAr=SPE+SpeAr;
    mvmcc(fold)= (((TP(fold)*TN(fold)) - (FP(fold)*FN(fold)))/sqrt((TP(fold)+FP(fold))*(TP(fold)+FN(fold))*(TN(fold)+FP(fold))*(TN(fold)+FN(fold))));
%     MCCAr=mcc+MCCAr;   
end

maximumacc=round(max(mvacc),2);
maximumsen=round(max(mvsen),2);
maximumspe=round(max(mvspe),2);
maximummcc=round(max(mvmcc),2);
sum =0;  sumsen=0;  sumspe=0; summcc=0;
for i=1 :100 
    sum=sum+mvacc(i);
    sumsen=sumsen+mvsen(i);
    sumspe=sumspe+mvspe(i);
    summcc=summcc+mvmcc(i);
end
aveacc=round(sum/100,2);
avesen=round(sumsen/100,2);
avespe=round(sumspe/100,2);
avemcc=round(summcc/100,2);

 
disp(['Max Acc =   ', num2str(maximumacc)]);
disp(['Avg Acc =   ', num2str(aveacc)]);
disp(['Max Sensitivity =  ' ,  num2str(maximumsen)]);
disp(['Avg Sensitivity =  ' ,  num2str(avesen)]);
disp(['Max Specificity =  ' ,  num2str(maximumspe)]);
disp(['Avg Specificity =  ' ,  num2str(avespe)]);
disp(['Avg 1-Specificity (FPR) =  ' ,  num2str(1-avespe)]);
disp(['Max MCC =  ' ,  num2str(maximummcc)]);
disp(['Avg MCC =  ' ,  num2str(avemcc)]);
