% :- module(buildSBase,[buildSBase/0,writeSLikeFile/0]).

conc([],L,L).
conc([X|L1],L2,[X|L3]) :- conc(L1,L2,L3).

helDiff(-1,1,3/2).
helDiff(-1,-1,-1/2).
helDiff(1,1,1/2).
helDiff(1,-1,-3/2).


% symmetry of production amplitudes

% f(Li,Lip,Lg,Lgp,Eta_alpha,Ja,Factor).
f( 1, 1, 1,1,_,_,1.0).
f(-1, 1,-1,1,Eta_alpha,Ja,X) :- R is -1.0**(Ja - 1/2),X is Eta_alpha * R.
f(-1,-1, 1,1,_,_,1.0).
f( 1,-1,-1,1,Eta_alpha,Ja,X) :-  R is -1.0**(Ja - 1/2),X is Eta_alpha * R.

% g(Lf,Lfp,Pa,P1,P2,Ja,S1,S2,Factor) defines parity on decay amplitudes
g( 1,1,_,_,_,_,_,_,1.0).
g(-1,1,Pa,P1,P2,Ja,S1,S2,Factor) :- R is -1.0**(Ja-S1-S2), Factor is Pa*P1*P2*R.

buildSBase :-
  lam_i(Li),lam_g(Lg),lam_f(Lf),
  sstate(Ja,La,Lf,Pa,P1,P2,S1,S2,R,Alpha),
  helDiff(Li,Lg,La),
  f(Li,Lip,Lg,Lgp,Pa,Ja,Eta),g(Lf,_,Pa,P1,P2,Ja,S1,S2,Fac2),
  Xfac is Fac2 * Eta,
  parName(Alpha,Lip,Lgp,Ja,Pa,Parname),
  assertz(salpha(Parname,R,Li,Lg,Lf,Ja,La,Pa,Xfac)),
  \+clause(spar(Parname),_),assertz(spar(Parname)),assertz(sparVal(Parname,1.0,0.0)),
  fail.

buildSBase.


% clear the database

clearSBase :-
  retract(salpha(_,_,_,_,_,_,_,_,_)),fail.

clearSBase :-
  retract(spar(_)),fail.

clearSBase :-
  retract(sparVal(_)),fail.

clearSBase.

%printSstate

parName(Alpha,Li,Lg,Ja,Pa,Name) :- 
  name('V_',Nv),name(Alpha,Na),name('_',Nu),
  name(Li,Ni),name(Lg,Ng),Jaa is 2 * Ja,name(Jaa,Nj),name(Pa,Np),
  conc(Nv,Na,X1),
  conc(X1,Nj,X2),
  conc(X2,Nu,X3),
  conc(X3,Np,X4),
  conc(X4,Nu,X5),
  conc(X5,Ni,X6),
  conc(X6,Nu,X7),
  conc(X7,Ng,X8),name(Name,X8).

waveSName(Li,Lg,_,_,Lf,_,R,Name) :- 
  name('S_',NF),name(R,Nr),name('_',Nu),
  name(Li,Ni),name(Lg,Ng),name(Lf,Nf),
  conc(NF,Nr,X1),
  conc(X1,Nu,X2),
  conc(X2,Ni,X3),
  conc(X3,Nu,X4),
  conc(X4,Ng,X5),
  conc(X5,Nu,X6),
  conc(X6,Nf,X7),name(Name,X7).

printSBase :- 
  write('Li\tLg\tJa\tLa\tLf\tPa\tFactor\tDecay amps\t\tName'),nl,fail.


printSBase :- 
  salpha(Name,Amps,Li,Lg,Lf,Ja,La,Pa,Factor),
  write(Li),write('\t'),
  write(Lg),write('\t'),
  write(Ja),write('\t'),
  write(La),write('\t'),
  write(Lf),write('\t'),
  write(Pa),write('\t'),
  write(Factor),write('\t'),
  write(Amps),write('\t'),
  write(Name),nl,fail.
  printSBase.


writeSNorm :- 
  write('normalization:'),nl,
  write('fcn = fcn + nevents * ('),nl,
  writeSNormAux.

writeSNormAux :- 
  accInt(NI,_),lam_i(Li),lam_g(Lg),lam_f(Lf),
  salpha(Name1,Amp1,Li,Lg,Lf,_,_,_,_),
  salpha(Name2,Amp2,Li,Lg,Lf,_,_,_,_),
  write('+'),write(NI),write('['),
    write(Amp1),write(' , '),write(Amp2),
  write('] * '),
  write(Name1),write('* conj('),write(Name2),write(')'),nl,fail.

writeSNormAux :- 
  write(');'),nl.



