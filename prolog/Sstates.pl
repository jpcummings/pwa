% sstate(Ja,La,Lf,Pa,P1,P2,S1,S2,R,Alpha);
lam_f(-1).
lam_f(1).

lam_i(1).
lam_i(-1).

lam_g(1).
lam_g(-1).


%     ( Ja,   La, Lf, Pa, P1, P2,  S1,S2, R,             Alpha);
%     (  J,    M, Lf,  P, P1, P2,  S1,S2, R,             Alpha);

sstate(1/2,  1/2,  1, -1,  1, -1, 3/2, 0, '1-.+1+1.amp', 'ppi0').
sstate(1/2, -1/2,  1, -1,  1, -1, 3/2, 0, '1-.-1+1.amp', 'ppi0').
 
sstate(1/2,  1/2, -1, -1,  1, -1, 3/2, 0, '1-.+1-1.amp', 'ppi0').
sstate(1/2, -1/2, -1, -1,  1, -1, 3/2, 0, '1-.-1-1.amp', 'ppi0').

accInt('accInt','rawint').
rawInt('rawInt','rawint').

