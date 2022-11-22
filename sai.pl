% Taken and modified from https://gist.github.com/MuffinTheMan/7806903
% Get an element from a 2-dimensional list at (Row,Column)
% using 1-based indexing.
nth1_2d(Row, Column, List, Element) :-
    nth1(Row, List, SubList),
    nth1(Column, SubList, Element).

% Reads a file and retrieves the Board from it.
load_board(BoardFileName, Board):-
    see(BoardFileName),     % Loads the input-file
    read(Board),            % Reads the first Prolog-term from the file
    seen.                   % Closes the io-stream

% Checks whether the group of stones connected to
% the stone located at (Row, Column) is alive or dead.

check_alive(Row, Column, BoardFileName):-
    load_board(BoardFileName, Board), % Board == board2darray
    map_allies_around(Row, Column, Board, []).

% check_piece_exist(Row, Column, Board, Stone):-
%     nth1_2d(Row, Column, Board, Stone),
%     (Stone = b; Stone = w).

testing(Row, Column, BoardFileName, AboveStone):-
    load_board(BoardFileName, Board), % Board == board2darray
    NewRow is Row - 1,
    nth1_2d(NewRow, Column, Board, AboveStone).

% true if row column is ok, and returns the stone above
% check_piece_up(Row, Column, Board, Stone, AboveStone):-
%     NewRow is Row - 1,
%     nth1_2d(NewRow, Column, Board, AboveStone).

% check_piece_down(Row, Column, Board, Stone, AboveStone):-
%     NewRow is Row + 1,
%     nth1_2d(NewRow, Column, Board, AboveStone).

% check_piece_right(Row, Column, Board, Stone, AboveStone):-
%     NewColumn is COlumn +1,
%     nth1_2d(Row, NewColumn, Board, AboveStone).

% % true if stone above is empty
% check_piece_left(Row, Column, Board, Stone, AboveStone):-
%     NewColumn is COlumn -1,
%     nth1_2d(Row, NewColumn, Board, AboveStone).


% return true when piece is not dead (has empty)
map_allies_around(Row, Column, Board, CheckList):-
    nth1_2d(Row, Column, Board, Stone),
    add_tail(CheckList, [Row, Column], NewCheckList),

    Up is Row - 1,
    nth1_2d(Up, Column, Board, AboveStone),
    AboveStone = Stone -> (
        map_allies_around(Up, Column, Board, NewCheckList);
        AboveStone = e -> !
    ),
    Right is Column + 1,
    nth1_2d(Row, Right, Board, RightStone),
    RightStone = Stone -> (
        map_allies_around(Row, Right, Board, NewCheckList);
        RightStone = e -> !
    ),
    Down is Row + 1,
    nth1_2d(Down, Column, Board, DownStone),
    DownStone = Stone -> (
        map_allies_around(Down, Column, Board, NewCheckList);
        DownStone = e -> !
    ),
    Left is Column - 1,
    nth1_2d(Row, Left, Board, LeftStone),
    LeftStone = Stone -> (
        map_allies_around(Row, Left, Board, NewCheckList);
        LeftStone = e -> !
    ).


is_member(X, [X | _]) :- !.    % If the head of the list is X from: https://www.geeksforgeeks.org/lists-in-prolog/
is_member(X, [_ | Rest]) :-    % else recur for the rest of the list
     is_member(X, Rest).

add_tail([],X,[X]). %  from: https://stackoverflow.com/questions/15028831/how-do-you-append-an-element-to-a-list-in-place-in-prolog
add_tail([H|T],X,[H|L]):-
    add_tail(T,X,L).

is_same_or_e(Stone, AboveStone):-
    \+ ((AboveStone = Stone); AboveStone = e).
