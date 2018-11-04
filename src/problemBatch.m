function [Batch] = problemBatch(problemTemplate,LB,UB,STEPS)
%PROBLEMBATCH Summary of this function goes here
%   Detailed explanation goes here
assert(size(LB,2)<4,'Variable Parameters for batch processing is limited to 3 to reduce computational load');
assert(size(LB,2)==size(UB,2) && size(LB,2)==size(STEPS,2),'Parameter bounds and step dimensions do not match');
posCounter=0;

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
                posCounter=posCounter+1;
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
            end
            
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
        posCounter=posCounter+1;
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
        
    end
end


end

