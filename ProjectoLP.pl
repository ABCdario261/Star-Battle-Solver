% lp24 - ist1113459 Gabriel Monte- projecto 
:- use_module(library(clpfd)). % para poder usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- [puzzles]. % Ficheiro dado. A avaliação terá mais puzzles.
:- [codigoAuxiliar]. % Ficheiro dado. Não alterar.
% Atenção: nao deves copiar nunca os puzzles para o teu ficheiro de código
% Nao remover nem modificar as linhas anteriores. Obrigado.
% Segue-se o código
%%%%%%%%%%%%
/*visualiza(Lista) -> 
Este predicado devolve por linha cada elemento da Lista*/
visualiza([]). %Caso base, quando a lista acabar a função acaba
visualiza([H|T]):- 
    writeln(H), %Pegamos no primeiro elemento da lista, e escrevemos
    visualiza(T). %E continuamos o até a Lista acabar

/*visualizaLinha(Lista) ->
Este predicado devolve cada elemento da Lista por linha,
com cada linha sendo numerada*/
visualizaLinha(Lista):- 
    visualizaLinhaAux(Lista,1). %Adicionamos um contador, para as linhas

visualizaLinhaAux([],_).
visualizaLinhaAux([H|T],Linha):-
    write(Linha), %Escrevemos o número da linha
    write(": "),
    writeln(H),   %Escrevemos o elemento da Lista e fazemos uma nova linha
    Proxlinha is Linha + 1, %Vamos adicionando o contador da linha
    visualizaLinhaAux(T,Proxlinha).

/*insereObjecto((L, C), Tabuleiro, Obj)->
Neste predicado, caso nesta coordenada encontrar se uma posição livre,
Vai se inserir o objeto pedido*/
insereObjecto((L, C), Tabuleiro, Obj):-
    L>=1, C>=1, %As coordenadas têm que ser positivas
    length(Tabuleiro,Tamanholinhas),
    L=<Tamanholinhas, %As coordenadas pedidas têm de estar dentro tabuleiro
    nth1(L,Tabuleiro,Linha), %Obtemos o elemento que está no tabuleiro, nessa coordenada
    length(Linha,TamanhoColunas),
    C=<TamanhoColunas, 
    nth1(C,Linha,Elemento),
    (var(Elemento)-> Elemento = Obj),!. %Se o elemento no tabuleiro for uma posição livre insere o objeto
insereObjecto(_,_,_):-!.
    %Se o elemento não for uma posição livre, o predicado não falha, apenas não faz nada
    
/*insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs)->
Este predicado é semelhante ao anterior, 
Só que neste caso inserimos vários objetos, 
A cada coordenada da ListaCoords inserimos o respetivo objeto da ListaObjs*/
insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs):-
    length(ListaCoords,N), %Se o tamanho da ListaCoords não for igual á dos objetos falha
    length(ListaObjs,N),!,
    insereVariosObjectosAux(ListaCoords,Tabuleiro,ListaObjs).

insereVariosObjectosAux([],_,[]). %Caso base, o predicado acaba quando ambas as listas forem vazias
insereVariosObjectosAux([(X,Y)|T],Tabuleiro,[H1|T1]):-
    insereObjecto((X,Y),Tabuleiro,H1), %Chamamos o predicado anterior e continuamos o processo
    insereVariosObjectosAux(T,Tabuleiro,T1).

/*inserePontosVolta(Tabuleiro, (L, C))->
Este predicado insere pontos á volta das coordenadas dadas*/
inserePontosVolta(Tabuleiro, (L, C)):-
    L1 is L-1, L2 is L+1, %As coordenadas á volta da dada serão dadas por estas
    C1 is C-1, C2 is C+1,
    PosicoesAdjacentes = [(L1,C1),(L1,C),(L1,C2),(L,C1),(L,C2),(L2,C1),(L2,C),(L2,C2)],!, 
    inserePontos(Tabuleiro,PosicoesAdjacentes).

