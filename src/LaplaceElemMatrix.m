function [localElemMatrix] = LaplaceElemMatrix(D,eID,msh)
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
%Jacobian comes from mesh already calculated.
%dzeta/dx=2/(x1-x0)
dz_dx=2/(x1-x0);

%dpsin/dzeta for 2 basis function calcs n=0,1.
%Reduces to:
dpsi0_dz=-0.5;
dpsi1_dz=0.5;

%Four combinations of integral written as [Int00,Int01;Int10,Int11];
%Int00=IntF(D*dpsi0_dz*dz_dx*dpsi0_dz*dz_dx*J)dz<>[-1,1];-----------\
%Int01=IntF(D*dpsi0_dz*dz_dx*dpsi1_dz*dz_dx*J)dz<>[-1,1]; --\Equiv   \
%Int10=IntF(D*dpsi1_dz*dz_dx*dpsi0_dz*dz_dx*J)dz<>[-1,1]; --/Equiv   / Will be equal (See #report section)
%Int11=IntF(D*dpsi1_dz*dz_dx*dpsi1_dz*dz_dx*J)dz<>[-1,1];-----------/

%Int00=(D*dpsi0_dz*dz_dx*dpsi0_dz*dz_dx*J)*(1-(-1)); %Long Forms of integral solution
%Int01=(D*dpsi0_dz*dz_dx*dpsi1_dz*dz_dx*J)*(1-(-1));

Int00=D/(x1-x0);    % Short forms as derived in #report.
Int01=-D/(x1-x0);

localElemMatrix=[Int00, Int01;Int01, Int00];


end

