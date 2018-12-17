clc;
clear;
close all
load('colon.mat')
new=colon;        
avg.normal=[0];
avg.tumor=[0];
avg.minn=[0]; avg.maxn=[0];  avg.meanNormal=0;
avg.mint=[0]; avg.maxt=[0];  avg.meanTumor=0;
pop=repmat(avg,2000,1);
for i=1: 2000
    c1=0;  c2=0;
    pop(i).minn=new(1,i);
    pop(i).maxn=new(1,i); 
    pop(i).mint=new(1,i);
    pop(i).maxt=new(1,i);
    for j=1: 62  
        if (new(j,2001)==1)
            pop(i).normal=new(j,i)+pop(i).normal;
            c1=c1+1;
            if new(j,i) < pop(i).minn  
                pop(i).minn=new(j,i);
            else
                if new(j,i)> pop(i).maxn
                pop(i).maxn=new(j,i);
                end
            end
        else
            pop(i).tumor=new(j,i)+pop(i).tumor;
            c2=c2+1;
            if new(j,i) < pop(i).mint  
                 pop(i).mint=new(j,i);
            else
                if new(j,i)> pop(i).maxt
                  pop(i).maxt=new(j,i);
                end
            end
        end
        
           
        
    end
        
    pop(i).meanNormal=pop(i).normal/c1;
    pop(i).meanTumor=pop(i).tumor/c2;
    
end
%%disp (pop(2).normal);
%%disp (pop(2).tumor);
%% problem definition

nWhale=2000;   %% number of whales
%%lowerBound = [-100,-100]; upperBound=[100,100];  bounds of variables
maxIt=100;

%% Initial pop & function
% q=1;
  
Whale.x=[];
Whale.y=[];
Whale.meanNormal=[];
Whale.meanTumor=[];
Whale.index=[];
Whale.fit=[];
fitFunction=@Fitness;
npop=repmat(Whale,nWhale,1);

for i=1:nWhale
    %% initialize position
    npop(i).x=unifrnd(pop(i).minn,pop(i).maxn);
    npop(i).y=unifrnd(pop(i).mint,pop(i).maxt);
    npop(i).meanNormal=pop(i).meanNormal;
    npop(i).meanTumor=pop(i).meanTumor;
    npop(i).index=i;
    %% evaluate position
    npop(i).fit=fitFunction(npop(i).x,npop(i).y,npop(i).meanNormal,npop(i).meanTumor);   
end
%% finding leader
% max=npop(1).fit;
% for s=2: nWhale
%     if npop(s).fit>max
%         max=npop(s).fit;
%         ind=npop(s).index;
%     end
% end

[value, ind]= max([npop.fit]);
leader=npop(ind);
ttt=leader;
x_rand.x=[];
x_rand.y=[];
x_new.x=[];
x_new.y=[];
x_temp.x=[];
x_temp.y=[];
x_temp2.x=[];
x_temp2.y=[];
for i=1: maxIt
    a=2-i*(2/maxIt);
    for j=1:nWhale
        r1= rand(); % r1 is a random number in [0 1]
        r2= rand(); % r2 is a random number in [0 1]
        A=2*a*r1-a;
        C=2*r2;
        b=1;
        l=unifrnd(-1, 1);
        p=rand();
        
            if p<0.5
                if abs(A)>=1
                    rand_index=floor(nWhale*rand()+1);
                    x_rand.x=npop(rand_index).x;
                    x_rand.y=npop(rand_index).y;
                    x_new.x=npop(j).x;
                    x_new.y=npop(j).y;
                    x_t.x=C*x_rand.x;
                    x_t.y=C*x_rand.y;
                    x_t.x=abs(x_t.x-x_new.x);
                    x_t.y=abs(x_t.y-x_new.y);
                    D=x_t;
                    %D=abs(x_rand-x_new);
                    x_t.x=A*x_t.x;
                    x_t.y=A*x_t.y;
                    x_temp.x=x_rand.x -x_t.x;
                    x_temp.y=x_rand.y -x_t.y;
                    npop(j).x=x_temp.x;
                    npop(j).y=x_temp.y;
                elseif abs(A)<1
                    x_temp.x=leader.x;
                    x_temp.y=leader.y;
                    x_temp2.x=npop(j).x;
                    x_temp2.y=npop(j).y;
                    x_temp.x=C*x_temp.x;
                    x_temp.y=C*x_temp.y;
                    D_leader.x=abs(x_temp.x-x_temp2.x);
                    D_leader.y=abs(x_temp.y-x_temp2.y);
                    D_leader.x=A*D_leader.x;
                    D_leader.y=A*D_leader.y;
                    x_temp.x=x_temp.x - D_leader.x;
                    x_temp.y=x_temp.y - D_leader.y;
                    npop(j).x=x_temp.x;
                    npop(j).y=x_temp.y;
                end
           elseif p>=0.5
               x_temp.x=leader.x;
               x_temp.y=leader.y;
               distance2Leader.x=leader.x-npop(j).x;
               distance2Leader.y=leader.y-npop(j).y;
               npop(j).x= distance2Leader.x*exp(b*l)*cos(2*pi*l)+leader.x;
               npop(j).y= distance2Leader.y*exp(b*l)*cos(2*pi*l)+leader.y;
            end
    
    %% check boundries
  
    npop(j).x=max(npop(j).x,pop(j).minn);
    npop(j).x=min(npop(j).x,pop(j).maxn);
    npop(j).y=min(npop(j).y,pop(j).maxt);
    npop(j).y=max(npop(j).y,pop(j).mint);
   
    %% calculate fitness
    npop(j).fit= fitFunction(npop(j).x,npop(j).y,npop(j).meanNormal,npop(j).meanTumor);
    %% update leader
    if npop(j).fit > leader.fit
        leader = npop(j);
    end
    disp(['In Iteration= ' num2str(i) 'Best Fit=' num2str(leader.fit)]);
    
    end  
 
end
disp(['best fitness=' num2str(leader.fit)]);
disp(' ');
disp(['best solution found is=' num2str(leader.index)]);
for k=1: nWhale
           B(1,k)=npop(k).fit;
           B(2,k)=npop(k).index;
end
  
 for k=1 : nWhale
        max = B(1,k);
        pos=k;
        for m=k+1: nWhale
            if B(1,m)> max
                max=B(1,m);
                pos=m;
            end
        end
        for m=1 : 2
            temp=B(m,k);
            B(m,k)=B(m,pos);
            B(m,pos)=temp;
        end
end
mat=[];
nmat=repmat(mat,1,50);
for i=1 :2
 for j=1: 1000  %50->1000
      BB(i,j)=B(i,j);
%    nmat(j)=B(i,j);
  end
end
BB

 for j=1: 1000  %50->1000
      BBind(1,j)=B(2,j);
%    nmat(j)=B(i,j);
  end
features=mat2str(BBind);
features
%% constructing new matrix by discarding the least 50%
for i=1 : 1000
    for j=1 :62
        newcolon(j,i)=new(j,B(2,i));
    end
end
for j=1  : 62
    newcolon(j,1001)=new(j,2001);
end