/*inserePontos(Tabuleiro, ListaCoord)->
Neste predicado inserimos pontos nas coordenadas dadas*/
inserePontos(_,[]). %Caso base, o predicado acaba quando a Lista de Coord acabar
inserePontos(Tabuleiro,[(X,Y)|T]):-
    insereObjecto((X,Y),Tabuleiro,p), %Chamamos o insereObjecto, como objecto temos o p
    inserePontos(Tabuleiro,T),!.  % Chamamos outra vez a função com as coordenadas seguintes

/*insereEstrelas (Tabuleiro, ListaCoord)->
Este predicado faz exatamente o mesmo que o anterior, 
Neste caso inserimos e em vez de p*/
insereEstrelas(_,[]):-!.
insereEstrelas(Tabuleiro, [(X,Y)|T]):-
    insereObjecto((X,Y),Tabuleiro,e),
    insereEstrelas(Tabuleiro,T),!.
    
/*objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs)->
Neste predicado vamos buscar os objs ás respetivas coordenadas*/
objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs):-
    objectosEmCoordenadasAux(ListaCoords, Tabuleiro, [], ListaObjs),!.
    %Criei uma auxiliar para criar uma lista em branco e inserir os objetos lá
objectosEmCoordenadasAux([],_,Acc,Acc). %Caso base, o predicado acaba quando a lista das coord tiver vazia
objectosEmCoordenadasAux([(X,Y)|T], Tabuleiro ,Acc,ListaObjs):- %E guardamos na ListaObjs aquilo que procuramos
    X>=1, Y>=1, %Como em predicados anteriores, as coordenadas têm que estar válidas
    length(Tabuleiro,Tamanholinhas),
    X=<Tamanholinhas,
    nth1(X,Tabuleiro,Linha),
    length(Linha,TamanhoColunas),
    Y=<TamanhoColunas, 
    nth1(Y,Linha,Elemento),
    append(Acc,[Elemento],Acc1), %Guardamos o elemento da respetiva coordenada na lista e repetimos o processo
    objectosEmCoordenadasAux(T,Tabuleiro,Acc1,ListaObjs),!.
objectosEmCoordenadasAux([(_,_)|_],_,_,_) :-
    !,fail. %Se alguma das verificações acima forem falsas, o predicado dá false

/*coordObjectos(Objecto, Tabuleiro, ListaCoords, ListaCoordObjs)->
Neste predicado de acordo com as coordenadas dadas e o objeto dado,
Vamos verificar quais coordendas têm como elemento esse objeto, 
E de seguida guardamos essas posições em Lista CoordObjs
E guardamos também o tamanho dessa lista NumObjectos*/
coordObjectos(Objecto, Tabuleiro, ListaCoords, ListaCoordsObjs, NumObjectos):-
    coordObjectosAux(Objecto, Tabuleiro, ListaCoords,[], ListaCoordsObjs1),
    %Criei a auxiliar para obter a lista com os objetos respetivos
    sort(ListaCoordsObjs1,ListaCoordsObjs), %Aqui ordenei a lista
    length(ListaCoordsObjs,NumObjectos),!. % E de seguida verifiquei o tamanho da lista


coordObjectosAux(_,_,[],Acc,Acc):- !. % Caso base, o predicado acaba quando a lista tiver vazia
                                      % E vai guardar em ListaCoordsObjs os resultados
coordObjectosAux(Objecto, Tabuleiro, [(X,Y)|T], Acc, ListaCoordsObjs):- %
    nth1(X,Tabuleiro,Linha),
    nth1(Y,Linha,Elemento), %Buscamos o elemento da coordenada respetiva 
    nonvar(Elemento), %Verificamos se é variável
    Elemento == Objecto, %Verificamos se o elemento é igual ao obj
    append(Acc,[(X,Y)],Acc1), %Se as verificações acima forem cumpridas, guarda essa coordenada
    coordObjectosAux(Objecto, Tabuleiro, T, Acc1, ListaCoordsObjs),!. % E chamamos denovo a função
