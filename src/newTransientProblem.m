classdef newTransientProblem < handle
    %NEWTRANSIENTPROBLEM Creates a new Transient Problem and methods in a class
    %   Detailed explanation goes here
    
    properties
       mesh;
       BCS;
       Diffusion=struct('Generator',@LaplaceElemMatrix,'coef',0);
       title;
       Reaction=struct('Generator',@ReactionElemMatrix,'coef',0);
       Transient=struct('dt',0.01,'Theta',0.5,'Time',1);
       f=struct('fcn',@(a,b) 1,'coef',0);
       GM;
       GV;
       c;
       Solution;
       c_prev;
       Result;
       BCrhs;
       initParams;
       BatchOptions;
    end
    
    methods
        function obj = Solve(obj,varargin)
            %NEWPROBLEM Construct an instance of this class
            %   Detailed explanation goes here
            if isempty(obj.c)
                ConstantInit(obj,0);
            end
            N=obj.mesh.ngn;
            if isfield(obj.BCS,'D') &&...
                    size(obj.BCS.D,1)>0 && size(obj.BCS.D,2)==2
                for j=1:size(obj.BCS.D,1) % Loop through the Dirichlet BCs.
                    BCd=obj.BCS.D(j,:); % Select the BC for this loop.
        
                    % Corresponding BC Vector node.
                    equivRow=((BCd(2)/(obj.mesh.xmax-obj.mesh.xmin))*(N-1))+1; 
                    % Assert that the x-position represents a node/row number in 
                    % the global matrix
                    assert(~mod(equivRow,1),'D.Boundary condition not specified for a node');
        
                    % Apply the Dirichlet BC mathod to this BC.
                    obj.c(equivRow)=BCd(1); % Set source term/RHS to BC value.
                end
            end
            obj = FEMTransientSolve(obj,varargin);
        end
        function obj = DisplayMesh(obj)
            %NEWPROBLEM Construct an instance of this class
            %   Detailed explanation goes here
            DisplayMesh(obj);
        end
        function obj = Mesh(obj,s,e,num)
            obj.mesh = OneDimLinearMeshGen(s,e,num);
            obj.f.vec = zeros(obj.mesh.ngn,1);
        end
        function obj = ConstantInit(obj,constant)
            assert(~isempty(obj.mesh),'Cannot init without a mesh');
            obj.c = ones(obj.mesh.ngn,1)*constant;
        end
        function fig = PlotAtX(obj, x)
            fig=figure();
            set(fig,'Name','Plot Solution at Xs','NumberTitle','off',...
                'Position', [100 300 700 500]);
            steps=round(obj.Transient.Time/obj.Transient.dt)+1;
            timeseries=linspace(0,obj.Transient.Time,steps);
            N=obj.mesh.ngn;
            for i=1:size(x,2)
                equivRow=((x(i)/(obj.mesh.xmax-obj.mesh.xmin))*(N-1))+1;
                c_values=obj.Solution(equivRow,:);
                plot(timeseries,c_values,'DisplayName',['Numerical Solution - x: ' num2str(x(i))]);
                hold on;
            end
            xlabel('Time (s)');
            ylabel('c(x,t)');
            legend('Location','SouthEast');
        end
        function fig = PlotAtTime(obj, t)
            fig=figure();
            set(fig,'Name','Plot Solution at Times','NumberTitle','off',...
                'Position', [800 300 700 500]);
            for i=1:size(t,2)
                c_values=obj.Solution(:,(t(i)/obj.Transient.dt)+1);
                plot(obj.mesh.nvec,c_values,'DisplayName',[num2str(t(i)) 's']);
                hold on;
            end
            xlabel('Position (x)');
            ylabel('c(x,t)');
            legend('Location','Northwest');
        end

    end
end

