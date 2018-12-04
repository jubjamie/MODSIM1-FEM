function [lambda] = getReactionCoefs(lambda,eID,msh)
%GETREACTIONCOEFS Used to calcualte the required reaction coef so multiply
% by the mass matrix to avoid calculating the reaction matrix twice.
% Matches functionality of first part of @ReactionElemMatrix


x0=msh.elem(eID).x(1);
x1=msh.elem(eID).x(2);

%Logic to check for various reaction coefs
% Coefs should come in as array of pairs.[x,lambda] e.g. [[0,1],[0.5,2]]
% If a single coef is input, just use that.
% The coef at the end will be used for the rest of the mesh
lambdasize=size(lambda,1);
if lambdasize > 1
    lambda(lambdasize+1,:)=[msh.xmax,lambda(lambdasize,2)];
    % Get x position in mesh
    localx=(x0+x1)/2;
    for i=1:lambdasize+1
        % Find region that element is in and use corresponding coef
        if localx<abs(lambda(i+1,1)) && localx>=abs(lambda(i,1))
            lambda=lambda(i,2);
            break;
        end
    end
   
end
end

