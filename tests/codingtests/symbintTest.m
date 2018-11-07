syms x x0 x1
%x0=2;
%x1=3;
basis0=(1-x)/2;
basis1=(1+x)/2;
z=(x0*basis0)+(x1*basis1);

f=basis1*(1+(4*z));
sourceint1=matlabFunction(int(f,x,[-1,1]),'Vars',[x0 x1]);
sourceint1(2,3)

