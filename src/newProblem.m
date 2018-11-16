classdef newProblem < handle
    %NEWPROBLEM Creates a new Problem and methods in a class
    %   Detailed explanation goes here
    
    properties
       mesh;
       BCS;
       Diffusion;
       title;
       Reaction;
       f;
       M;
       c;
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

    end
end

