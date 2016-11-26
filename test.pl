:- op(20,xfy,?=).

% Prédicats d'affichage fournis

% set_echo: ce prédicat active l'affichage par le prédicat echo
set_echo :- assert(echo_on).

% clr_echo: ce prédicat inhibe l'affichage par le prédicat echo
clr_echo :- retractall(echo_on).

% echo(T): si le flag echo_on est positionné, echo(T) affiche le termeT
%          sinon, echo(T) réussit simplement en ne faisant rien.

echo(T) :- echo_on, !, write(T).
echo(_).


%%%%%%%%%%%%% Question 1 

% regle(E,R)
regle(X?=T,rename):- var(X),var(T),!.
regle(X?=T,simplify):- var(X),atomic(T),!.
regle(X?=T,expand):- var(X),compound(T),occur_check(X,T),!.
regle(X?=T,check):- X\==T,\+occur_check(X,T),!.
regle(T?=X,orient):- nonvar(T),var(X),!.
regle(T1?=T2,decompose):- \+regle(T1?=T2,expand),!,functor(T1,F1,A1),functor(T2,F2,A2),F1==F2,A1==A2,!.
regle(T1?=T2,clash):- \+(functor(T1,F,A)=functor(T2,F,A)),!.

% occur_check(X,T): vrai si la variable X n'apparait pas dans le terme T
% Fonction de teste d'ocurrence (V pas dans T ?)
            occur_check(V,T)            :- term_variables(T, L), not_in(V,L).


        % Fonction de teste de non appartenance a une liste
            not_in(_X,[]).
            not_in(X,[H|T])

% reduit(R,E,P,Q) 

 reduit(rename,X?=T,[X?=T|Rest],Q) :-  
  %on unifie l'equation et on s'occupe du reste Q
  X=T,Q=Rest.
 reduit(simplify,X?=T,[X?=T|Rest],Q) :-
  X=T,Q=Rest.
 reduit(expand,X?=T,[X?=T|Rest],Q) :-
  X=T,Q=Rest.
 reduit(orient,X?=T,[X?=T|Rest],Q) :-
  X=T,Q=Rest.
 reduit(decompose,X?=T,[X?=T|Rest],Q) :-
  X=..X1, %transforme une fonction ou un prédicat p(X1,..,Xn) en une liste [p,X1,..,Xn]
  delete_one(X1,X_res),  %pour supprimer le premier élément de la liste (le nom du predicat)
  T=..T1, %pareil avec la seconde partie de l'equation
  delete_one(T1,T_res),
%décompse les X1..Xn,T1..Tn en une liste tel que X1?=T1...T1?=Tn et l'ajoute au nouveau systeme
  dec_liste(X_res,T_res,Res),append(Res,Rest,Q),!. 


%predicat pour supprimer le premier élément
delete_one([_|Z],K) :- K = Z,!.
delete_one([]):- [],!.

%predicat pour décomposer : X1?=T1...T1?=Tn
dec_liste([A1|Rest1],[A2|Rest2],Res) :- dec_liste(Rest1,Rest2,Res1),append([A1?=A2],Res1,Res),!.
dec_liste([],[],Res) :- Res=Res,!.


% reduit(_,X?=T,[X?=T|Rest],Q) :-

% unifie(P)

unifie([]) :- !. 

% Parcours de la liste d'equations, on regarde à chaque fois si on peut appliquer une regle ou non
% Si oui on l'applique et on passe au reste des equations (récursion) 
unifie([X?=T|Rest]) :- 
  regle(X?=T,rename),!,
  %trace%
  echo('systeme:  '),echo([X?=T|Rest]),echo('\n'),echo('rename:   '),echo(X?=T),echo('\n'),
  %traitement
  reduit(rename,X?=T,[X?=T|Rest],Q),unifie(Q),!.

unifie([X?=T|Rest]) :- 
  regle(X?=T,simplify),!,
  %trace%
  echo('systeme:  '),echo([X?=T|Rest]),echo('\n'),echo('simplify: '),echo(X?=T),echo('\n'),
  %traitement
  reduit(simplify,X?=T,[X?=T|Rest],Q),unifie(Q),!.

unifie([X?=T|Rest]) :- 
  regle(X?=T,expand),!,
  %trace%
  echo('systeme:  '),echo([X?=T|Rest]),echo('\n'),echo('expand:   '),echo(X?=T),echo('\n'),
  %traitement
  reduit(expand,X?=T,[X?=T|Rest],Q),unifie(Q),!.

unifie([X?=T|Rest]) :- 
  regle(X?=T,check),!,
  %trace%
  echo('systeme:  '),echo([X?=T|Rest]),echo('\n'),echo('check:    '),echo(X?=T),echo('\n'),
  %traitement
  fail,!.

unifie([X?=T|Rest]) :- 
  regle(X?=T,orient),!,
  %trace%
  echo('systeme:  '),echo([X?=T|Rest]),echo('\n'),echo('orient:   '),echo(X?=T),echo('\n'),
  %traitement
  reduit(orient,X?=T,[X?=T|Rest],Q),unifie(Q),!.

unifie([X?=T|Rest]) :- 
  regle(X?=T,decompose),!,
  %trace%  
  echo('systeme:  '),echo([X?=T|Rest]),echo('\n'),echo('decompose:'),echo(X?=T),echo('\n'),
  %traitement
  reduit(decompose,X?=T,[X?=T|Rest],Q),unifie(Q),!.

unifie([X?=T|Rest]) :- 
  regle(X?=T,clash),!,
  %trace%
  echo('systeme:  '),echo([X?=T|Rest]),echo('\n'),echo('clash:    '),echo(X?=T),echo('\n'),
  %traitement
  fail,!.



  
:- initialization main.

main :-
  set_echo,
  write('Algorithme d unification'),
  write('----------------------------------------------------------------\n').
  