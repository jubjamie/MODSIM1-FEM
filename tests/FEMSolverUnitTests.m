%% Test 1: Test output size of result is correct size.
startSolver;

Test1=[];
NumOfElems=4;
%Define problem.
Test1.mesh=OneDimLinearMeshGen(0,1,NumOfElems);
Test1.Diffusion.LE.Generator=@LaplaceElemMatrix;
Test1.Diffusion.LE.coef=2;
Test1.BCS.D=[[5,1];[2,0];];
%Solve
Test1=FEMSolve(Test1);

%Calculate expected result size.
expectedSize=[NumOfElems+1 1];

assert(size(Test1.Result,1)==expectedSize(1),'Solver result vector c not of the expected size for this problem.');
assert(size(Test1.Result,2)==expectedSize(2),'Solver result vector c not of the expected size for this problem.');


%% Test 2: Test for analytical result example from part 1c.
Test2=[];
NumOfElems=4;
%Define problem.
Test2.mesh=OneDimLinearMeshGen(0,1,NumOfElems);
Test2.Diffusion.LE.Generator=@LaplaceElemMatrix;
Test2.Diffusion.LE.coef=1;
Test2.BCS.D=[[0,1];[2,0];];
%Solve
Test2=FEMSolve(Test2);
%Should have analytical solution of c=2(1-x)
expectedResult=2*(1-Test2.mesh.nvec');

assert(all(abs(expectedResult-Test2.Result)<1e-4)==1, 'Solver does not return expected result.');

%% Test 3: Test function works for other case in c/w sheet. #update desc.
Test3.mesh=OneDimLinearMeshGen(0,1,4);
Test3.Diffusion.LE.Generator=@LaplaceElemMatrix;
Test3.Diffusion.LE.coef=1;
Test3.BCS.D=[[0,1];];
Test3.BCS.N=[[2,0];];

Test3=FEMSolve(Test3);
%Expected result is that the boundary is satisfied at x=1 (final node). 
%No source term and diffusion coef of 1 means linear response expected.
%With gradient of 2 at x=0 then expecting straight line y=2x-2
expectedResult=(2*Test3.mesh.nvec)'-2;

assert(all(abs(expectedResult-Test3.Result)<1e-4)==1, 'Solver does not return expected result.');

%% Test 4: Test for global matrix symmetry inside of boundaries.
Test4=[];
%Define problem.
Test4.mesh=OneDimLinearMeshGen(0,1,8);
Test4.Diffusion.LE.Generator=@LaplaceElemMatrix;
Test4.Diffusion.LE.coef=2;
Test4.Reaction.LE.Generator=@ReactionElemMatrix;
Test4.Reaction.LE.coef=-5;
Test4.BCS.D=[[0,1];];
Test4.BCS.N=[[2,0];];
%Solve
Test4=FEMSolve(Test4);

assert(issymmetric(Test4.M(2:end-1,2:end-1)),'Global Matrix is not symmetric within the boundaries.');

%% Test 5: Test that solver returns all numeric, finite elements for large matricies iwth large BCs (i.e. no NaNs or infs).
Test5=[];
%Define problem.
Test5.mesh=OneDimLinearMeshGen(0,1,100);
Test5.Diffusion.LE.Generator=@LaplaceElemMatrix;
Test5.Diffusion.LE.coef=200;
Test5.Reaction.LE.Generator=@ReactionElemMatrix;
Test5.Reaction.LE.coef=-50;
Test5.BCS.D=[[1e6,0];];
Test5.BCS.N=[[1000,1];];
%Solve
Test5=FEMSolve(Test5);

assert(all(all(isfinite(Test5.M)))==1,'Non-finite elemnts in Global Matrix.');
assert(all(all(isfinite(Test5.Result)))==1,'Non-finite elemnts in Result Vector.');
assert(all(all(isfinite(Test5.f)))==1,'Non-finite elemnts in Source Vector.');

%% Test 6: Test accuracy of reaction term calculations using part 1d analytical example.
Test6=[];
Test6.mesh=OneDimLinearMeshGen(0,1,100);
Test6.Diffusion.LE.Generator=@LaplaceElemMatrix;
Test6.Reaction.LE.Generator=@ReactionElemMatrix;
Test6.Diffusion.LE.coef=1;
Test6.Reaction.LE.coef=-9;
Test6.f.coef=0;
Test6.BCS.D=[[0,0];[1,1];];
%Solve
Test6=FEMSolve(Test6);

%Expected result of this is (e^3/(e^6-1))*(e^3x - e^-3x)
xvals=Test6.mesh.nvec';
expectedResult=(exp(3)/(exp(6)-1)*(exp(3*xvals)-exp(-3*xvals)));

assert(all(abs(expectedResult-Test6.Result)<1e-4)==1, 'Solver does not return expected result within the required tolerance.');

%% Test 7: Check Dirichlet boundary conditions are met.
Test7=[];
Test7.mesh=OneDimLinearMeshGen(0,1,100);
Test7.Diffusion.LE.Generator=@LaplaceElemMatrix;
Test7.Reaction.LE.Generator=@ReactionElemMatrix;
Test7.Diffusion.LE.coef=1;
Test7.Reaction.LE.coef=-9;
Test7.f.coef=0;
Test7.BCS.D=[[0,0];[1,1];];
%Solve
Test7=FEMSolve(Test7);

assert(abs(Test7.Result(1))<1e5,'First global node does not match the set boundary condition.');
assert(abs(Test7.Result(end)-1)<1e5,'Final global node does not match the set boundary condition.');