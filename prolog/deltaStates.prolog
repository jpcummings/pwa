% sstate(Ja,La,Lf,Pa,P1,P2,S1,S2,R,Alpha);
lam_f(-1/2).
lam_f(1/2).

lam_i(1/2).
lam_i(-1/2).

lam_g(1).
lam_g(-1).


%     ( Ja,   La, Lf, Pa, P1, P2,  S1,S2, R,             Alpha);
%     (  J,    M, Lf,  P, P1, P2,  S1,S2, R,             Alpha);

% J: J of resonance
% M: M of resonance
% Lf: final proton helicity
%P Parity of Resonance
%P1: parity of decay 1 of resonance
%P2: parity of decay 2 of resonance
%S1 spin of decay 1\
%S2 spin of decay 2
 

sstate(1/2,  1/2,  1/2, 1,  1, -1, 3/2, 0, 'Roper++.amp', 'ppi').
sstate(1/2, -1/2,  1/2, 1,  1, -1, 3/2, 0, 'Roper-+.amp', 'ppi').
sstate(1/2,  1/2,  -1/2, 1,  1, -1, 3/2, 0, 'Roper+-.amp', 'ppi').
sstate(1/2, -1/2,  -1/2, 1,  1, -1, 3/2, 0, 'Roper--.amp', 'ppi').

sstate(3/2, 1/2, 1/2, -1,1, -1, 3/2,0,'D13++1.amp','nomatter'). 
sstate(3/2, -1/2, 1/2, -1,1, -1, 3/2,0,'D13+-1.amp','nomatter').
sstate(3/2, 3/2, 1/2, -1,1, -1, 3/2,0,'D13++3.amp','nomatter').
sstate(3/2, -3/2, 1/2, -1,1, -1, 3/2,0,'D13+-3.amp','nomatter').

sstate(3/2, 1/2, -1/2, -1,1, -1, 3/2,0,'D13-+1.amp','nomatter'). 
sstate(3/2, -1/2, -1/2, -1,1, -1, 3/2,0,'D13--1.amp','nomatter').
sstate(3/2, 3/2, -1/2, -1,1, -1, 3/2,0,'D13-+3.amp','nomatter').
sstate(3/2, -3/2, -1/2, -1,1, -1, 3/2,0,'D13--3.amp','nomatter').

accInt('accInt','rawint').
rawInt('rawInt','rawint').

