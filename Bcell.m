classdef Bcell < handle
    properties
        lambda;
        mu;
        Diff;
        dt;
        N;
        ParentPos;
        Nmax;
        lambdaBase; %% factor for affinitny to birthrate

    end
    methods
        function obj = Bcell(lambda,mu,Diff,dt,Nmax,lambdaBase);
            if(nargin > 0)
                obj.lambda = lambda;
                obj.mu = mu;
                obj.Diff = Diff;
                obj.dt = dt;
                obj.Nmax = Nmax;
                obj.lambdaBase = lambdaBase;
            else
            end
        end
        function Kid = Birth(obj)
                Kid = obj.BirthKidMut();
        end
        
        function Kid = BirthTc(obj,lambdaMeanAll)
            Kid = obj.BirthKidMutNorm(lambdaMeanAll);
        end
        
        %%%%%%%%%%%%%%
        
        function Kid = BirthTg(obj,lambdaX)

            lambda = obj.lambda;
            
            p = obj.dt*lambda;
            if(rand <= p)
                Kid = Bcell(obj.lambda,obj.mu,obj.Diff,obj.dt,obj.Nmax,obj.lambdaBase);
            else
                Kid = [];
            end
        end
        
%%%%%%%%%%%%%


function Kid = BirthKidMut(obj)

            lambda = obj.lambda;

            if(length(lambda)>1)
                Kid = [];
                return;
            end
            
            p = obj.dt*lambda;
            if(rand <= p)
                MutStd = sqrt(2*obj.Diff);
                lambdaSon = abs(obj.lambda + normrnd(0,MutStd));
                Kid = Bcell(lambdaSon,obj.mu,obj.Diff,obj.dt,obj.Nmax,obj.lambdaBase);
            else
                Kid = [];
            end
        end
        
%%%%%%%%%%%%%

function Kid = BirthKidMutNorm(obj,lambdaMeanAll)

%             lambda = obj.lambda;
            lambda = obj.lambdaBase*obj.lambda/lambdaMeanAll;
            if(length(lambda)>1)
                Kid = [];
                return;
            end
            
            p = obj.dt*lambda;
            if(rand <= p)
                MutStd = sqrt(2*obj.Diff);
                lambdaSon = abs(obj.lambda + normrnd(0,MutStd));
                Kid = Bcell(lambdaSon,obj.mu,obj.Diff,obj.dt,obj.Nmax,obj.lambdaBase);
            else
                Kid = [];
            end
        end
        
%%%%%%%%%%%%%

%%%%%%%%%%%%%        

%%%%%%%%%%%%%
        
        
        function Dflag = DeathT(obj);
            mu = obj.mu;
            p = obj.dt*mu;
            if(rand <= p)
                Dflag=1;
            else
                Dflag=0;
            end
        end       
       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function Dflag = Death(obj,lambdaMeanAll,ntot);
            
            Nmax = obj.Nmax;

            lambda = obj.lambdaBase;
            mu = obj.mu;

            r = lambda - mu;
            m_ntot = obj.mu + r*ntot/Nmax;
            p = obj.dt*m_ntot;
            if(rand <= p)
                Dflag=1;
            else
                Dflag=0;
            end
        end        
    end
end