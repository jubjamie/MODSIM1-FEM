
%Loop through element resolutions
meshRes=5:5:100;
N=size(meshRes,2);
h=zeros(1,N);
L2Error=zeros(1,N);
for i=1:N
    
    P=newTransientProblem();
    P.Mesh(0,1,meshRes(i));
    h(i)=P.mesh.dx;
    P.Diffusion.coef=1;
    P.Transient.dt=0.01;
    P.BCS.D=[[0,0];[1,1];];
    P.Solve();
    L2Error(i)=P.L2(@TransientAnalyticSoln,1);
    
end
figure();
plot(log(h),log(L2Error));