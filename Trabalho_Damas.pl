:- use_module(library(lists)).

% board(-Board).
% Creates a board container, with uninitialized positions
board(game_board(A,B,C,D,E,F,G,H)):-
    functor(A,l,8), 
    functor(B,l,8),
    functor(C,l,8),
    functor(D,l,8), 
    functor(E,l,8), 
    functor(F,l,8), 
    functor(G,l,8), 
    functor(H,l,8).

% board_initialize_empty(-Board).
% Creates a empty board, i.e. initialized with 0 for black space and 1 for white space
board_initialize_empty(game_board(A,B,C,D,E,F,G,H)):-
    board(game_board(A,B,C,D,E,F,G,H)),
    board_initialize_empty_even(A),
    board_initialize_empty_odd(B),
    board_initialize_empty_even(C),
    board_initialize_empty_odd(D),
    board_initialize_empty_even(E),
    board_initialize_empty_odd(F),
    board_initialize_empty_even(G),
    board_initialize_empty_odd(H).

% board_initialize_game(-Board).
% Creates a board with the initial state of a game, i.e. the white and the black pieces are placed.
board_initialize_game(game_board(A,B,C,D,E,F,G,H)):-
    board(game_board(A,B,C,D,E,F,G,H)),
    board_initialize_game_even(A,b),
    board_initialize_game_odd(B,b),
    board_initialize_game_even(C,b),
    board_initialize_empty_odd(D),
    board_initialize_empty_even(E),
    board_initialize_game_odd(F,w),
    board_initialize_game_even(G,w),
    board_initialize_game_odd(H,w),
    board_initialize_empty(Empty_Board),
    assert(empty_board(Empty_Board)).

% board_initialize_empty_odd(+Line).
% Auxiliary function that initializes a line of the board with alternating black and white spaces.
board_initialize_empty_odd(A):-
    arg(1,A,0), arg(2,A,1),
    arg(3,A,0), arg(4,A,1),
    arg(5,A,0), arg(6,A,1),
    arg(7,A,0), arg(8,A,1).

% board_initialize_empty_even(+Line).
% Auxiliary function that initializes a line of the board with alternating black and white spaces.
board_initialize_empty_even(A):-
    arg(1,A,1), arg(2,A,0),
    arg(3,A,1), arg(4,A,0),
    arg(5,A,1), arg(6,A,0),
    arg(7,A,1), arg(8,A,0).

% board_initialize_game_odd(+Line,+Player_Symbol).
% Auxiliary function that initializes a line of the board. The player pieces and black spaces are alternaded. 
board_initialize_game_odd(Line,Player):-
    arg(1,Line,Player), arg(2,Line,0),
    arg(3,Line,Player), arg(4,Line,0),
    arg(5,Line,Player), arg(6,Line,0),
    arg(7,Line,Player), arg(8,Line,0).

% board_initialize_game_even(+Line,+Player_Symbol).
% Auxiliary function that initializes a line of the board. The player pieces and black spaces are alternaded.
board_initialize_game_even(Line,Player):-
    arg(1,Line,0), arg(2,Line,Player),
    arg(3,Line,0), arg(4,Line,Player),
    arg(5,Line,0), arg(6,Line,Player),
    arg(7,Line,0), arg(8,Line,Player).


% board_print(+Board).
% Prints the board Board to the console.
board_print(game_board(A,B,C,D,E,F,G,H)):-
    board_print_line(A),
    board_print_line(B),
    board_print_line(C),
    board_print_line(D),
    board_print_line(E),
    board_print_line(F),
    board_print_line(G),
    board_print_line(H).

% board_print_line(+Line).
% Auxiliary function that prints a line of the board.
board_print_line(Line):-
    board_print_line_element(Line,1),
    board_print_line_element(Line,2),
    board_print_line_element(Line,3),
    board_print_line_element(Line,4),
    board_print_line_element(Line,5),
    board_print_line_element(Line,6),
    board_print_line_element(Line,7),
    board_print_line_element(Line,8),
    nl.

% board_print_line_element(+Line,+Index).
% Auxiliary function that prints a element of the board to the console.
board_print_line_element(Line,Index):-
    arg(Index,Line,E),
    print(E),
    tab(2).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pos(+Board,+X,+Y,-Element).
% Returns the value of the position (X,Y). It can be the board color or the piece at that location.
pos(Board, X, Y, E):-
    arg(Y,Board,T),
    arg(X,T,E).

% replace(+Board,+X,+Y,+Element,-New_Board).
% Places or replaces the element at position (X,Y) with Element and returns a New_Board. 
replace(Board, X, Y, Element, New_Board):-
    functor(New_Board,game_board,8),
    replace_in_board(Board,X,Y,Element,New_Board,1).

% replace_in_board(+Board,+X,+Y,+Element,+New_Board,+Iterator).
% Auxiliary Function
% Receives an uninitialized New_Board and replaces element at position (X,Y) from Board
% with Element in the New_Board. All the other positions are copies of Board.
replace_in_board(_,_,_,_,_,Iterator):- Iterator > 8, !.
replace_in_board(Board, X, Y, Element, New_Board, Iterator):-
    Iterator == Y, !,
    arg(Y,Board,Line),
    functor(New_Line,l,8),
    replace_in_line(Line, X, Element, New_Line, 1),
    arg(Iterator,New_Board,New_Line),
    Iterator_Next is Iterator + 1,
    replace_in_board(Board, X, Y, Element, New_Board, Iterator_Next).
replace_in_board(Board, X, Y, Element, New_Board, Iterator):-
    arg(Iterator,Board,Line),
    arg(Iterator,New_Board,Line),
    Iterator_Next is Iterator + 1,
    replace_in_board(Board, X, Y, Element, New_Board, Iterator_Next).

% replace_in_line(+Line,+X,+Element,+New_Line,+Iterator).
% Auxiliary Funciton
% Replaces the element at index X with Element. All other positions are copies from Line.
replace_in_line(_,_,_,_, Iterator):- Iterator > 8, !.
replace_in_line(Line, X, Element, New_Line, Iterator):-
    Iterator == X, !,
    arg(X,New_Line,Element),
    Iterator_Next is Iterator + 1,
    replace_in_line(Line, X, Element, New_Line, Iterator_Next).
replace_in_line(Line, X, Element, New_Line, Iterator):-
    arg(Iterator,Line,Old),
    arg(Iterator,New_Line,Old),
    Iterator_Next is Iterator + 1,
    replace_in_line(Line, X, Element, New_Line, Iterator_Next).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:-dynamic game_state_player_move/1.
game_state_player_move(white).

next_player(white,black).
next_player(black,white).


move(Player, Xi, Yi, Xf, Yf, Board):-
    game_state_player_move(Player),
    %...
    next_player(Player,Next_Player),
    retract(game_state_player_move(Player)),
    assert(game_state_player_move(Next_Player)).

