%% Test 1: Use GQ to get linear source out.
t=newTransientProblem();
t.Mesh(0,1,3);
t.mesh.basisType='Linear';
elmats={};
for gq=3:5
    sourceVec=round(variableStaticSourceVector(1,2,t.mesh,gq),10);
    assert(sourceVec(1)==sourceVec(2),'source vec elements not equal');
    assert(size(sourceVec,1)==2,'Wrong size for linear type');
    assert(abs(sourceVec(1)-t.mesh.elem(2).J)<1e-10,'Wrong output for sourceVec');
    elmats{gq-2}=sourceVec;
end
assert(isequal(elmats{1},elmats{2},elmats{3}),'Local Elems are different for different GQns');