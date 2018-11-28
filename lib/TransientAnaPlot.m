x=linspace(0,1,11);
for i=1:11
    y(i)=TransientAnalyticSoln(x(i),0.3);
end
figure(2);
plot(x,y);