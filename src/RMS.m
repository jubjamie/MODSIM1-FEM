function [Problem] = RMS(Problem)
%RMS Takes a problem and calculates the RMS L2 Norm
%   Problem - Valid Problem
%
%   Outputs
%   Problem - With Problem.RMS attached with RMS value for the Problem.
NumOfElems=Problem.mesh.ne;
errorInts=zeros(1,NumOfElems);
basis0=@(z) (1-z)/2;
basis1=@(z) (1+z)/2;
z=[-(1/3)^0.5 (1/3)^0.5];

for i=1:NumOfElems
    term1=((Problem.mesh.nvec(i)*basis0(z(1))+Problem.mesh.nvec(i+1)*basis1(z(1)))+(Problem.Result(i)*basis0(z(1))+Problem.Result(i+1)*basis1(z(1))))^2;
    term2=((Problem.mesh.nvec(i)*basis0(z(2))+Problem.mesh.nvec(i+1)*basis1(z(2)))+(Problem.Result(i)*basis0(z(2))+Problem.Result(i+1)*basis1(z(2))))^2;
    errorInts(i)=term1+term2;
end
Problem.RMS=sum(errorInts); %Does this need square rooting?

end

