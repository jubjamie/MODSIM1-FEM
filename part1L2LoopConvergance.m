startSolver;
close all
% Set up parameters values to loop through.
dts=[0.01];
Thetas=[1];
BTs={'Linear'};
Elements=linspace(10,100,11);
evalTimes=[0.5];
L2s=zeros(1,size(dts,2)*size(Thetas,2)*size(BTs,2)*size(Elements,2));
L2LoopConvergance=figure('Position', [800 300 700 500]);
grid on;
for i=1:size(dts,2)
    %Loop through dts
    for j=1:size(Thetas,2)
    % Loop through Theta Schemes
        for k=1:size(BTs,2)
           % Loop through Basis Function Types
           for m=1:size(Elements,2)
              % Loop through element counts.
              % Get interation position number.
              posCounter=((i-1)*size(Thetas,2)*size(BTs,2)*size(Elements,2))+...
                  ((j-1)*size(BTs,2)*size(Elements,2)) +...
                           ((k-1)*size(Elements,2))+m;
               disp(['Solving: Element Counts=' num2str(Elements(m)) ', BT=' BTs{k}...
                    ', Theta=' num2str(Thetas(j)) ', dt=' num2str(dts(i))]);
               solvedProblem=part1Function(Thetas(j),dts(i),BTs{k},Elements(m));
               for n=1:size(evalTimes,2)
                    L2s(n,posCounter)=solvedProblem.L2(@TransientAnalyticSoln,evalTimes(n));
               end

           end
        end
    
    end
end
%Convert L2s to 1-error
L2s(1,:)=1-L2s(1,:);
elementSizes=1./Elements;
plot(log(elementSizes),log(L2s(1,:)));
set(gca, 'XScale', 'log', 'YScale', 'log');
%gradient=
legend();
title('L2 Norm Errors Therough Time with Different Solver Settings');
xlabel('Time (s)');
ylabel('L2 Norm Error');
%saveas(L2LoopConvergance,'status/cw2/L2LoopConvergance_Linear.png');