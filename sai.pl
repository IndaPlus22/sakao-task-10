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
    check_piece_exist(Row, Column, Board, Stone),
    \+ check_piece_up(Row, Column, Board, Stone).

check_piece_exist(Row, Column, Board, Stone):-
    nth1_2d(Row, Column, Board, Stone),
    (Stone = b; Stone = w).

testing(Row, Column, BoardFileName, AboveStone):-
    load_board(BoardFileName, Board), % Board == board2darray
    NewRow is Row - 1,
    nth1_2d(NewRow, Column, Board, AboveStone).

% false if piece above is e or same as stonecolor
check_piece_up(Row, Column, Board, Stone):- % Stone == b
    NewRow is Row - 1,
    nth1_2d(NewRow, Column, Board, AboveStone), % AboveStone == e, true
    \+ ((AboveStone = Stone); AboveStone = e). % checking !(stone == abovestone || e == e), false
  % if any of the above is false,

% map_allies_around(Row, Column, Board, Stone):-
%     UpRow is Row - 1,
%     DownRow is Row + 1,
%     LeftColumn is Column -1,
%     RightColumn is Column + 1.

is_same_or_e(Stone, AboveStone):-
    \+ ((AboveStone = Stone); AboveStone = e).
