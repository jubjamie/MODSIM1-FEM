%%Test 1: Test output size of result is correct size.
startSolver;

Test1=[];
NumOfElems=4;
%Define problem.
Test1.mesh=OneDimLinearMeshGen(0,1,NumOfElems);
Test1.Diffusion.LE.Generator=@LaplaceElemMatrix;
Test1.Diffusion.LE.coef=1;
Test1.BCS.D=[[0,1];[2,0];];
%Solve
Test1=FEMSolve(Test1);

%Calculate expected result size.
expectedSize=[NumOfElems+1 1];

assert(size(Test1.Result,1)==expectedSize(1),'Solver result vector c not of the expected size for this problem.');
assert(size(Test1.Result,2)==expectedSize(2),'Solver result vector c not of the expected size for this problem.');


