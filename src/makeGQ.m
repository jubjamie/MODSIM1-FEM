function [ gq ] = makeGQ(N)
%makeGQ Creates GQ Scheme of order N
%   Creates and initialises a data structure 
    gq.npts = N;
    if (N > 0) && (N < 6)
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
            case 4
              gq.gsw=[(18+sqrt(30))/36,(18+sqrt(30))/36,...
                  (18-sqrt(30))/36,(18-sqrt(30))/36];
              gq.xipts=[sqrt((3/7)-((2/7)*sqrt(6/5))),...
                  -sqrt((3/7)-((2/7)*sqrt(6/5))),...
                  sqrt((3/7)+((2/7)*sqrt(6/5))),-sqrt((3/7)+((2/7)*sqrt(6/5)))];
            case 5
              gq.gsw=[(322+(13*sqrt(70)))/900,(322+(13*sqrt(70)))/900,...
                  (322-(13*sqrt(70)))/900,(322-(13*sqrt(70)))/900,128/225];
              gq.xipts=[(1/3)*sqrt(5-(2*sqrt(10/7))),...
                  -(1/3)*sqrt(5-(2*sqrt(10/7))),...
                  (1/3)*sqrt(5+(2*sqrt(10/7))),-(1/3)*sqrt(5+(2*sqrt(10/7))),0];
        end
              
    else
      fprintf('Invalid number of Gauss points specified');
    end 
end

