%% Test 1: Constant Numeric Source Term Element Match
% Test that when a constant numeric value is passed, the resulting
% function returns a vector with 2 identical elements equal to the constant.
% Note this function does not include the jacobian multiplication.
% This would be handled when the global matrix is created.
fFcn=sourceVector(5);
fVector=fFcn(0.1,0.2);
assert(fVector(1)==5,'Element 1 of local source vector is incorrect.');
assert(fVector(2)==5,'Element 1 of local source vector is incorrect.');

%% Test 2: Full test case for complete source vector.
% Build a problem with a constant source term and check against 
% analytical expectation from report derivation.
Test2=[];
Test2.mesh=OneDimLinearMeshGen(0,1,3);
Test2.Diffusion.LE.coef=1;
Test2.Reaction.LE.coef=-9;
Test2.f.coef=5;
%Solve
Test2=FEMSolve(Test2);
J=Test2.mesh.elem(1).J; % J constant for this mesh.
% Expected source vector f
expectedf=[Test2.f.coef*J;...
           2*Test2.f.coef*J;...
           2*Test2.f.coef*J;...
           Test2.f.coef*J;];
       
assert(all(Test2.f.vec==expectedf),'Source term does not match expected value');

%% Test 3: Test polynomial source term local case.
% Test using the Part 2b linear source term to check if the local element
% function returned by sourceVector is correct by completing the symbolic integration
% correctly foa single element.
fFcn=sourceVector('1+(4*x)');
% Expected integration result as per report derivation for part 2b.
expectedFcn=@(x0,x1) [1+((8/3)*x0)+((4/3)*x1);1+((8/3)*x1)+((4/3)*x0);];
% Assert that expected integration matches that from the sourceVector() function.
assert(all(fFcn(2,3)==expectedFcn(2,3)),'Function does not produce expected result.');
