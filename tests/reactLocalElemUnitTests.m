%% Test 1: test symmetry of the matrix
% Test that this matrix is symmetric
tol = 1e-14;
lambda = randi([1,25]); %reaction coefficient??? #todo
eID=randi([1,10]); %element ID
msh = OneDimLinearMeshGen(0,1,10);

elemat = ReactionElemMatrix(lambda,eID,msh);

assert(abs(elemat(1,2) - elemat(2,1)) <= tol)

%% Test 2: test 2 different elements of the same size produce same matrix
% % Test that for two elements of an equispaced mesh, as described in the
% % lectures, the element matrices calculated are the same
tol = 1e-14;
lambda = randi([1,25]); %reaction coefficient??? #todo
eID=randi([1,5]); %element ID
msh = OneDimLinearMeshGen(0,1,10);

elemat1 = ReactionElemMatrix(lambda,eID,msh);%THIS IS THE FUNCTION YOU MUST WRITE

eID=randi([6,10]);%element ID

elemat2 = ReactionElemMatrix(lambda,eID,msh);%THIS IS THE FUNCTION YOU MUST WRITE

diff = elemat1 - elemat2;
diffnorm = sum(sum(diff.*diff));
assert(abs(diffnorm) <= tol)

%% Test 3: test that one matrix is evaluted correctly
% % Test that element 1 of the six element mesh problem described in tutorial sheet 2
% % is evaluated correctly
tol = 1e-14;
lambda = 1; %diffusion coefficient
eID=1; %element ID
msh = OneDimLinearMeshGen(0,1,6);

elemat1 = ReactionElemMatrix(lambda,eID,msh);%THIS IS THE FUNCTION YOU MUST WRITE

elemat2 = [ (1/18) (1/36); (1/36) (1/18)];
diff = elemat1 - elemat2; %calculate the difference between the two matrices
diffnorm = sum(sum(diff.*diff)); %calculates the total squared error between the matrices
assert(abs(diffnorm) <= tol)