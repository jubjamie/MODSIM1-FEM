function [ gq ] = makeGQ(N)
%makeGQ Creates GQ Scheme of order N
%   Creates and initialises a data structure 
    gq.npts = N;
    if (N > 0) && (N < 4)
        %order of quadrature scheme i.e. %number of Gauss points
        gq.gsw = zeros(N,1); %array of Gauss weights
        gq.xipts = zeros(N,1); %array of Gauss points
        switch N
            case 1  
              gq.gsw(1)=2; 
              gq.xipts(1)=0;
            case 2
              gq.gsw=[1,1];  
              gq.xipts=[-sqrt(1/3),sqrt(1/3)];
            case 3
              gq.gsw=[5/9,8/9,5/9];
              gq.xipts=[-sqrt(3/5),0,sqrt(3/5)];
        end
              
    else
      fprintf('Invalid number of Gauss points specified');
    end 
end

