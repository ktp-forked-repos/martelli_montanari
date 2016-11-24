:- op(20,xfy,?=).

% Prédicats d'affichage fournis

% set_echo: ce prédicat active l'affichage par le prédicat echo
set_echo :- assert(echo_on).

% clr_echo: ce prédicat inhibe l'affichage par le prédicat echo
clr_echo :- retractall(echo_on).

% echo(T): si le flag echo_on est positionné, echo(T) affiche le terme T
%          sinon, echo(T) réussit simplement en ne faisant rien.

echo(T) :- echo_on, !, write(T).
echo(_).



% Regles 

    % Renomage
        % Vrai si les X et T sont des variables
        regle(X?=T,rename) :- var(X), var(T).

    % Simplification
        % Vrai si X est une variable et T une constante
        regle(X?=T,simplify) :- var(X), atomic(T).

    % Développement
        % Vrai si X est une variable, si T est composé et si X n'apparait pas dans T
        regle(X?=T,expand) :- var(X), compound(T), occur_check(X,T).

    % Teste d'ocurrence
        % Vrai si X =/= T et si X apparait dans T
        regle(X?=T,check) :- X\==T, \+occur_check(X,T).

    % Orientation
        % Vrai si T n'est pas une variable et si X en est une
        regle(T?=X,orient) :- nonvar(T), var(X).

    % Decomposition
        % Vrai si on ne peut appliquer le règle de développement et si S et T sont deux fonctions de même sybole et de même arité
        regle(S?=T,decompose) :- \+regle(S?=T,expand), !, functor(S,SF,SA), functor(T,TF,TA), SF==TF, SA==TA.

   % Conflit
        % Vrai si S et T sont deux fonctions de différents symboles ou de différentes arités
        regle(S?=T,clash) :- \+(functor(S,F,A)=functor(T,F,A)).

        
        

% Fonction de teste d'ocurrence (V pas dans T ?)

    occur_check(V,T) :- term_variables(T, L), not_in(V,L), write(L).

    not_in(_X,[]).
    not_in(X,[H|T]):- var(X), !, X\==H, not_in(X,T),!.

