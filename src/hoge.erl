-module(hoge).

-export([do/0, doMap/1, doDouble/0, tryF/1]).

do() -> sample:add(1, 2).

doMap(F) -> lists:map(F, [1, 2, 3]).

double(X) -> X * 2.

doDouble() -> lists:map(fun double/1, [1, 2, 3]).

tryF(F) ->
  try(F()) of
    true -> yes;
    _ -> no
  catch
    throw: Throw -> {caught_throw, Throw};
    error: Error -> {caught_error, Error};
    exit: Exit -> {caught_exit, Exit}
  end.


