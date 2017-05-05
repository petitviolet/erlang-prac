-module(hoge).

-export([do/0, doMap/1, doDouble/0]).


do() -> sample:add(1, 2).

doMap(F) -> lists:map(F, [1, 2, 3]).

double(X) -> X * 2.

doDouble() -> lists:map(fun double/1, [1, 2, 3]).


