classdef newTransientProblem < handle
    %NEWTRANSIENTPROBLEM Creates a new Transient Problem and methods in a class
    %   Detailed explanation goes here
    
    properties
       mesh;
       BCS;
       Diffusion=struct('Generator',@LaplaceElemMatrix,'coef',0);
       title;
       Reaction=struct('Generator',@ReactionElemMatrix,'coef',0);
       Transient=struct('dt',0.01,'Theta',1,'Time',1);
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
       basisType='Quad';
       GQn=3;
       constantInitVal=0;
       GQ;
    end
    
    methods
        function obj = Solve(obj,varargin)
            %NEWPROBLEM Construct an instance of this class
            %   Detailed explanation goes here
            obj.mesh.basisType=obj.basisType;
            ConstantInitDo(obj,obj.constantInitVal);
            obj.GQ=makeGQ(obj.GQn);
            
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
            
            % Perform set up for quad or linear stuff
            if strcmp(obj.basisType,'Quad')
            obj.f.vec = zeros((2*obj.mesh.ne)+1,1);
            else
            obj.f.vec = zeros(obj.mesh.ngn,1);    
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
        end
        function obj = ConstantInit(obj,constant)
            obj.constantInitVal=constant;
        end
        function obj = ConstantInitDo(obj,constant)
            assert(~isempty(obj.mesh),'Cannot init without a mesh');
            if strcmp(obj.basisType,'Quad')
            obj.c = ones((2*obj.mesh.ne)+1,1)*constant;
            else
            obj.c = ones(obj.mesh.ngn,1)*constant;    
            end
        end
        function fig = PlotAtX(obj, x)
            fig=figure();
            set(fig,'Name','Plot Solution at Xs','NumberTitle','off',...
                'Position', [100 300 700 500]);
            steps=round(obj.Transient.Time/obj.Transient.dt)+1;
            timeseries=linspace(0,obj.Transient.Time,steps);
            N=obj.mesh.ngn;
            for i=1:size(x,2)
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
            N=obj.mesh.ngn;
            if strcmp(obj.basisType,'Quad')
            equivRow=2*((x/(obj.mesh.xmax-obj.mesh.xmin))*(N-1))+1;
            else
            equivRow=((x/(obj.mesh.xmax-obj.mesh.xmin))*(N-1))+1;
            end
            
            c_values=obj.Solution(equivRow,:);
        end
        function fig = PlotAtTime(obj, t)
            fig=figure();
            set(fig,'Name','Plot Solution at Times','NumberTitle','off',...
                'Position', [800 300 700 500]);
            for i=1:size(t,2)
                c_values=obj.Solution(:,int16((t(i)/obj.Transient.dt)+1));
                if strcmp(obj.basisType,'Quad')
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
            L2NormError=L2Norm(obj,aFcn,Time);
            disp(['L2 Norm: ' num2str(L2NormError)]);
        end

    end
end

