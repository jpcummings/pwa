
% These are valid angular momenta

am(0).
am(1).
am(2).
am(3).
am(4).
am(5).

% pdg is defined as: pdg(name,J,P,C,I,G).

pdg(pi,0,-1,+1,1,-1).
pdg(b1,1,+1,-1,1,+1).
pdg(f1,1,1,1,0,1).
pdg(f2,2,1,1,0,1).
pdg(omega,1,-1,-1,0,-1).
pdg(rho,1,-1,-1,1,1).
pdg(eta,0,-1,+1,0,+1).
pdg(a0,0,1,1,1,-1).
pdg(f0,0,1,1,0,1).
pdg(sigma,0,1,1,0,1).
pdg(phi,1,-1,-1,0,-1).
pdg(a2,2,1,1,1,-1).

j(X,J) :- pdg(X,J,_,_,_,_).
p(X,P) :- pdg(X,_,P,_,_,_).
c(X,C) :- pdg(X,_,_,C,_,_).
i(X,I) :- pdg(X,_,_,_,I,_).
g(X,G) :- pdg(X,_,_,_,_,G).


decay(f1,eta,pi,pi).
decay(b1,omega,pi).
decay(rho,pi,pi).
decay(f0,pi,pi).
decay(sigma,pi,pi).
decay(f2,pi,pi).
decay(a0,eta,pi).

jaux(0,X,X).


jaux(1,1,0).
jaux(1,1,1).
jaux(1,1,2).

jaux(1,2,1).
jaux(1,2,2).
jaux(1,2,3).


jaux(2,2,0).
jaux(2,2,1).
jaux(2,2,2).
jaux(2,2,3).
jaux(2,2,4).

jaux(1,3,2).
jaux(1,3,3).
jaux(1,3,4).


sym(L,S) :- am(L),S is -1^L.

jx(L) :- am(L),write(L),write(' '),sym(L,1).

j(X,Y,J) :- X < Y,jaux(X,Y,J).
j(X,Y,J) :- Y =< X,jaux(Y,X,J).






i(X,Y,I) :- i(X,Ix),i(Y,Iy),j(Ix,Iy,I).



p(X,Y,L,P) :- am(L),p(X,A),p(Y,B),Z is -1^L,P is A * B * Z.

g(X,Y,G) :- g(X,A),g(Y,B),G is A * B.

c(X,Y,C,I) :- g(X,A),i(X,IA),g(Y,B),i(Y,IB),j(IA,IB,I),C is A * B * -1^I.


table(X,Y,L,J,P,C,I,G) :- am(L),j(X,Jx),j(Y,Jy),j(Jx,Jy,Jtot),j(L,Jtot,J),p(X,Y,L,P),i(X,Y,I),g(X,Y,G),
  c(X,Y,C,I).



table(X,Y,L,J,P,C,I,G,Jtot) :- am(L),j(X,Jx),j(Y,Jy),j(Jx,Jy,Jtot),j(L,Jtot,J),p(X,Y,L,P),i(X,Y,I),g(X,Y,G),c(X,Y,C,I).


ptable(F,X,Y,L,J,P,C,I,G,S) :- tell(F),ptableaux(X,Y,L,J,P,C,I,G,S),told,tell(user).

ptableaux(X,Y,L,J,P,C,I,G,S) :-
table(X,Y,L,J,P,C,I,G,S),wtable(X,Y,L,J,P,C,I,G,S).

wtable(X,Y,L,J,P,C,I,G,S) :-
write(X),tab(2),write(Y),tab(2),write(L),tab(2),write(J),
tab(2),write(P),tab(2),write(C),tab(4),write(I),tab(2),
write(G),tab(3),write(S),nl.


% Defined to be exotic(J,P,C).

exotic(0,-1,-1).
exotic(0,1,-1).

exotic(1,-1,1).
exotic(2,1,-1).
exotic(3,-1,1).
exotic(4,1,-1).



