# MODSIM1-FEM
MODSIM Unit CW 1. Limited result graphs are displayed in this README for this project. This is a semi object oriented FEM Solver for 1D problems as specified in the assignment sheet. Basic Usage as shown below.

## Usage

### Single Problem Mesh Example
This code uses an object based approach meaning you initialise a **Problem** and then solve, plot it etc.

#### Create Problem for Part 2a
The Part 2a Problem is a premade **Problem** template with preset boundaires and material constants as specified. It is a paramterised problem however throughliquid flow rate Q and liquid tempreature TL as well as the mesh size. We will initialise a Problem with Q of value 0.8, TL of 305K and a mesh with 10 elements.

Start the solver software. This will set the correct folders in your paths if you are working in the root of the project. If not, you should recursivley add this project to your path instead of this line.
```Matlab
startSolver; %Set up paths if in project root.
```

Create a new problem using the part2a template and the variables as above. Then send it to the FEM Solver.
```Matlab
part2aProblem = part2a(0.8,305,10); % Create the problem using the part2a template.
part2aProblem = FEMSolve(part2aProblem); % Solve this single problem with the solver.
```
This Problem is now solved and can be plotted. [Solver plotting options can be set as in the docs](#), otherwise the solver defaults are used.  
```Matlab
plotSolution({part2aProblem}); % Note how the single problem is inside a singluar cell. This is important.
```

That's it, the result will now be displayed. Full information can be retrieved from the Problem as per [the docs/](#).