coordObjectosAux(Objecto, Tabuleiro, [(X,Y)|T], Acc, ListaCoordsObjs):-
    nth1(X,Tabuleiro,Linha),
    nth1(Y,Linha,Elemento),
    var(Objecto),
    var(Elemento),!, %Aqui como ambos o obj e o elem são variáveis, a verificação passa pois são posições livres
    append(Acc,[(X,Y)],Acc1),
    coordObjectosAux(Objecto, Tabuleiro, T, Acc1, ListaCoordsObjs),!.
coordObjectosAux(Objecto, Tabuleiro, [(_,_)|T],Acc,ListaCoordsObjs):-
    coordObjectosAux(Objecto, Tabuleiro, T, Acc, ListaCoordsObjs),!. 
    %Se as coordenadas tiverem fora do tabuleiro, apenas continua o predicado

/*CoordenadasVars(Tabuleiro, ListaVars)->
Neste predicado obtemos as coordenadas todas das variáveis*/
coordenadasVars(Tabuleiro, ListaVars) :-
    length(Tabuleiro, N),
    Tabuleiro = [H|_],
    length(H,NDentro), %Buscamos o tamanho do tabuleiro todo e de uma linha, para depois utilizarmos para boundaries
    coordenadasVarsAux(Tabuleiro, 1, 1, N,NDentro, [], ListaVarsCorreta),
    %Esta auxiliar cria a tal lista com as coordenadas de variáveis
    ListaVars = ListaVarsCorreta. % Verificamos se de facto a lista dada é correta

coordenadasVarsAux(_, CoordX, _, N, _, Acc, Acc) :-
    %Ao verificar o todos os elementos do tabuleiro, quando a CoordX, que é o numero de "linhas" chega ao fim,
    %Quer dizer que percorremos o Tabuleiro todo e que podemos sair deste predicado Aux
    CoordX > N,!. 
coordenadasVarsAux(Tabuleiro, CoordX, CoordY, N, NDentro, Acc, ListaVarsCorreta) :-
    CoordY > NDentro,!, %Ao verificar os elementos do tabuleiro, quando a CoordY, que é o numero de "colunas" chega ao fim,
                        %Quer dizer que temos que mudar para a próxima linha
    CoordX1 is CoordX + 1,
    coordenadasVarsAux(Tabuleiro, CoordX1, 1, N, NDentro, Acc, ListaVarsCorreta). %E continuamos a função
coordenadasVarsAux(Tabuleiro, CoordX, CoordY, N, NDentro, Acc, ListaVarsCorreta) :-
    %Neste caso, como não estamos em nenhum dos outros casos, podemos verificar cada elemento do tabuleiro,
    %E assim verificar se é variável, e de seguida guardar a sua posição e passar para a próxima coluna
    nth1(CoordX, Tabuleiro, Linha),
    nth1(CoordY, Linha, Elem),
    (var(Elem) ->append(Acc, [(CoordX, CoordY)], Acc1) ; Acc1 = Acc),
    CoordY1 is CoordY + 1,
    coordenadasVarsAux(Tabuleiro, CoordX, CoordY1, N, NDentro, Acc1, ListaVarsCorreta).

/*fechaListaCoordenadas(Tabuleiro, ListaCoord)->
Neste predicado, de acordo com as hipóteses escritas no enunciado,
Vamos aplicar a sua devida resolução*/
fechaListaCoordenadas(Tabuleiro,ListaCoord):-
    listaElemCoord(Tabuleiro,ListaCoord,[],ListaElem),
    %FunçãoAux que guarda numa lista, as coordendas e o elem dessas devidas coordenadas
    contador(ListaElem,0,Estrelas,0,Livres),
    %FunçãoAux que conta o número de estrelas e posições livres
    fechaListaCoordenadasAux(Tabuleiro,ListaElem,Estrelas,Livres),!.
    %FunçãoAux que faz a resolução de acordo com os resultados das funções anteriores

