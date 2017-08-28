function CellsArr = BD_step_Nonln(CellsArr,lambdaMeanAll,MuFlag,Ntot)
Deadidx = [];
for i=1:length(CellsArr)
    if(MuFlag == 0)
        Kid = CellsArr(i).BirthTg();
    else
%         Kid = CellsArr(i).Birth();
        Kid = CellsArr(i).BirthTc(lambdaMeanAll);
        
    end
    
    if(length(Kid))
        CellsArr(length(CellsArr)+1,1) = Kid;
    end
    
    if(MuFlag == 0)
        Dflag = CellsArr(i).DeathT();
    else
        Dflag = CellsArr(i).Death(lambdaMeanAll,Ntot);
%         Dflag = CellsArr(i).DeathTInterCloneCom(lambdaMeanAll,Ntot,length(CellsArr));
    end
    if(Dflag)
        Deadidx = [Deadidx ; i];
    end
end
idx = [1:1:length(CellsArr)]';
idxSur = setdiff(idx,Deadidx);
CellsArr = CellsArr(idxSur);
end