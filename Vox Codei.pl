incr(X, X1) :-
    X1 is X+1.
decr(X, X1) :-
    X is X1-1.

clean_row([]).
clean_row([H|T]):-
    H \== @,
    clean_row(T).
clean_grid([]).
clean_grid([H|T]):-
    clean_row(H),
    clean_grid(T).

no_fire_row([]).
no_fire_row([H|T]):-
    H \== @,
    no_fire_row(T).
no_fire_grid([]).
no_fire_grid([H|T]):-
    no_fire_row(H),
    no_fire_grid(T).


wait_row([],[]):-!.
wait_row([X1|T1],[X2|T2]):-
    X1 = [1],
    X2 = fire,
    wait_row(T1,T2),!.
wait_row([X1|T1],[X2|T2]):-
    X1 = [Timer],
    X2 = [New_Timer],
    New_Timer is Timer-1,
    wait_row(T1,T2),!.
wait_row([X1|T1],[X2|T2]):-
   X1 = X2,
   wait_row(T1,T2).

wait_grid([],[]):-!.
wait_grid([X1|T1],[X2|T2]):-
    wait_row(X1,X2),
    wait_grid(T1,T2).

fire_cells([X,Y],[[L1,L2,L3],[R1,R2,R3],[U1,U2,U3],[D1,D2,D3]]):-
    incr(X,X1),
    incr(X1,X2),
    incr(X2,X3),
    decr(X_1,X),
    decr(X_2,X_1),
    decr(X_3,X_2),
    incr(Y,Y1),
    incr(Y1,Y2),
    incr(Y2,Y3),
    decr(Y_1,Y),
    decr(Y_2,Y_1),
    decr(Y_3,Y_2),
    L1 = [X_1,Y],
    L2 = [X_2,Y],
    L3 = [X_3,Y],
	R1 = [X1,Y],
	R2 = [X2,Y],
	R3 = [X3,Y],
	U1 = [X,Y_1],
	U2 = [X,Y_2],
	U3 = [X,Y_3],
	D1 = [X,Y1],
	D2 = [X,Y2],
	D3 = [X,Y3].

solve(Grid,_,0,[]):-
    clean_grid(Grid),!.
solve(Grid,Bombs,Turns,[H|T]):-
    H = wait,
    wait_grid(Grid,Future_Grid),
    New_Turns is Turns - 1,
    solve(Future_Grid,Bombs,New_Turns,T).
	% maplist(writeln,Grid).
solve(Grid,Bombs,Turns,[H|T]):-
    H=[X,Y],
    Bombs > 0,
    Turns > 0,
    replace_row_col(Grid,X,Y,[3],Temp_Grid),
	wait_grid(Temp_Grid,Future_Grid),
    New_Turns is Turns - 1,
    New_Bombs is Bombs - 1,
    % propagate(Future_Grid,Future_Future_Grid),
    solve(Future_Grid,New_Bombs,New_Turns,T).

propagate(Grid1,Grid1):-
    not(indexer([X,Y],Grid1,fire)).
    
propagate(Grid1,Grid2):-
    indexer([X,Y],Grid1,fire),
    ...
    

test:-I=[[[-1], [-1], [-1], [4], [-1], [-1], [-1]],
            [[-1], [0], [1], [0], [2], [-1]],
            [[3], [4], [3], [1], [1], [2], [3]],
            [[1], [5], [4], [2], [4], [3]],
            [[2], [3], [4], [0], [4], [4], [1]],
            [[2], [3], [1], [3], [0], [4]],
            [[0], [1], [0], [3], [2], [1], [0]],
            [[-1], [2], [2], [5], [0], [-1]],
            [[-1], [-1], [-1], [4], [-1], [-1],[-1]]],
    replace_row_col(I,2,4,'x',Upd),
    maplist(writeln,Upd).

replace_nth(N,I,V,O):-
    nth1(N,I,_,T),
    nth1(N,O,V,T).

replace_row_col(M,Row,Col,Cell,N):-
    indexer([Row,Col],M,Ele),
    Ele \= [_],
    Ele \= #,
    Ele \= @,
    Ele \= burnt,
    nth1(Row,M,Old),
    replace_nth(Col,Old,Cell,Upd),
    replace_nth(Row,M,Upd,N).

indexer([], _, []).
indexer([R, C], M, V):-
    nth1(R, M, Row),
    nth1(C, Row, V),
    indexer([], M, []).
