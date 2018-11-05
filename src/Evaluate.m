function [value] = Evaluate(Problem,x)
%EVALUATE Summary of this function goes here
%   Detailed explanation goes here

%Work out position of x in nvec
flooredValue=x-Problem.mesh.xmin; % Convert value to a position from x=0;
containedElem=1+fix(flooredValue/Problem.mesh.dx); %Find which element the value is in.
c0NodeID=containedElem;
c1NodeID=c0NodeID+1;
c0NodeValue=Problem.Result(c0NodeID);
c1NodeValue=Problem.Result(c1NodeID);
internalposition=(2*(rem(flooredValue,Problem.mesh.dx)/Problem.mesh.dx))-1;

%Using linear basis function so c=c0basis0+c1basis1
basis0=@(z) (1-z)/2;
basis1=@(z) (1+z)/2;
value=(c0NodeValue*basis0(internalposition))+(c1NodeValue*basis1(internalposition));

end