listaElemCoord(_,[],Acc,Acc):- !. %Caso base, para quando o Tabuleiro fica vazio, e vai guardando a lista
listaElemCoord(Tabuleiro,[(X,Y)|T],Acc,ListaElem):-
    nth1(X,Tabuleiro,Linha),
    nth1(Y,Linha,Elem),
    append(Acc,[((X,Y),Elem)],Acc1), %Busca as coordenadas e o elem dessas coords
    listaElemCoord(Tabuleiro,T,Acc1,ListaElem),!.

contador([], EstrelasAcc, EstrelasAcc, LivresAcc, LivresAcc):- !. %Caso base, acaba quando a lista fica vazia e,
                                                                  %vai guardando a contagem de estrelas e variáveis
contador([((_,_),H)|T], EstrelasAcc, Estrelas, LivresAcc, Livres):-
    var(H),!, %Se o elem for uma variável, aumentamos a contagem e passamos para o próximo elem
    LivresAcc1 is LivresAcc + 1,
    contador(T, EstrelasAcc, Estrelas, LivresAcc1, Livres),!.
contador([((_,_),H)|T], EstrelasAcc, Estrelas, LivresAcc, Livres):-
    H == e,!, %Se o elem for uma estrela aumentamos a contagem e passamos para o próximo elem
    EstrelasAcc1 is EstrelasAcc + 1,
    contador(T, EstrelasAcc1, Estrelas, LivresAcc, Livres),!.
contador([((_,_),H)|T], EstrelasAcc, Estrelas, LivresAcc, Livres):-
    H == p,!, %Se p elem for um p apenas passa á frente
    contador(T, EstrelasAcc, Estrelas, LivresAcc, Livres),!.


fechaListaCoordenadasAux(Tabuleiro,ListaElem,Estrelas,_):-
    Estrelas == 2,!, %Quando estamos na primeira hipótese
    findall((X, Y), (member(((X, Y), Elem), ListaElem),var(Elem)), ListaCoordVar),
    %Encontramos todas as coordenadas que tenham como elemento uma variável
    inserePontos(Tabuleiro,ListaCoordVar),!.
    %E inserimos os pontos
fechaListaCoordenadasAux(Tabuleiro,ListaElem,Estrelas,Livres):-
    Estrelas == 1,Livres == 1,!, %Quando estamos na segunda hipótese
    findall((X,Y),(member(((X,Y),Elem),ListaElem), var(Elem)), ListaCoordVar),
    %Encontramos todas as coordenadas que tenham como elemento uma variável
    insereEstrelas(Tabuleiro,ListaCoordVar),
    %Inserimos a estrela
    ListaCoordVar = [(X,Y)|_],
    inserePontosVolta(Tabuleiro,(X,Y)),!.
    %E os respetivos pontos á volta
fechaListaCoordenadasAux(Tabuleiro,ListaElem,Estrelas,Livres):-
    Estrelas == 0,Livres == 2,!, %Na terceira hipótese
    findall((X,Y),(member(((X,Y),Elem),ListaElem),var(Elem)), ListaCoordVar),
    insereEstrelas(Tabuleiro,ListaCoordVar),
    %Inserimos as estrelas
    inserePontosVoltaComLista(Tabuleiro,ListaCoordVar),!.
    %E os respetivos pontos á volta, com uma nuance onde aqui temos uma lista de coordenadas
    %E por isso uma função aux nova
fechaListaCoordenadasAux(_,_,_,_):- %Se não acontecer nenhuma das hipóteses, o código segue em frente
    !.

