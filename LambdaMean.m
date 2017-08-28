function lambdaMeanAll = LambdaMeanFuncNL(CellsArrSp,NspArr)
lambda_all =[];
% alpha=2;
for n=NspArr
%     idxNL = [];
%     idxNL = [CellsArrSp{n}.Flagln];
%     lambdan = [CellsArrSp{n}.lambda];
%     idxMul = ones(1,length(lambdan));
%     idxMul(find(idxNL))=alpha;
%     lambdanEff = idxMul.*lambdan;
%     lambda_all = [ lambda_all , lambdanEff];
    lambda_all = [ lambda_all , CellsArrSp{n}.lambda];
end
lambdaMeanAll = mean(lambda_all);
end