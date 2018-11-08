function [sourceFunction] = sourceVector(symbExp)
%SOURCEVECTOR Creates a custom function for the FEM Solver to construct the correct source vector (excluding Jacobian) 
%   By using either a symbolic expression in x or a constant numeric calue,
%    a source vector is created. This is multiplied out by the Jacobian in the FEMSolver.

%   symbExp - Either a constant numeric value or a symbolic expression in x for the source terms.
%
%   Outputs
%   sourceFunction - Returns a function of x0 and x1 for the FEM Solver to use
%   to calculate the source vector for each node. Pass this as Problem.f.fcn.

if isnumeric(symbExp) % Check if the input is a numeric value.
    symbExp=num2str(symbExp); % If so, set as the expression.
    %This will still result in the correct output.
end

syms z x0 x1 % Define symbolic variables
% Define basis functions symbolically.
basis0=(1-z)/2; 
basis1=(1+z)/2;

x=(x0*basis0)+(x1*basis1); % Define basis representation for x symbolically.

% Generate symbolic equation representing vector element to be inegrated.
Int00=basis0*eval(symbExp);
Int01=basis1*eval(symbExp);

% Integrate the elements as in the report.
sourceint0=matlabFunction(int(Int00,z,[-1,1]),'Vars',[x0 x1]);
sourceint1=matlabFunction(int(Int01,z,[-1,1]),'Vars',[x0 x1]);

% Create & Return an anonymous function that represents the integrated expressions.
sourceFunction=@(x0,x1) [sourceint0(x0,x1) sourceint1(x0,x1)]';
end

