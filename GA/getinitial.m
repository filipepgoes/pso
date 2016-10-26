function [FUN,Iterate,Iter,FunEval,scale,Successdir,nextIterate,deltaF, ...
        deltaX,MeshCont,NewMeshSize,infMessage,how,stopOutput,stopPlot,run, ...
        OUTPUT,EXITFLAG,X,FVAL,StartTime] = getinitial(FUN,X,Iterate,Vectorized,objFcnArg, ...
        type,neqcstr,MeshContraction,MeshSize,scaleMesh,numberOfVariables,LB,UB)
%GETINITIAL is private to pfminlcon, pfminbnd and pfminunc.

%   Copyright 2003-2005 The MathWorks, Inc.
%   $Revision: 1.7.4.2 $  $Date: 2005/05/31 16:29:55 $

%Initialization
Iter = 0;
FunEval = 0;
Successdir = 1;
nextIterate = Iterate;
deltaF = NaN;
deltaX = NaN;
NewMeshSize = MeshSize;
infMessage  = '';
how = ' ';
stopPlot = false;
stopOutput = false;
run = true;
EXITFLAG = -1;
X(:) = Iterate.x;
FVAL = [];
MeshCont = MeshContraction;
scale = ones(numberOfVariables,1);
OUTPUT = struct('function',FUN,'problemtype',[],'pollmethod',[],'searchmethod',[], ...
    'iterations',[],'funccount',[],'meshsize',[]);

%Check the objective function. 
[FUN,msg] = fcnchk(FUN);
if ~isempty(msg)
    error('gads:GETINITIAL:objFcnArgCheck',msg);
end

%Check the function; Evaluate at the starting point
[Iterate.f,count,msg] = poptimfcnchk(FUN,X,Iterate.x,Vectorized,objFcnArg{:});
FunEval   = FunEval+count;

%We want function to be real
if isnan(Iterate.f)
    error('gads:GETINITIAL:objfunNaN','Objective function must be real and not NaN at the starting point.');
end

%Scale the variables (if needed)
if strcmpi(scaleMesh,'on') && ~neqcstr
    meanX = mean([Iterate.x],2);
    scale = logscale(LB,UB,meanX);
end

%Reset these
nextIterate = Iterate;
FVAL = Iterate.f;
StartTime = cputime;
