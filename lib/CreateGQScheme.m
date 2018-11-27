function [ gq ] = CreateGQScheme(N)
%CreateGQScheme Creates GQ Scheme of order N
%   Creates and initialises a data structure 
    gq.npts = N;
    if (N > 0) && (N < 4)
        %order of quadrature scheme i.e. %number of Gauss points
        gq.gsw = zeros(N,1); %array of Gauss weights
        gq.xipts = zeros(N,1); %array of Gauss points
        switch N
            case 1  
              gq.gsw(1) = 2; 
              gq.xipts(1) = 0;
            case 2
              %gq.gsw(1) = ;  
              %gq.gsw(2) = ;  
              %gq.xipts(1) = ;
              %gq.xipts(2) = ;
            case 3
        end
              
    else
      fprintf('Invalid number of Gauss points specified');
    end 
end

