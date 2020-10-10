function [x,y] = getCentroid(img)
[n,m] = size(img);
xSum = 0;
ySum = 0;
s = sum(sum(img));
for i = 1:n
    for j = 1:m
        xSum = xSum+j*img(i,j);
        ySum = ySum +i*img(i,j);
    end
end
y = ySum/s;
x = xSum/s;
end