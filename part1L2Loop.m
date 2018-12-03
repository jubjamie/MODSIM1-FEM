startSolver;
close all
% Set up parameters values to loop through.
dts=[0.01,0.001];
Thetas=[0.5,1];
BTs={'Linear','Quad'};
Elements=[10];
evalTimes=linspace(0.1,1,10);
L2s=zeros(10,size(dts,2)*size(Thetas,2)*size(BTs,2)*size(Elements,2));
L2Loop=figure('Position', [800 300 700 500]);
hold on;
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
               if strcmp(BTs{k},'Quad')
                   ls='--';
               else
                   ls='-';
               end
               plot(evalTimes,L2s(:,posCounter),ls,'DisplayName',['Elements=' num2str(Elements(m)) ', BT=' BTs{k}...
                    ', Theta=' num2str(Thetas(j)) ', dt=' num2str(dts(i))]);
           end
        end
    
    end
end
legend();
title('L2 Norm Errors Therough Time with Different Solver Settings');
saveas(L2Loop,'status/cw2/L2Loop.png');xlabel('Time (s)');
ylabel('L2 Norm Error');
