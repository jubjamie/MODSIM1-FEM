function [Problem] = FEMTransientSolve(Problem)
%FEMSOLVE Takes a Problem object and solves it by building a Global Matrix.
% Problem must be a valid Problem.
progressbar('Solving Time Steps');
steps=round(Problem.Transient.Time/Problem.Transient.dt);
transientsolution=zeros(Problem.mesh.ngn,steps+1);
transientsolution(:,1)=Problem.c;
figure(5);
hold off;
dim = [.5 .5 .3 .3];
plottimer=annotation('textbox',dim,'String','','FitBoxToText','on','horizontalAlignment', 'right','LineStyle','none');
for i=2:steps+1
    progressbar(i/steps);
    [GM,GV,Problem]=globalMatrixTransient(Problem); % Construct global matrix and other vectors.
    Problem.c=GM\GV; % Solve system of matrices for c (results vector for global nodes.)
    Problem.Result=Problem.c; % Copy to results field (more understandable name.)
    transientsolution(:,i)=Problem.c;
    if mod(i,10)==0
        figure(5);
        plot(Problem.mesh.nvec,Problem.Result');
        set(plottimer,'String',[num2str(i*Problem.Transient.dt) 's'])
    end
end
Problem.Solution=transientsolution;
progressbar(1);
end

