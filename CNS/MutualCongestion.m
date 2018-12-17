clc;
clear;
close all;
load('newCNS.mat')


for i=1 :3565
    for j=1 :60
        data(j,i).val=newCNS(j,i);
        data(j,i).label=newCNS(j,3566);
        
    end
        f(i).m1=0;
        f(i).m2=0;
        f(i).m3=0;
        f(i).m4=0;
        f(i).m5=0;
end
% %% ordering each col based on theri labels
for i=1 : 3565
    for j=1 : 60
        for k=j+1 :60
            if data(k,i).val<data(j,i).val
                 temp=data(k,i);
                 data(k,i)=data(j,i);
                 data(j,i)=temp;
            end
        end
    end
end


j=1;
for i=1 :3565
    if data(j,i).label==0
        while data(j,i).label==0
           f(i).m1=f(i).m1+1;
           j=j+1;
        end
    else
        while data(j,i).label==1
            f(i).m1=f(i).m1+1;
            j=j+1;
        end
    end
    j=1;
end
 c=0;
 
for i=1 : 3565
  if data(1,i).label==0
    for j=1 :60 
        if data(j,i).label==0
            c=c+1;
            if c==39
              jj(i)=j;
%               a(i).zero=jj;
              j=61;
           end
        end
    end
  else
      for s=1 :60 
        if data(s,i).label==1
            c=c+1;
            if c==21
              jj(i)=s;
%               a(i).one=jj;
              s=61;
            end
        end
        
      end
  end
        f(i).m4=60-jj(i);
        c=0;
end
  c0=0;  c1=0;
for i=1 :3565
  if data(1,i).label==0 
      for j=2 :60 
        if data(j,i).label==1
            cc(i)=j;
           % j=63;
           break;
        end
      end
      for j=cc(i) : jj(i)
          if data(j,i).label==1
             f(i).m3=f(i).m3+1;
          end
          if data(j,i).label==0
             f(i).m2=f(i).m2+1;
          end
      end
%       f(i).m2=c0;
%       f(i).m3=c1;
  else
      for j=2 :60
        if data(j,i).label==0
            cc(i)=j;
           % j=63;
           break;
        end
      end
      for j=cc(i) : jj(i)
          if data(j,i).label==1
             f(i).m2=f(i).m2+1;
          end
          if data(j,i).label==0
             f(i).m3=f(i).m3+1;
          end
      end
%       f(i).m2=c1;
%       f(i).m3=c0;
 end
   c0=0; c1=0;
end
for i=1 : 3565
    f(i).m5= (f(i).m2+ f(i).m3) /(f(i).m1+ f(i).m2+f(i).m3+ f(i).m4);
end
for i=1 : 3565
    d(i)= f(i).m5;
end
[value, ind]= sort(d);
% %% constructing new matrix by discarding the least 25%
% for i=1 : 1500
%     for j=1 :62
%         new(j,i)=colon(j,ind(i));
%     end
% end
% for j=1  : 62
%     new(j,1501)=colon(j,2001);
% end