writeSWtFile :- 
  writeSdamps,nl,
  declareSParComplex,nl,
  write('event_loop:'),nl,
  writeSSums,
  writeSWt.

declareSS :- 
  lam_i(Li),lam_g(Lg),lam_f(Lf),
  sm(Li,Lg,Lf,N),
  write('complex '),write(N),write(';'),nl,
  fail.

declareSS.


writeSdamps :- 
  sstate(_,_,_,_,_,_,_,_,Amps,_),
  write('damp '),write(Amps),write(';'),nl,
  fail.

writeSdamps.

% writeSPars declares refelectivity/lin pol par parameters for the fit.

writeSPars :-
 spar(X),write('par '),write(X),write(';'),nl,fail.
writeSPars.

% S_Li_Lg

wavesSName(Li,Lg,Name) :-
  name('S_',NS),name('_',Nu),name(Li,Ni),name(Lg,Ng),
  conc(NS,Ni,X2),conc(X2,Nu,X3),conc(X3,Ng,X4),name(Name,X4).


declareAllSs :-  
  lam_i(Li),lam_g(Lg),
  wavesSName(Li,Lg,Name),
  write('complex '),write(Name),write(';'),nl,
  fail.
declareAllSs.


writeX(1).
writeX(-1) :- write(' -1 * ').

writeAllSs :-
  lam_i(Li),lam_g(Lg),writeSs(Li,Lg),fail.

writeAllSs.

writeSSum(Li,Lg,Lf) :- 
  sm(Li,Lg,Lf,N),
  write(N),write(' = '),
  salpha(Name,Amp,Li,Lg,Lf,_,_,_,Eta),
  write(' + '),write(Eta),write(' * '),
  write(Name),write(' * '),write(Amp),
  fail.

writeSSum(_,_,_) :- 
  write(';'),nl.

sm(Li,Lg,Lf,N) :- 
  name('S_',Ns),name('_',Nu),name(Li,Ni),name(Lg,Ng),name(Lf,Nf),
  conc(Ns,Ni,X1),
  conc(X1,Nu,X2),
  conc(X2,Ng,X3),
  conc(X3,Nu,X4),
  conc(X4,Nf,X5),
  name(N,X5).

writeSSums :- 
  lam_i(Li),lam_g(Lg),lam_f(Lf),
  writeSSum(Li,Lg,Lf),
  fail.
writeSSums.

writeSWt :- 
  write('wt = '),nl,
  writeSWtAux.

writeSWtAux :-
  lam_i(Li),lam_g(Lg),lam_f(Lf),
  sm(Li,Lg,Lf,N),
  write(' + absSq('),write(N),write(')'),nl,
  fail.

writeSWtAux :- 
  write(';'),nl.

declareSParComplex :-  
  spar(X),
  write('complex '),write(X),write(';'),nl,
  fail.
declareSParComplex.

declareSPar :-  
  spar(X),
  write('par '),write(X),write(';'),nl,
  fail.
declareSPar.

declareRNI :-
  rawInt(NI,File),
  write('integral '),write(NI),
  write('('),write(File),write(');'),nl,
  fail.
declareRNI.

declareANI :-
  accInt(NI,File),
  write('integral '),write(NI),
  write('('),write(File),write(');'),nl,
  fail.
declareANI.

writeSParVal :- 
  spar(X),
  write(X),write(' = ('),
  sparVal(X,R,I),write(R),write(' , '),write(I),
  write(');'),nl,
  fail.
writeSParVal.

  
writeSLikeFile :- 
  writeSdamps,nl,
  declareSPar,nl,
  declareSS,nl,
  declareANI,nl,
  declareRNI,nl,
  write('event_loop:'),nl,
  writeSSums,nl,
  writeSLike,
  writeSNorm.

writeSLike :-
  write('fcn = fcn - log ('),nl,
  writeSLikeAux.

writeSLikeAux :-  
  lam_i(Li),lam_g(Lg),lam_f(Lf),
  sm(Li,Lg,Lf,N),
  write(' + absSq('),
  write(N),
  write(')'),nl,
  fail.

writeSLikeAux :- 
  write(');'),nl.


% help text

help :- 
  helpVlabel,
  help_salpha,
  helpSname.

helpVlabel :- 
  nl,write('The production amp labels are defined as: V_(2 * J)_P_Li_Lg'),nl.

help_salpha :- 
  nl, write('The salpha relationship is defined as:'),nl,
  write('     Amp,DecayAmps,Li,Lg,Lf,J,M,P,Factor'),nl,
  write('     where Factor defines sign under parity transformation'),nl.

helpSname :- 
  nl,write('S amplitudes are labelled by S_DecayAmp_Li_Lg_Lf\n').