inserePontosVoltaComLista(_,[]):- !.% Caso base, para quando a lista de coordenadas estiver vazia
inserePontosVoltaComLista(Tabuleiro,[(X,Y)|T]):-
    inserePontosVolta(Tabuleiro,(X,Y)), %Insere pontos á volta dessa coordenada e segue para a próxima
    inserePontosVoltaComLista(Tabuleiro,T),!.

/*fecha(_,[])->
Este predicado serve para aplicar o fechaListaCoordendas,
a cada coordenada dada.*/
fecha(_,[]):- !. %Caso base, para quando a lista de coord tiver vazia
fecha(Tabuleiro,[H|T]):-
    fechaListaCoordenadas(Tabuleiro,H), %Chamamos a primeira coordenada
    fecha(Tabuleiro,T),!. % E seguimos para a próxima

listaElemSeq(_,[],Acc,Acc,Ac,Ac):-!. %Caso base, para quando não houver mais coordenadas, e atualiza as duas listas
listaElemSeq(Tabuleiro, [(X,Y)|T],Acc,ListaComElemECoord,Ac,ListaComElem):-
    nth1(X, Tabuleiro, Linha),
    nth1(Y, Linha, Elem),
    append(Acc, [((X,Y),Elem)], Acc1),%Semelhante a outro predicado Aux, só que neste,
    append(Ac,[Elem],Ac1),%Guardamos também uma lista apenas com elementos
    listaElemSeq(Tabuleiro, T, Acc1, ListaComElemECoord,Ac1,ListaComElem),!.

verificaListaVar([],_,Acc,Acc,_):-!. %Caso base, acaba quando não houver mais coordendas,
                                     %E atualiza a Lista com as coordenadas das Var
verificaListaVar([((X,Y),Elem)|T],N,Acc,ListaComVar,VerificadorSeguido):-
    var(Elem),!, %Neste caso, caso o elem seja Var
    append(Acc,[(X,Y)],Acc1), %Guardamos essa coordenda numa lista
    VerificadorSeguido1 is VerificadorSeguido + 1, % E de seguida o VerificadorSeguido "liga",
    %Ou seja, agora se vier algum elemento que não seja variável, o predicado vai falhar,
    %Pois as Var têm que estar seguidas
    verificaListaVar(T,N,Acc1,ListaComVar,VerificadorSeguido1),!. %Continua para a prox Coord 
verificaListaVar([((_,_),Elem)|T],N,Acc,ListaComVar,VerificadorSeguido):-
    nonvar(Elem),%Neste caso, caso o elem não seja Var
    VerificadorSeguido == 0,!, %Como o Verificador não ligou
    VerificadorSeguido1 is VerificadorSeguido,
    Acc = Acc1,
    %Quer dizer que ainda não encontramos nenhuma variável, ou seja,
    %Ainda podem estar todas seguidas, por isso continuamos o predicado
    verificaListaVar(T,N,Acc1,ListaComVar,VerificadorSeguido1),!.
verificaListaVar([((_,_),Elem)|T],N,Acc,ListaComVar,VerificadorSeguido):-
    nonvar(Elem), %Neste caso, caso o elem não seja Var
    VerificadorSeguido == N,!,%Como o verificador chegou a N
    %Quer dizer que já viu todas as variáveis seguidas, no entanto,
    %Poderá haver uma mais há frente na lista, por isso,
    %Continuamos com o predicado
    VerificadorSeguido1 is VerificadorSeguido,
    Acc = Acc1,
    verificaListaVar(T,N,Acc1,ListaComVar,VerificadorSeguido1),!.
verificaListaVar([((_,_),_)|_],_,_,_,_):-
    false,!. %Se nenhum dos casos acima aconteceu quer dizer que o predicado falhou

