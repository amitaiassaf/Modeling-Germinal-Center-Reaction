dt=0.01;
lambda = 1.5;
mu = 1;
Diff = 0.01;
runNum = 1;
Nsp = 50;
Tg = 6;  % Growth phase duration
Tc = 16; % Competitive phase duration
Nmax = 500;
FlagDeathStop = 0;
% Jackpotflag = 0;
% JPThreshold = 1.5;
clear AncArr;
clear bcArr;
clear cellnumGrowth;
clear cellnumSel;

cellnumGrowth = zeros(runNum,Nsp);
cellnumSel = zeros(runNum,Nsp);
TArr = cell(runNum,1);
NonLinFlagArr = zeros(runNum,Nsp);

LambdaTrack={};
lambdaSim = {};
PopulationTrack={};

lambda
Diff
mu
runNum
Nsp
Nmax
Tg
Tc

for k = 1:runNum
    k
    lambdaPop = {};
    NspArr = [1:1:Nsp];
    exitFlag = 0;
    FlagFirst = 0;
    
    clear CellsArrSp;
    
    for n=1:Nsp
        bcArr(n) = Bcell(lambda,mu,Diff,dt,Nmax,lambda);
        CellsArrSp{n} = bcArr(n);
    end
    
    MuFlag = 0;
    
    cellNumDyn = zeros(2); C = 1;
    for t=0:dt:Tg
        t;
        Ntot = 0;
        for n=1:Nsp
            Ntot = Ntot + length(CellsArrSp{n});
        end
        exitFlag = 0;
        lambdaMeanAll = LambdaMean(CellsArrSp,NspArr);
        
        for n=NspArr
            CellsArrSp{n} = BD_step(CellsArrSp{n},lambdaMeanAll,MuFlag,Ntot);
            
            if(length(CellsArrSp{n})==0)
                NspArr = NspArr(find(NspArr ~= n));
                if(FlagDeathStop)
                    exitFlag = 1;
                    break;
                else
                    Atemp = TArr{k};
                    Atemp = [Atemp , t];
                    TArr{k} = Atemp;
                end
                if(length(NspArr)==0)
                    exitFlag = 1;
                    break;
                end
            end
        end
        
        for n=NspArr
            cellNumDyn(C,n) = length(CellsArrSp{n});
        end
        
        C = C + 1;
        
        if(exitFlag)
            break;
        end
    end
    
    PopulationTrack{k,1}=single(cellNumDyn);
    
    for n=NspArr
        cellnumGrowth(k,n) = length(CellsArrSp{n});
    end
    
    %%%%%%%%%%%
    %%%%%%%%%%%
    
    if(length(NspArr)==0)
        continue;
    end
    
    %%%%%%%%%%%
    %%%%%%%%%%%
    MuFlag = 1;
    cellNumDyn = zeros(2); C = 1;
    for t=0:dt:Tc
        Ntot = 0;
        for n=1:Nsp
            Ntot = Ntot + length(CellsArrSp{n});
        end
        
        lambdaMeanAll = LambdaMean(CellsArrSp,NspArr);
        exitFlag = 0;
        
        for n=NspArr
            CellsArrSp{n} = BD_step(CellsArrSp{n},lambdaMeanAll,MuFlag,Ntot);
            if(length(CellsArrSp{n})==0)
                NspArr = NspArr(find(NspArr ~= n));
                exitFlag = 1;
            end
        end
        
        %%%%%
        
        for n=NspArr
            lambdaPop{C,n} = single([CellsArrSp{n}.lambda]);
        end
        
        for n=NspArr
            cellNumDyn(C,n) = length(CellsArrSp{n});
        end
        
        %%%%%
        C = C+1;
        
        if(exitFlag)
            if(length(TArr{k})==0)
                TArr{k} = Tg+t;
                if(FlagDeathStop)
                    break;
                end
            else
                Atemp = TArr{k};
                Atemp = [Atemp , Tg+t];
                TArr{k} = Atemp;
            end
            if(length(NspArr)==0)
                break;
            end
        end
    end
    
    lambdaSim{k} = lambdaPop;
    PopulationTrack{k,2}=single(cellNumDyn);
    
    if(exitFlag==0)
        if(length(TArr{k})==0)
            TArr{k} = Tg+t;
        else
            Atemp = TArr{k};
            Atemp = [Atemp , Tg+t];
            TArr{k} = Atemp;
        end
    end
    
    for n=1:Nsp
        cellnumSel(k,n) = length(CellsArrSp{n});
    end
    if(FlagDeathStop && exitFlag)
        for n=1:Nsp
            cellnumSel(k,n) = length(CellsArrSp{n});
        end
        continue;
    end
    
end

flag = ['N',num2str(Nsp),'_l_',num2str(lambda),'_mu_',num2str(mu),'_Tg_',num2str(T0),'_Tc_',num2str(Tc),'_D',num2str(Diff),'_JP',num2str(Jackpotflag),'_JPTh',num2str(JPThreshold),'_Nmax',num2str(Nmax)];
% titleF = ['$\lambda_1$=',num2str(lambdaX(1),2),' $\lambda_2$=',num2str(lambdaX(2),2),' $\mu$=',num2str(mu,2),' $T_0$=',num2str(T0),' $T_1$=',num2str(T1),' D=',num2str(Diff),' NL'];
clear aadir
clear RunsDataArr
clear countt
save([flag,'_runs',num2str(runNum),'.mat'],'-v7.3')

