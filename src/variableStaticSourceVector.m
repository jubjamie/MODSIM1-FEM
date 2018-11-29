function [sourceLocalElem] = variableStaticSourceVector(sourcecoef,eID,msh)
%SOURCEVECTOR Creates a custom function for the FEM Solver to construct the

J=msh.elem(eID).J;
x0=msh.elem(eID).x(1);
x1=msh.elem(eID).x(2);

scsize=size(sourcecoef,2);
if scsize > 1
    sourcecoef(scsize+1)=[msh.xmax,sourcecoef(end,2)];
    % Get x position in mesh
    localx=(x0+x1)/2;
    for i=1:scsize+1
        if localx<sourcecoef(i+1,1) && localx>=sourcecoef(i,1)
            sourcecoef=sourcecoef(i,2);
            break;
        end
    end
   
end
sourceLocalElem=[sourcecoef*J,sourcecoef*J]';
end

