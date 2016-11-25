% Operateur ?=
:- op(20,xfy,?=).

% Predicats d'affichage fournis

% set_echo: ce predicat active l'affichage par le predicat echo
set_echo :- assert(echo_on).

% clr_echo: ce predicat inhibe l'affichage par le predicat echo
clr_echo :- retractall(echo_on).

% echo(T): si le flag echo_on est positionne, echo(T) affiche le terme T
%          sinon, echo(T) reussit simplement en ne faisant rien.

echo(T) :- echo_on, !, write(T).
echo(_).



% Regles

    % Conditions d'utilisation des regles

        % Renomage
            % Vrai si les X et T sont des variables
            regle(X?=T,rename) :- var(X), var(T).

        % Simplification
            % Vrai si X est une variable et T une constante
            regle(X?=T,simplify) :- var(X), atomic(T).

        % Developpement
            % Vrai si X est une variable, si T est compose et si X n'apparait pas dans T
            regle(X?=T,expand) :- var(X), compound(T), occur_check(X,T).

        % Teste d'ocurrence
            % Vrai si X =/= T et si X apparait dans T
            regle(X?=T,check) :- X\==T, \+occur_check(X,T).

        % Orientation
            % Vrai si T n'est pas une variable et si X en est une
            regle(T?=X,orient) :- nonvar(T), var(X).

        % Decomposition
            % Vrai si on ne peut appliquer le regle de developpement et si S et T sont deux fonctions de meme symbole et de meme arite
            regle(S?=T,decompose) :- \+regle(S?=T,expand), !, functor(S,SF,SA), functor(T,TF,TA), SF==TF, SA==TA.

        % Conflit
                % Vrai si S et T sont deux fonctions de differents symboles ou de differentes arites
                regle(S?=T,clash) :- \+(functor(S,F,A)=functor(T,F,A)).

    % Application des regles : transforme le systeme d equations P en le systeme dequations Q par application de la regle de transformation sur lequation E
        % Renomage
            reduit(rename,E,P,Q) :-write(E+P+Q+"\n").
        % Simplification
            reduit(simplify,E,P,Q) :-write('a faire\n'+E+P+Q).
        % Developpement
            reduit(expand,E,P,Q) :-write('a faire\n'+E+P+Q).
        % Teste d'ocurrence
            reduit(check,E,P,Q) :-write('a faire\n'+E+P+Q).
        % Orientation
            reduit(orient,E,P,Q) :-write('a faire\n'+E+P+Q).
        % Decomposition
            reduit(decompose,E,P,Q) :-write('a faire\n'+E+P+Q).
        % Conflit
            reduit(clash,E,P,Q) :-write('a faire\n'+E+P+Q).




    % Helpers
        % Fonction de teste d'ocurrence (V pas dans T ?)

            occur_check(V,T) :- term_variables(T, L), not_in(V,L), write(L).

            not_in(_X,[]).
            not_in(X,[H|T]):- var(X), !, X\==H, not_in(X,T),!.

:- initialization main.

main :-
  write('execution du programme\n'),
  write('----------------------------------------------------------------\n'),
  
  reduit(rename,n,b,v),
  
  
  write('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n').
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  