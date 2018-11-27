classdef newTransientProblem < handle
    %NEWTRANSIENTPROBLEM Creates a new Transient Problem and methods in a class
    %   Detailed explanation goes here
    
    properties
       mesh;
       BCS;
       Diffusion=struct('Generator',@LaplaceElemMatrix,'coef',0);
       title;
       Reaction=struct('Generator',@ReactionElemMatrix,'coef',0);
       Transient=struct('dt',0.01,'Theta',0.5);
       f=struct('fcn',@(a,b) 1,'coef',0);
       GM;
       GV;
       c;
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
            obj = FEMSolve(obj);
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
            obj.c = ones(1, obj.mesh.ngn)*constant;
        end

    end
end