/*encontraSequencia(Tabuleiro, N, ListaCoords,Seq)->
Neste predicado, de acordo com o tamanho N, 
verificamos se existe de acordo com a ListaCoords dada,
uma sequencia onde haja N variáveis seguidas*/
encontraSequencia(Tabuleiro, N, ListaCoords, Seq) :-
    listaElemSeq(Tabuleiro,ListaCoords,[],ListaComElemECoord,[],ListaComElem),
    %Esta função auxiliar serve para obter uma lista com as coordenadas e os seus respetivos elem,
    %E outra para obter uma lista apenas com os seus elementos
    findall(Var, (member(Var, ListaComElem), var(Var)), NumVar),
    %Aqui encontramos o número de variáveis dos elementos dados
    length(NumVar,N),
    %E verificamos se condiz com o N dado
    findall(Est, (member(Est, ListaComElem), Est == e), NumEst),
    %Aqui encontramos o número de estrelas dos elementos dados
    length(NumEst,0),
    %E tem de ser 0
    verificaListaVar(ListaComElemECoord,N,[],ListaComVar,0),
    %Esta funçãoAux vai servir para verificar se as varáveis estão seguidas
    %E para dar a Lista final com as Var seguidas
    ListaComVar = Seq,!.

/*aplicaPadraoI(Tabuleiro, [(L1,C1),(L2,C2),(L3,C3)])->
Neste predicado, apenas inserimos uma estrela na primeira e na terceira coord,
E de seguida inserimos os respetivos pontos á volta de cada estrela*/
aplicaPadraoI(Tabuleiro, [(L1,C1),(_,_),(L3,C3)]):-
    insereEstrelas(Tabuleiro,[(L1,C1)]),
    insereEstrelas(Tabuleiro,[(L3,C3)]),
    inserePontosVolta(Tabuleiro,(L1,C1)),
    inserePontosVolta(Tabuleiro,(L3,C3)).
/*aplicaPadroes(Tabuleiro, ListaListaCoords)->
Neste predicado, aplicamos os respetivos padroes, dependendo do tamanho da Seq*/
aplicaPadroes(_, []):-!. %Caso base, o predicado acaba quando não houver mais coords
aplicaPadroes(Tabuleiro, [H|T]) :-
    encontraSequencia(Tabuleiro,3,H,Seq),!, %Neste caso como o tamanho é 3
    aplicaPadraoI(Tabuleiro,Seq),%Aplicamos o Padrao I e seguimos com o resto das coordenadas
    aplicaPadroes(Tabuleiro,T),!.
aplicaPadroes(Tabuleiro, [H|T]):-
    encontraSequencia(Tabuleiro,4,H,Seq), %Neste caso como o tamanho é 4
    aplicaPadraoT(Tabuleiro,Seq),%Aplicamos o Padrao T e seguimos com o resto das coordenadas
    aplicaPadroes(Tabuleiro,T),!.
aplicaPadroes(Tabuleiro,[_|T]):-
    aplicaPadroes(Tabuleiro,T),!. %Se nenhum dos casos anteriores funcionar, 
    %Continuamos com resto das coordenadas

/*resolve(Estruturas, Tabuleiro)->
Neste predicado resolvemos o tabuleiro, 
Aplicando o aplicaPadroes e o fecha, 
Até não poder resolver mais o tabuleiro*/
resolve(Estruturas, Tabuleiro):-
    coordenadasVars(Tabuleiro, ListaVarsOriginal), 
    %Descubrimos as coordenadas das variáveis antes de resolver o tabuleiro
    coordTodas(Estruturas, CoordTodas),
    aplicaPadroes(Tabuleiro, CoordTodas), %Aplicamos o aplica e o fecha
    fecha(Tabuleiro, CoordTodas),
    coordenadasVars(Tabuleiro,ListaVars),
    %Descubrimos as coordenadas das variáveis depois de resolver o tabuleiro
    (ListaVarsOriginal == ListaVars -> ! ; resolve(Estruturas, Tabuleiro)).
    %Se forem iguais quer dizer que não podemos resolver mais, e termina,
    %Senão forem iguais, temos que resolvê-lo mais uma vez