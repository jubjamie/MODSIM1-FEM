% Optimise temperature reduction to prevent 2nd-degree burns to nearest 0.5K
% Uses paralell processing workers to search space.

startSolver;

close all;

% Load in skin object.
Skin=Skin();
% Choose temperature step sizes that give solution to 0.5 resolution
steps=[10,2,0.5];
% Choose timesteps to use for each loop. Bigger timesteps early on to help
% solution narrow down quickly when searching wide space.
dts=[0.1,0.05,0.005];
% Initial search boundary
tempBounds=[323.15,393.15];

markerSpecs={'gx','bx','mx','yx'}; % Marker specs to give matching colors in plot
tic; % Star timing search

%Create gamma search figure.
gammaSearch=figure(10);
hold on;
grid on;

for k=1:size(steps,2)
    % Loop through search attempts
    fprintf(['#########\nSearching ' num2str(tempBounds(1)) 'K - '... 
        num2str(tempBounds(2)) 'K\n#########\n']);
    % Create temps to send to workers
    temps=[tempBounds(1):steps(k):tempBounds(2)];
    % Pre-allocate gamma array for workers to populate.
    gammas=zeros(1,size(temps,2));
    parfor i=1:size(temps,2)
        % Use paralell processing workers to solve problems concurrently
        %Build and solve problem
        performanceCounter=performanceCounter+1;
        P2=newTransientProblem();
        P2.Mesh(0,0.01,100);
        
        %Set coefficients based on Skin
        P2.Diffusion.coef=[[0,Skin.E.TC];[Skin.E.xend,Skin.D.TC];[Skin.D.xend,Skin.B.TC]];
        P2.Reaction.coef=-[[0,Skin.E.HS];[Skin.E.xend,Skin.D.HS];[Skin.D.xend,Skin.B.HS]];
        P2.f.coef=[[0,Skin.E.HS];[Skin.E.xend,Skin.D.HS*Skin.D.Tb];[Skin.D.xend,Skin.B.HS*Skin.B.Tb]];
        disp(temps(i));
        
        P2.Transient.Time=50;
        P2.Transient.Theta=1;
        P2.Transient.dt=dts(k);
        P2.ConstantInit(310.15);
        P2.BCS.D=[[temps(i),0];[310.15,0.01];];
        P2.Solve(false);
        
        % Populate gamma vector for this search session
        gammas(i)=calculateBurn(P2);
        
    end
    
    % Find the temperatures that are on either side of gamma=1 boundary.
    % Set as next boundaries for next search session.
    tempBounds(1)=temps(find(gammas<=1,1,'last'));
    tempBounds(2)=temps(find(gammas>1,1,'first'));
    
    % Plot the log10(gamma) to show searching.
    if k<size(steps,2)
        plot(tempBounds(1),log10(gammas(find(gammas<=1,1,'last'))),markerSpecs{k});
        plot(tempBounds(2),log10(gammas(find(gammas>1,1,'first'))),markerSpecs{k});
    else
       plot(tempBounds(1),log10(gammas(find(gammas<=1,1,'last'))),'ro');
       plot(tempBounds(2),log10(gammas(find(gammas>1,1,'first'))),'rx');
    end
    
end

runtimer=toc; % Stop timing core code

% Plot gamma search graph
hline(0,'k--');
xlabel('Burn Temperature (K)');
ylabel('Log10(Gamma)');
title('Gamma Search for Temperature Reduction');
saveas(gammaSearch,'status/cw2/gammaSearch_2cii.png');


disp(['Search Completed in ' num2str(runtimer) ' seconds']);

fprintf(['\nRequired Temperature Difference: ' num2str(393.15-tempBounds(1)) 'K\nContact Temperature: ' num2str(tempBounds(1)) 'K\n']);
fprintf(['Gamma: ' num2str(gammas(find(gammas<=1,1,'last')))]);


