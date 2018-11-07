function [Batch] = problemBatch(problemTemplate,LB,UB,STEPS)
%PROBLEMBATCH Using a problem template, iterate through a range of parameter values to create a Batch of Problems.
%   A problem template can be created that takes in various parameters, perhaps to do with varying mesh resolution or diffusion/reaction coefficients.
%   (problemTemplate,LB,UB,STEPS)
%   problemTemplate - A function that takes in the inputs that will be iterated in in the form of @problemTemplate(a,b,c); Must return a Problem ready to be solved.
%   LB - The lower bounds for each term, in order of entry to the problemTemplate e.g. [lowera, lowerb, lowerc]
%   UB - The upper bounds for each term, in order of entry to the problemTemplate e.g. [uppera, upperb, upperc]
%   STEPS - The number of steps to do for each term, in order of entry to the problemTemplate e.g [5, 5, 5] gives 125 Problem combinations.
%
%   Outputs
%   Batch - A Batch of Problems as a cell array with extra information on the Batch settings attached to the Problems and additional info attached to the first Problem (i.e. Batch{1}).

assert(size(LB,2)<4,'Variable Parameters for batch processing is limited to 3 to reduce computational load');
assert(size(LB,2)==size(UB,2) && size(LB,2)==size(STEPS,2),'Parameter bounds and step dimensions do not match');
totalNodes=0;

if size(LB,2)==3
    %Calculate size of each parameter space
    paramSize=STEPS;
    assert(min(STEPS)>0,'Steps must be at least 0');
    %assert(~mod(paramSize,1),'Step size is not a divisor of bound space.');
    batchSize=prod(STEPS);
    Batch=cell(1,batchSize);
    tDelta=zeros(1,3);
    assert(all(~mod(STEPS,1)),'Non-integer number of steps.');
    for u=1:3
        if(STEPS(u)>1)
            tDelta(u)=(UB(u)-LB(u))./(STEPS(u)-1);
        elseif(STEPS(u)==1)
            tDelta(u)=0;
        else
            error('Negative step not allowed');
        end
    end
    %Create 3 nested loops
    for i=1:paramSize(1)
        %For first param
        for j=1:paramSize(2)
            %For second param
            for k=1:paramSize(3)
                posCounter=((i-1)*(paramSize(2)*paramSize(3)))+((j-1)*paramSize(3))+k;
                term1=LB(1)+((i-1)*tDelta(1));
                term2=LB(2)+((j-1)*tDelta(2));
                term3=LB(3)+((k-1)*tDelta(3));
                disp(['Making Problem with params>> Arg1:' num2str(term1) ' Arg2:' num2str(term2) ' Arg3:' num2str(term3)]);
                if k==paramSize(3)
                    assert(term3==UB(3),'Boundary Step Error ARG 3. Final terms not equal to UB.');
                end
                Batch{posCounter}=problemTemplate(term1,term2,term3);
                Batch{posCounter}.initParams=[term1 term2 term3];
                Batch{posCounter}.BatchOptions.template=problemTemplate;
                Batch{posCounter}.BatchOptions.LB=LB;
                Batch{posCounter}.BatchOptions.UB=UB;
                Batch{posCounter}.BatchOptions.STEPS=STEPS;
                Batch{posCounter}.BatchOptions.BatchSize=batchSize;
                totalNodes=totalNodes+Batch{posCounter}.mesh.ngn;

            end
            
        end
    end
    
elseif size(LB,2)==2
    %Calculate size of each parameter space
    paramSize=STEPS;
    assert(min(STEPS)>0,'Steps must be at least 0');
    %assert(~mod(paramSize,1),'Step size is not a divisor of bound space.');
    batchSize=prod(STEPS);
    Batch=cell(1,batchSize);
    tDelta=zeros(1,2);
    assert(all(~mod(STEPS,1)),'Non-integer number of steps.');
    for u=1:2
        if(STEPS(u)>1)
            tDelta(u)=(UB(u)-LB(u))./(STEPS(u)-1);
        elseif(STEPS(u)==1)
            tDelta(u)=0;
        else
            error('Negative step not allowed');
        end
    end
    %Create 3 nested loops

        %For first param
        for j=1:paramSize(1)
            %For second param
            for k=1:paramSize(2)
                posCounter=+((j-1)*paramSize(2))+k;
                term1=LB(1)+((j-1)*tDelta(1));
                term2=LB(2)+((k-1)*tDelta(2));
                disp(['Making Problem with params>> Arg1:' num2str(term1) ' Arg2:' num2str(term2)]);
                if k==paramSize(2)
                    assert(term2==UB(2),'Boundary Step Error ARG 2. Final terms not equal to UB.');
                end
                Batch{posCounter}=problemTemplate(term1,term2);
                Batch{posCounter}.initParams=[term1 term2];
                Batch{posCounter}.BatchOptions.template=problemTemplate;
                Batch{posCounter}.BatchOptions.LB=LB;
                Batch{posCounter}.BatchOptions.UB=UB;
                Batch{posCounter}.BatchOptions.STEPS=STEPS;
                Batch{posCounter}.BatchOptions.BatchSize=batchSize;
                totalNodes=totalNodes+Batch{posCounter}.mesh.ngn;

            end
            
        end
    
    
elseif size(LB,2)==1
    paramSize=STEPS;
    assert(min(STEPS)>0,'Steps must be at least 0');
    %assert(~mod(paramSize,1),'Step size is not a divisor of bound space.');
    batchSize=prod(STEPS);
    Batch=cell(1,batchSize);
    tDelta=0;
    assert(~mod(STEPS(1),1),'Non-integer number of steps.');
        if(STEPS(1)>1)
            tDelta=(UB(1)-LB(1))./(STEPS(1)-1);
        elseif(STEPS(1)==1)
            tDelta=0;
        else
            error('Negative step not allowed');
        end

    for k=1:paramSize(1)
        posCounter=k;
        term1=LB(1)+((k-1)*tDelta);
        disp(['Making Problem with params>> Arg1:' num2str(term1)]);
        if k==paramSize(1)
            assert(term1==UB(1),'Boundary Step Error ARG 1. Final terms not equal to UB.');
        end
        Batch{posCounter}=problemTemplate(term1);
        Batch{posCounter}.initParams=[term1];
        Batch{posCounter}.BatchOptions.template=problemTemplate;
        Batch{posCounter}.BatchOptions.LB=LB;
        Batch{posCounter}.BatchOptions.UB=UB;
        Batch{posCounter}.BatchOptions.STEPS=STEPS;
        Batch{posCounter}.BatchOptions.BatchSize=batchSize;
        totalNodes=totalNodes+Batch{posCounter}.mesh.ngn;
        
    end
end

%Add total node info to each BatchOptions entry,
Batch{1}.BatchOptions.TotalNodes=totalNodes;
end

