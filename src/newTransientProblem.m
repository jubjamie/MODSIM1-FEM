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
        function obj = Solve(obj)
            %NEWPROBLEM Construct an instance of this class
            %   Detailed explanation goes here
            obj = FEMTransientSolve(obj);
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
            assert(~isempty(obj.mesh),'Cannot init without a mesh');
            obj.c = ones(obj.mesh.ngn,1)*constant;
            obj.f.vec = zeros(obj.mesh.ngn,1);
        end
        function obj = PlotAtX(obj, x)
            figure(1);
            steps=round(obj.Transient.Time/obj.Transient.dt)+1;
            timeseries=linspace(0,obj.Transient.Time,steps);
            N=obj.mesh.ngn;
            for i=1:size(x,2)
                equivRow=((x(i)/(obj.mesh.xmax-obj.mesh.xmin))*(N-1))+1;
                c_values=obj.Solution(equivRow,:);
                plot(timeseries,c_values);
                hold on;
            end
            xlabel('Time (s)');
            ylabel('Value');
        end
        function obj = PlotAtTime(obj, t)
            figure(3);
            for i=1:size(t,2)
                c_values=obj.Solution(:,(t(i)/obj.Transient.dt)+1);
                plot(obj.mesh.nvec,c_values,'DisplayName',[num2str(t(i)) 's']);
                hold on;
            end
            xlabel('Position (x)');
            ylabel('Value');
            legend();
        end

    end
end

