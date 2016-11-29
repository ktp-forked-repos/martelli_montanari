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
            regle(X?=T,rename)          :- var(X), var(T).

        % Simplification
            % Vrai si X est une variable et T une constante
            regle(X?=T,simplify)        :- var(X), atomic(T).

        % Developpement
            % Vrai si X est une variable, si T est compose et si X n'apparait pas dans T
            regle(X?=T,expand)          :- echo('application expand \n'),var(X), compound(T), !, \+occur_check(X,T).

        % Teste d'ocurrence
            % Vrai si X =/= T et si X apparait dans T
            regle(X?=T,check)           :- X\==T, !, \+occur_check(X,T).

        % Orientation
            % Vrai si T n'est pas une variable et si X en est une
            regle(T?=X,orient)          :- nonvar(T), var(X).

        % Decomposition
            % Vrai si S et T sont deux fonctions de meme symbole et de meme arite
            regle(S?=T,decompose)       :- echo('test decompose \n'),nonvar(S), nonvar(T),!, functor(S,SF,SA), functor(T,TF,TA), SF==TF, SA==TA.

        % Conflit
            % Vrai si F et G sont deux fonctions de differents symboles ou de differentes arites
            regle(F?=G,clash)           :- \+(functor(F,F,A)=functor(G,F,A)).



    % Application des regles

        % Renomage
            rename(X?=T,[X?=T|L],Q)     :- echo('application rename \n'),X=T,Q=L.
        % Simplification
            simplify(X?=T,[X?=T|L],Q)   :- echo('application simplify \n'),X=T,Q=L.
        % Developpement
            expand(X?=T,[X?=T|L],Q)     :- echo('application expand \n'),X=T,Q=L.
        % Orientation
            orient(T?=X,[X?=T|L],Q)     :- echo('application orient \n'),append(X?=T,L,Q).
        % Decomposition
            decompose(X?=T,[X?=T|L],Q)  :- echo('application decompose \n'),term_params(X, XL), term_params(T, TL), make_list(XL, TL, LR), echo('list \n'), append(LR,L,Q).



    % Reduction : transforme le systeme d equations P en le systeme dequations Q par application de la regle de transformation sur lequation E

        % Renomage
            reduit(rename,E,P,Q)        :- rename(E,P,Q).
        % Simplification
            reduit(simplify,E,P,Q)      :- simplify(E,P,Q).
        % Developpement
            reduit(expand,E,P,Q)        :- expand(E,P,Q).
        % Orientation
            reduit(orient,E,P,Q)        :- orient(E,P,Q).
        % Decomposition
            reduit(decompose,E,P,Q)     :- decompose(E,P,Q).



        
    % Unification


        unifie([])                    :- echo('\n\n'), echo('Fin de l\'unification\n').
    


        % Renomage
            unifie([X?=T|L])         :- regle(X?=T,rename), !, echo('system : '), echo([X ?=T |L]), echo('\n'), echo('rename : '), echo(X?=T), echo('\n'), reduit(rename,X?=T,[X?=T|L],Q), unifie(Q), !. 

        % Simplification
            unifie([X?=T|L])         :- regle(X?=T,simplify), !, echo('system : '), echo([X?=T|L]), echo('\n'), echo('simplify : '), echo(X?=T), echo('\n'), reduit(simplify,X?=T,[X?=T|L],Q), unifie(Q), !.

        % Developpement
            unifie([X?=T|L])         :- regle(X?=T,expand), !, echo('system : '), echo([X?=T|L]), echo('\n'), echo('expand : '), echo(X?=T), echo('\n'), reduit(expand,X?=T,[X?=T|L],Q), unifie(Q), !.

        % Teste d'ocurrence
            unifie([X?=T|L])         :- regle(X?=T,check), !, echo('system : '), echo([X?=T|L]), echo('\n'), echo('check : '), echo(X?=T), echo('\n'), fail, !.

        % Orientation
            unifie([X?=T|L])         :- regle(X?=T,orient), !, echo('system : '), echo([X?=T|L]), echo('\n'), echo('orient : '), echo(X?=T), echo('\n'), reduit(orient,X?=T,[X?=T|L],Q), unifie(Q), !.

        % Decomposition
            unifie([X?=T|L])         :- regle(X?=T,decompose), !, echo('system : '), echo([X ?=T |L]), echo('\n'), echo('decompose : '), echo(X?=T), echo('\n'), reduit(decompose,X?=T,[X?=T|L],Q), unifie(Q), !.

        % Conflit
            unifie([X?=T|L])         :- regle(X?=T,clash), !, echo('system : '), echo([X?=T|L]), echo('\n'), echo('clash : '), echo(X?=T), echo('\n'), fail, !.



    % Helpers
        % Fonction de teste d'ocurrence (Vrai si V n'est pas dans T)
            occur_check(V,T)            :-  compound(T), !, contains_var(V,T).


        % Fonction de création de liste [X?=T|L] à partire de deux listes [X|L1] et [T|L2]

            make_list([X|L1],[T|L2],L)  :- make_list(L1,L2,Z),append([X?=T],Z,L).
            make_list([],[],L)          :- L=L.


        % Fonction qui retourne les parametres d un prédicat
            term_params(X,L)            :- \+is_list(X), !, X=..XP, term_params(XP,L).
            term_params([_|P],L)        :- L=P.
            term_params([],L)           :- L=L.









:- initialization main.

main :-
  set_echo,
  write('Algorithme d unification\n'),
  write('----------------------------------------------------------------\n').
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  