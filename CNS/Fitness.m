function fit=Fitness(x,y,meanNormal,meanTumor)

fit=sqrt((x-meanTumor)^2 + (y-meanNormal)^2);
end
