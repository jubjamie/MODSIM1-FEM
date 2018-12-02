%% Test 1: test symmetry of the matrix
% Test that this matrix is symmetric
tol = 1e-14;
lambda = randi([1,25]); % reaction coefficient
eID=randi([1,10]); %element ID
msh = OneDimLinearMeshGen(0,1,10);

elemat = ReactionElemMatrix(lambda,eID,msh);

assert(abs(elemat(1,2) - elemat(2,1)) <= tol)

%% Test 2: test 2 different elements of the same size produce same matrix
% % Test that for two elements of an equispaced mesh, as described in the
% % lectures, the element matrices calculated are the same
tol = 1e-14;
lambda = randi([1,25]);
eID=randi([1,5]); %element ID
msh = OneDimLinearMeshGen(0,1,10);

elemat1 = ReactionElemMatrix(lambda,eID,msh);

eID=randi([6,10]);%element ID

elemat2 = ReactionElemMatrix(lambda,eID,msh);

diff = elemat1 - elemat2;
diffnorm = sum(sum(diff.*diff));
assert(abs(diffnorm) <= tol)

%% Test 3: test that one matrix is evaluted correctly
% Test that element 1 of the six element mesh problem described in tutorial sheet 2
% is evaluated correctly
tol = 1e-14;
lambda = 1; %diffusion coefficient
eID=1; %element ID
msh = OneDimLinearMeshGen(0,1,6);

elemat1 = ReactionElemMatrix(lambda,eID,msh);

elemat2 = [ (1/18) (1/36); (1/36) (1/18)];
%calculate the difference between the two matrices
diff = elemat1 - elemat2; 
%calculates the total squared error between the matrices
diffnorm = sum(sum(diff.*diff)); 
assert(abs(diffnorm) <= tol);
%% Test4: Check local elem is the same for different GQn schemes
tol = 1e-14;
D = 1; %diffusion coefficient
eID=2; %element ID
msh = OneDimLinearMeshGen(0,1,3);
elmats={};
for gq=3:5
    elmats{gq-2} = round(ReactionElemMatrix(D,eID,msh,gq),10);
end
assert(isequal(elmats{1},elmats{2},elmats{3}),'Local Elems are different for different GQns');