function [sourceFunction] = sourceVector(symbExp)
%SOURCEVECTOR Summary of this function goes here
%   Detailed explanation goes here
if isnumeric(symbExp)
    symbExp=num2str(symbExp);
end
syms z x0 x1
basis0=(1-z)/2;
basis1=(1+z)/2;
x=(x0*basis0)+(x1*basis1);
Int00=basis0*eval(symbExp);
Int01=basis1*eval(symbExp);
sourceint0=matlabFunction(int(Int00,z,[-1,1]),'Vars',[x0 x1]);
sourceint1=matlabFunction(int(Int01,z,[-1,1]),'Vars',[x0 x1]);
sourceFunction=@(x0,x1) [sourceint0(x0,x1) sourceint1(x0,x1)]';
end

