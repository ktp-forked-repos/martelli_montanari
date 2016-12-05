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
            regle(X?=T,expand)          :- var(X), compound(T), \+occur_check(X,T).

        % Teste d'ocurrence
            % Faux si X =/= T et si X apparait dans T
            regle(X?=T,check)           :- X \== T, var(X), !, occur_check(X,T).

        % Orientation
            % Vrai si T n'est pas une variable et si X en est une variable
            regle(T?=X,orient)          :- var(X), nonvar(T).

        % Decomposition
            % Vrai si S et T sont deux fonctions de meme symbole et de meme arite
            regle(S?=T,decompose)       :- compound(S), compound(T),!, compound_name_arity(S,SF,SA), compound_name_arity(T,TF,TA), SF==TF, SA==TA.

        % Conflit
            % Faux si F et G sont deux fonctions de differents symboles ou de differentes arites
            regle(F?=G,clash)           :- compound(F), compound(G),! ,compound_name_arity(F,FF,FA), compound_name_arity(G,GF,GA), not( (FF == GF, FA == GA) ).



    % Application des regles

        % Renomage
            rename(X?=T,[X?=T|L],Q)     :- X=T,Q=L.
        % Simplification
            simplify(X?=T,[X?=T|L],Q)   :- X=T,Q=L.
        % Developpement
            expand(X?=T,[X?=T|L],Q)     :- X=T,Q=L.
        % Orientation
            orient(T?=X,[X?=T|L],Q)     :- append(X?=T,L,Q).
        % Decomposition
            decompose(X?=T,[X?=T|L],Q)  :- term_params(X, XL), term_params(T, TL), make_list(XL, TL, LR), append(LR,L,Q).



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
            unifie([X?=T|L])         :- regle(X?=T,rename), !, echo('\nsystem : '), echo([X ?=T |L]), echo('\n'), echo('\trename : '), echo(X?=T), echo('\n'), reduit(rename,X?=T,[X?=T|L],Q), unifie(Q), !. 

        % Simplification
            unifie([X?=T|L])         :- regle(X?=T,simplify), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\tsimplify : '), echo(X?=T), echo('\n'), reduit(simplify,X?=T,[X?=T|L],Q), unifie(Q), !.

        % Developpement
            unifie([X?=T|L])         :- regle(X?=T,expand), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\texpand : '), echo(X?=T), echo('\n'), reduit(expand,X?=T,[X?=T|L],Q), unifie(Q), !.

        % Teste d'ocurrence
            unifie([X?=T|L])         :- regle(X?=T,check), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\tcheck : '), echo(X?=T), echo('\n'), fail, !.

        % Orientation
            unifie([X?=T|L])         :- regle(X?=T,orient), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\torient : '), echo(X?=T), echo('\n'), reduit(orient,X?=T,[X?=T|L],Q), unifie(Q), !.

        % Decomposition
            unifie([X?=T|L])         :- regle(X?=T,decompose), !, echo('\nsystem : '), echo([X ?=T |L]), echo('\n'), echo('\tdecompose : '), echo(X?=T), echo('\n'), reduit(decompose,X?=T,[X?=T|L],Q), unifie(Q), !.

        % Conflit
            unifie([X?=T|L])         :- regle(X?=T,clash), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\tclash : '), echo(X?=T), echo('\n'), fail, !.


		% unifie regle spe
		
		% Renomage
            unifie([X?=T|L],rename)         :- regle(X?=T,rename), !, echo('\nsystem : '), echo([X ?=T |L]), echo('\n'), echo('\trename : '), echo(X?=T), echo('\n'), reduit(rename,X?=T,[X?=T|L],Q), unifie(Q,choix_pondere), !. 

        % Simplification
            unifie([X?=T|L],simplify)         :- regle(X?=T,simplify), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\tsimplify : '), echo(X?=T), echo('\n'), reduit(simplify,X?=T,[X?=T|L],Q), unifie(Q,choix_pondere), !.

        % Developpement
            unifie([X?=T|L],expand)         :- regle(X?=T,expand), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\texpand : '), echo(X?=T), echo('\n'), reduit(expand,X?=T,[X?=T|L],Q), unifie(Q,choix_pondere), !.


        % Teste d'ocurrence
            unifie([X?=T|L],check)         :- regle(X?=T,check), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\tcheck : '), echo(X?=T), echo('\n'), fail, !.

        % Orientation
            unifie([X?=T|L],orient)         :- regle(X?=T,orient), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\torient : '), echo(X?=T), echo('\n'), reduit(orient,X?=T,[X?=T|L],Q), unifie(Q,choix_pondere), !.

        % Decomposition
            unifie([X?=T|L],decompose)         :- regle(X?=T,decompose), !, echo('\nsystem : '), echo([X ?=T |L]), echo('\n'), echo('\tdecompose : '), echo(X?=T), echo('\n'), reduit(decompose,X?=T,[X?=T|L],Q), unifie(Q,choix_pondere), !.

        % Conflit
            unifie([X?=T|L],clash)         :- regle(X?=T,clash), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\tclash : '), echo(X?=T), echo('\n'), fail, !.

		
		
		%unifie random random_between(1,7,F)
		
			unifie(Q,random)			:- random_between(1,7,F), unifie(Q,F) .
				
            unifie([X?=T|L],1)         :- regle(X?=T,rename), !, echo('\nsystem : '), echo([X ?=T |L]), echo('\n'), echo('\trename : '), echo(X?=T), echo('\n'), reduit(rename,X?=T,[X?=T|L],Q),random_between(1,7,F), unifie(Q,F), !. 

            unifie([X?=T|L],2)         :- regle(X?=T,simplify), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\tsimplify : '), echo(X?=T), echo('\n'), reduit(simplify,X?=T,[X?=T|L],Q), random_between(1,7,F), unifie(Q,F), !.

            unifie([X?=T|L],3)         :- regle(X?=T,expand), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\texpand : '), echo(X?=T), echo('\n'), reduit(expand,X?=T,[X?=T|L],Q), random_between(1,7,F), unifie(Q,F), !.

            unifie([X?=T|L],4)         :- regle(X?=T,check), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\tcheck : '), echo(X?=T), echo('\n'), fail, !.

            unifie([X?=T|L],5)         :- regle(X?=T,orient), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\torient : '), echo(X?=T), echo('\n'), reduit(orient,X?=T,[X?=T|L],Q), random_between(1,7,F), unifie(Q,F), !.

            unifie([X?=T|L],6)         :- regle(X?=T,decompose), !, echo('\nsystem : '), echo([X ?=T |L]), echo('\n'), echo('\tdecompose : '), echo(X?=T), echo('\n'), reduit(decompose,X?=T,[X?=T|L],Q), random_between(1,7,F), unifie(Q,F), !.

            unifie([X?=T|L],7)         :- regle(X?=T,clash), !, echo('\nsystem : '), echo([X?=T|L]), echo('\n'), echo('\tclash : '), echo(X?=T), echo('\n'), fail, !.
			
			unifie([],1)                    :- echo('\n\n'), echo('Fin de l\'unification\n').
			unifie([],2)                    :- echo('\n\n'), echo('Fin de l\'unification\n').
			unifie([],3)                    :- echo('\n\n'), echo('Fin de l\'unification\n').
			unifie([],4)                    :- echo('\n\n'), echo('Fin de l\'unification\n').
			unifie([],5)                    :- echo('\n\n'), echo('Fin de l\'unification\n').
			unifie([],6)                    :- echo('\n\n'), echo('Fin de l\'unification\n').
			unifie([],7)                    :- echo('\n\n'), echo('Fin de l\'unification\n').
		
		unifie([X?=T|L],premier)         :- unifie([X?=T|L]).
		
		unifie([],choix_pondere)                    :- echo('\n\n'), echo('Fin de l\'unification\n').
		
		% clash, check > rename, simplify > orient > decompose > expand
		% unifier choix_pondere
		%suite de if then else
				% ( true(if) ->(then) A ; (else) b  )
		unifie([X?=T|L],choix_pondere):- 	
									( (regle(X?=T,clash)) ->
											unifie([X?=T|L],clash) ; 
											( (regle(X?=T,check)) ->
											unifie([X?=T|L],check) ; 
												( (regle(X?=T,rename)) ->
													unifie([X?=T|L],rename) ; 
													( (regle(X?=T,simplify)) ->
													unifie([X?=T|L],simplify) ; 
														( (regle(X?=T,orient)) ->
														unifie([X?=T|L],orient) ; 
															( (regle(X?=T,decompose)) ->
																unifie([X?=T|L],decompose) ; 
																( (regle(X?=T,expand)) ->
																unifie([X?=T|L],expand) ))))))).
		
		
    % Helpers
        % Fonction de teste d'ocurrence (Vrai si V n'est pas dans T)
            occur_check(V,T)            :-  contains_var(V,T).


        % Fonction de création de liste [X?=T|L] à partire de deux listes [X|L1] et [T|L2]
            make_list([X|L1],[T|L2],L)  :- make_list(L1,L2,Z), append([X?=T],Z,LR), L=LR.
            make_list([],[],L)          :- L=[].


        % Fonction qui retourne les parametres d un prédicat
            term_params(X,L)            :- \+is_list(X), !, X=..XP, term_params(XP,L).
            term_params([_|P],L)        :- L=P.
            term_params([],L)           :- L=L.



		% 




unif(P,S)       :- clr_echo, unifie(P,S).

trace_unif(P,S) :- set_echo, unifie(P,S).

:- initialization main.

main :-
    write('Algorithme d unification\n'),
    write('----------------------------------------------------------------\n'),
	
    write('Indiquer une liste a unifier : \n'),
    read(P),
    write('Indiquer une stratégie : \n'),
    read(S),
    trace_unif(P,S)
.

  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  