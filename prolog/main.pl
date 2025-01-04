% :- module(main,[main/0]).

main :- consult('Sstates.pl'),buildSBase,writeSLikeFile,halt.
