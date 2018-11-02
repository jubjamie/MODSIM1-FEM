function [localElemMatrix] = ReactionElemMatrix(lambda,eID,msh)
%LAPLACEELEMMATRIX Summary of this function goes here
%   Detailed explanation goes here
% Local element properties within mesh can accessed as follows:
%   Pos-x0: msh.elem(eID).x(1);   GlobalNodeID-x0: msh.elem(eID).n(1);
%   Pos-x1: msh.elem(eID).x(2);   GlobalNodeID-x1: msh.elem(eID).n(2);
%   Element Jacobian: msh.elem(eID).J;

%Convert element info to convinienet variable names.
x0=msh.elem(eID).x(1);
x0N=msh.elem(eID).n(1);
x1=msh.elem(eID).x(2);
x1N=msh.elem(eID).n(2);
J=msh.elem(eID).J;

%Display element info in table
%array2table([msh.elem(eID).x(1),msh.elem(eID).n(1),msh.elem(eID).x(2),msh.elem(eID).n(2),msh.elem(eID).J],'VariableNames',{'Pos_x0', 'Global_nID_x0','Pos_x1','Global_nID_x1','J'})

%% Start constructing the loacl elem matrix.
%For element x0 -> x1
%Jacobian (J) comes from mesh already calculated.
%Linear Reaction Operator of the form Int(lambda*c*v*J)dz<>[-1,1]
%c=cn*psin
%v=psim
%m,n=0,1 with psi as the usual basis functions
%Write function as cn*Int(lambda*psin*psim*J)dz<>[-1,1] but want to make local elem matrix
%Int00=Int(lambda*psi0*psi0*J)dz<>[-1,1];-----------\
%Int01=Int(lambda*psi0*psi1*J)dz<>[-1,1]; --\Equiv   \
%Int10=Int(lambda*psi1*psi0*J)dz<>[-1,1]; --/Equiv   / Will be equal (See #report section)
%Int10=Int(lambda*psi1*psi1*J)dz<>[-1,1];-----------/
Int00=(2/3)*lambda*J;
Int01=(1/3)*lambda*J;

localElemMatrix=[Int00, Int01;Int01, Int00];


end

