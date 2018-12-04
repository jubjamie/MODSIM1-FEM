part2a;
part2ci;
t=[0.05,0.5,2,5,50];
markerColors=[[0,0.45,0.74]; [0.85, 0.33, 0.1]; [0.93, 0.69, 0.13]; [0.49, 0.18, 0.56]; [0.47, 0.67, 0.19];];
compFig=figure();
            set(compFig,'Name','Plot Solution at Times','NumberTitle','off',...
                'Position', [600 300 700 500]);
            for i=1:size(t,2)
                c_values=P2.Solution(:,int16((t(i)/P2.Transient.dt)+1));
                if strcmp(P2.basisType,'Quad')
                plot(P2.mesh.nvec,c_values(1:2:end),'Color',markerColors(i,:),'LineStyle','--','DisplayName',['No Blood Flow: ' num2str(t(i)) 's']);
                else
                plot(P2.mesh.nvec,c_values,'Color',markerColors(i,:),'LineStyle','--','DisplayName',['No Blood Flow: ' num2str(t(i)) 's']);    
                end
                hold on;
            end
            for i=1:size(t,2)
                c_values=P2C.Solution(:,int16((t(i)/P2C.Transient.dt)+1));
                if strcmp(P2C.basisType,'Quad')
                plot(P2C.mesh.nvec,c_values(1:2:end),'Color',markerColors(i,:),'LineStyle','-','DisplayName',['Blood Flow: ' num2str(t(i)) 's']);
                else
                plot(P2C.mesh.nvec,c_values,'Color',markerColors(i,:),'LineStyle','-','DisplayName',['Blood Flow: ' num2str(t(i)) 's']);    
                end
                hold on;
            end
plotSkin;
grid on;
xlabel('Position (x)');
ylabel('c(x,t)');
legend('Location','Northeast');
title(['Transient Solution Comparison - Theta: ' num2str(P2.Transient.Theta) ', dt: ' num2str(P2.Transient.dt) ' Using ' P2.basisType ' Basis Functions']);
disp('Adjust legend accordingly and save in figure.');