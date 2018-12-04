# MODSIM2-FEM - Burning
CW2 looks at the transient case by modelling the human skin and simulating a burn (i.e. a high heat energy impulse).
The code is based on the static case with some changes. Below are the key graphs that answer the questions.

_Note: CW1 Information is below CW2 in this README. Scroll down!_

## Part 1 - Error Investigation
Using a basic transient case of Laplace, investigate what happens. These graphs show how the solution varies transiently and 
what effect the two methods, Crank-Nicolson and Backwards Euler, has on the solution.

### Backwards Euler
<p align="center">
<img src="status/cw2/part1_time_overview_theta_1_dt_0.001_Linear.png?raw=true"/>
<img src="status/cw2/part1_theta_1_dt_0.001_Linear.png?raw=true"/>
</p>


### Crank-Nicolson
<p align="center">
<img src="status/cw2/part1_time_overview_theta_0.5_dt_0.001_Linear.png?raw=true"/>
<img src="status/cw2/part1_theta_0.5_dt_0.001_Linear.png?raw=true"/>
</p>

## Part 2 - Full Burn Investigation
### No Blood Flow

*393.15K Burn*

<p align="center">
<img src="status/cw2/timeoverview_2a_theta_1_Quad.png?raw=true"/>
<img src="status/cw2/contor2ai_Quad.png?raw=true"/>
</p>

### With Blood Flow

*393.15K Burn*

<p align="center">
<img src="status/cw2/timeoverview_2ci_theta_Quad.png?raw=true"/>
<img src="status/cw2/contor2ci_Quad.png?raw=true"/>
</p>

### Gamma Search with Blood Flow

# MODSIM1-FEM
MODSIM Unit CW 1. Limited result graphs are displayed in this README for this project. This is a [semi object-oriented](https://github.com/jubjamie/MODSIM1-FEM#problem-structure) FEM Solver for 1D problems as specified in the assignment sheet. [Basic Usage as shown below.](https://github.com/jubjamie/MODSIM1-FEM#example-usage)

## Part 2 Parameter Plots
The first contor plot shows how the temperature at a constant x is varied by the change in Q and TL. The second plot shows how the temperature profile changes as TL is increased left to right. Up/down is the material temperature profile. 
<p align="center">
<img src="status/part2a_contor.png?raw=true" width="45%" />
<img src="status/part2a_profile.png?raw=true" width="45%"/>
</p>

## Example Usage

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
This Problem is now solved and can be plotted. Solver plotting options can be set as, otherwise the solver defaults are used.  
```Matlab
plotSolution({part2aProblem}); % Note how the single problem is inside a singluar cell. This is important.
```

That's it, the result will now be displayed. Full information can be access from the Problem structure.


