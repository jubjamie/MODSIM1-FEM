function [sourceFunction] = sourceVector(symbExp)
%SOURCEVECTOR Creates a custom function for the FEM Solver to construct the correct source vector (excluding Jacobian) 
%   By using either a symbolic expression in x or a constant numeric calue, a source vector is created. This is multiplied out by the Jacobian in the FEMSolver.
%   symbExp - Either a constant numeric value or a symbolic expression in x for the source terms.
%
%   Outputs
%   sourceFunction - Returns a function of x0 and x1 for the FEM Solver to use to calculate the source vector for each node.
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

