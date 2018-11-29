startSolver;

close all;
Skin=Skin();
performanceCounter=0;
steps=[10,2,0.5];
dts=[0.1,0.05,0.005];
tempBounds=[313.15,393.15];

tic; % Star timing search

for k=1:size(steps,2)
    fprintf(['#########\nSearching ' num2str(tempBounds(1)) 'K - '... 
        num2str(tempBounds(2)) 'K\n#########\n']);
    temps=[tempBounds(1):steps(k):tempBounds(2)];
    gammas=zeros(1,size(temps,2));
    parfor i=1:size(temps,2)
        performanceCounter=performanceCounter+1;
        P2=newTransientProblem();
        P2.Mesh(0,0.01,100);
        
        %Set coefficients based on Skin
        P2.Diffusion.coef=[[0,Skin.E.TC];[Skin.E.xend,Skin.D.TC];[Skin.D.xend,Skin.B.TC]];
        P2.Reaction.coef=-[[0,Skin.E.HS];[Skin.E.xend,Skin.D.HS];[Skin.D.xend,Skin.B.HS]];
        P2.f.coef=[[0,Skin.E.HS];[Skin.E.xend,Skin.D.HS];[Skin.D.xend,Skin.B.HS]];
        disp(temps(i));
        
        P2.Transient.Time=50;
        P2.Transient.Theta=1;
        P2.Transient.dt=dts(k);
        P2.ConstantInit(310.15);
        P2.BCS.D=[[temps(i),0];[310.15,0.01];];
        P2.Solve(false);
        gammas(i)=calculateBurn(P2);
        
    end
    tempBounds(1)=temps(find(gammas<=1,1,'last'));
    tempBounds(2)=temps(find(gammas>1,1,'first'));
end

runtimer=toc; % Stop timing core code
disp(['Search Completed in ' num2str(runtimer) ' seconds']);

fprintf(['\nRequired Temperature Difference: ' num2str(393.15-tempBounds(1)) 'K\nContact Temperature: ' num2str(tempBounds(1)) 'K\n']);



