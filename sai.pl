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
    get_piece_exist(Row, Column, Board, Stone),
    map_allies_around(Row, Column, Board, Stone, []).

get_piece_exist(Row, Column, Board, Stone):-
    nth1_2d(Row, Column, Board, Stone),
    (Stone = b; Stone = w).

% testing(Row, Column, BoardFileName, CheckList):-
%     load_board(BoardFileName, Board), % Board == board2darray
%     map_allies_around(Row, Column, Board, CheckList).

% % true if row column is ok, and returns t'he stone above
% check_up(Up, Column, Board, AboveStone):-'

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


% check_current(Row, Column, Board, AllyStone, CheckList):-
%     Column < 10,
%     Row < 10,

%     nth1_2d(Row, Column, Board, Stone),
%     (
%         Stone = e -> !;
%         Stone = AllyStone ->
%             Up is Row - 1,
%             Right is Column + 1,
%             Down is Row + 1,
%             Left is Column - 1,

%     )

% returns false, if no escape,
% return true, if has escape and alive
map_allies_around(Row, Column, Board, AllyStone, CheckList):-
    Up is Row - 1,
    Right is Column + 1,
    Down is Row + 1,
    Left is Column - 1,

    Right < 10, % if position is out of bounds that position is enemy color(no escape)
    Down < 10,

    nth1_2d(Row, Column, Board, Stone),
    format('~w ~46t ~w ~46t ~w ~46t ~n', [Row, Column, Stone]),
    (
        Stone = e;                                                          % if stone is e, it has an escape and return true.
        (Stone = AllyStone, (\+ is_member([Row, Column], CheckList)),       % else if stone is ally and pos has not been checked
            (                                                               % and any of the allies around has an empty near, then it has escape so return true.
                map_allies_around(Up, Column, Board, AllyStone, [[Row, Column]| CheckList]);
                map_allies_around(Row, Right, Board, AllyStone, [[Row, Column]| CheckList]);
                map_allies_around(Down, Column, Board, AllyStone, [[Row, Column]| CheckList]);
                map_allies_around(Row, Left, Board, AllyStone, [[Row, Column]| CheckList])
            )
        )
    ).


is_member(X, [X | _]) :- !.    % If the head of the list is X from: https://www.geeksforgeeks.org/lists-in-prolog/
is_member(X, [_ | Rest]) :-    % else recur for the rest of the list
     is_member(X, Rest).

is_same_or_e(Stone, AboveStone):-
    \+ ((AboveStone = Stone); AboveStone = e).
