%Bare bones example for report.
startSolver;

P=newTransientProblem(); % Define new problem and set up default solver.
P.Mesh(0,1,10); % Make a 10 element mesh.
P.Diffusion.coef=1; % Define the diffusion coefficient
P.BCS.D=[[0,0];[1,1];]; % Set Dirichlet Boundary Conditions

% Send to default solver. Automatically creates plot showing solutions being
% calculated. Also generates a progress bar to show calculation progress
% and give the user time remaining for larger problems.
P.Solve();

P.PlotAtTime([0.05,0.1,0.3,1]); % Plot the solutions at the specified times.