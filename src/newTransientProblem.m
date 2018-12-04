classdef newTransientProblem < handle
    %NEWTRANSIENTPROBLEM Creates a new Transient Problem and methods in a 
    % class. This allows rapid building of transient problems in a flexible,
    % customisable, extendable way.

    
    properties
       % Set default values and accepted properties.
       mesh; % Holds the mesh
       BCS; % Holds the Boundary Conditions
       % Sets the default diffusion local elem function and coef
       Diffusion=struct('Generator',@LaplaceElemMatrix,'coef',0);
       % Sets the default reaction local elem function and coef
       Reaction=struct('Generator',@ReactionElemMatrix,'coef',0);
       % Sets the default source coef
       f=struct('coef',0);
       % Sets the default transient solver settings
       Transient=struct('dt',0.01,'Theta',1,'Time',1);
       GM; % Global Matrix
       GV; % Global Vector
       c; % Current Solution
       Solution; % Final Solution Matrix
       c_prev; % Previous solution
       Result; % Result placeholder
       BCrhs; % RHS BCs matrix
       initParams; % Batching params
       BatchOptions; % Batching params
       basisType='Quad'; % Default basis function type
       GQn=3; % Default GQ scheme
       constantInitVal=0; % Initial condition before BCs
       GQ; % GQ Object
       title; % Problem title.
    end
    
    methods
        function obj = Solve(obj,varargin)
            % Solve method sends the problem to transient solver.
            % Place basis function type in the mesh
            obj.mesh.basisType=obj.basisType;
            % Set initial conditions at solve time
            ConstantInitDo(obj,obj.constantInitVal);
            % Create GQ scheme as property
            obj.GQ=makeGQ(obj.GQn);
            
            % Set Dirichlet conditions on initial condition
            N=obj.mesh.ngn;
            if isfield(obj.BCS,'D') &&...
                    size(obj.BCS.D,1)>0 && size(obj.BCS.D,2)==2
                for j=1:size(obj.BCS.D,1) % Loop through the Dirichlet BCs.
                    BCd=obj.BCS.D(j,:); % Select the BC for this loop.
        
                    % Corresponding BC Vector node.
                    if strcmp(obj.basisType,'Quad')
                        equivRow=2*((BCd(2)/(obj.mesh.xmax-obj.mesh.xmin))*(N-1))+1;
                    else
                        equivRow=((BCd(2)/(obj.mesh.xmax-obj.mesh.xmin))*(N-1))+1; 
                    end
                    % Assert that the x-position represents a node/row number in 
                    % the global matrix
                    assert(~mod(equivRow,1),'D.Boundary condition not specified for a node');
        
                    % Apply the Dirichlet BC mathod to this BC.
                    obj.c(equivRow)=BCd(1); % Set source term/RHS to BC value.
                end
            end
            
            % Perform set up for quad or linear source vectors
            if strcmp(obj.basisType,'Quad')
            obj.f.vec = zeros((2*obj.mesh.ne)+1,1);
            else
            obj.f.vec = zeros(obj.mesh.ngn,1);    
            end
            
            %Send to solver with optional arg passthru
            obj = FEMTransientSolve(obj,varargin);
        end
        
        function obj = DisplayMesh(obj)
            %Draw the mesh
            DisplayMesh(obj);
        end
        
        function obj = Mesh(obj,s,e,num)
            %Method shorthand to create the mesh.
            obj.mesh = OneDimLinearMeshGen(s,e,num);
        end
        
        function obj = ConstantInit(obj,constant)
            % Set constant initial value
            obj.constantInitVal=constant;
        end
        
        function obj = ConstantInitDo(obj,constant)
            % Apply constant initial value as initial condition
            assert(~isempty(obj.mesh),'Cannot init without a mesh');
            % Size initial condition based on basis function type.
            if strcmp(obj.basisType,'Quad')
                obj.c = ones((2*obj.mesh.ne)+1,1)*constant;
            else
                obj.c = ones(obj.mesh.ngn,1)*constant;
            end
        end
        
        function fig = PlotAtX(obj, x)
            % Plot the solution through time at x values.
            fig=figure();
            set(fig,'Name','Plot Solution at Xs','NumberTitle','off',...
                'Position', [100 300 700 500]);
            % Calculate the steps and time domain
            steps=round(obj.Transient.Time/obj.Transient.dt)+1;
            timeseries=linspace(0,obj.Transient.Time,steps);
            N=obj.mesh.ngn;
            % Loop through each x value.
            for i=1:size(x,2)
                % Calculate position of x in the solution matrix.
                if strcmp(obj.basisType,'Quad')
                    equivRow=2*((x(i)/(obj.mesh.xmax-obj.mesh.xmin))*(N-1))+1;
                else
                    equivRow=((x(i)/(obj.mesh.xmax-obj.mesh.xmin))*(N-1))+1;
                end
                c_values=obj.Solution(equivRow,:);
                plot(timeseries,c_values,'DisplayName',['Numerical Solution - x: ' num2str(x(i))]);
                hold on;
            end
            xlabel('Time (s)');
            ylabel('c(x,t)');
            legend('Location','SouthEast');
            grid on;
        end
        
        function c_values = GetValuesAtX(obj, x)
            % Quick method to get solution at solved point in x-domain
            N=obj.mesh.ngn;
            if strcmp(obj.basisType,'Quad')
            equivRow=2*((x/(obj.mesh.xmax-obj.mesh.xmin))*(N-1))+1;
            else
            equivRow=((x/(obj.mesh.xmax-obj.mesh.xmin))*(N-1))+1;
            end
            
            c_values=obj.Solution(equivRow,:);
        end
        
        function fig = PlotAtTime(obj, t)
            % Plot the solution at certain times across the x-domain
            fig=figure();
            set(fig,'Name','Plot Solution at Times','NumberTitle','off',...
                'Position', [800 300 700 500]);
            % Loop through each time
            for i=1:size(t,2)
                c_values=obj.Solution(:,int16((t(i)/obj.Transient.dt)+1));
                if strcmp(obj.basisType,'Quad')
                    % If quadratic basis, only plot global nodes
                    plot(obj.mesh.nvec,c_values(1:2:end),'DisplayName',[num2str(t(i)) 's']);
                else
                    plot(obj.mesh.nvec,c_values,'DisplayName',[num2str(t(i)) 's']);
                end
                hold on;
            end
            xlabel('Position (x)');
            ylabel('c(x,t)');
            legend('Location','Northeast');
            grid on;
        end
        function L2NormError=L2(obj,aFcn,Time)
            % Return the L2Norm error compared to analytical @aFcn
            L2NormError=L2Norm(obj,aFcn,Time);
            disp(['L2 Norm: ' num2str(L2NormError)]);
        end

    end
end

