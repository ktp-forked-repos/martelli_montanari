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
        regle(X?=T,expand) :- var(X), compound(T), occurCheck(X,T).

    % Teste d'ocurrence
        % Vrai si X =/= T et si X apparait dans T
        regle(X?=T,check) :- X/=T, not occurCheck(X,T).

    % Orientation
        % Vrai si T n'est pas une variable et si X en est une
        regle(T?=X,orient) :- nonvar(T), var(X).

    % Decomposition
        % Vrai
        regle(S?=T,decompose) :- not regle(S?=T,expand) ,functor(S,SF,SA),functor(T,TF,TA),SF==TF,SA==TA.

    % Conflit
        % Vrai
        regle(S?=T,clash) :- not (functor(S,F,A)=functor(S,F,A)),!.

        
        












regle(f(a) ?= f(b),decompose)



sum([], 0) :- !.
sum([T|Q], Somme) :- sum(Q, S), Somme is T + S.
 
writeSum :-  sum([1,2,3,4,5,6], S), write(S), nl.