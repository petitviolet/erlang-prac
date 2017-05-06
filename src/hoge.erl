-module(hoge).

-export([do/0, doMap/1, doDouble/0, tryF/1, tryF2/1]).

do() -> sample:add(1, 2).

doMap(F) -> lists:map(F, [1, 2, 3]).

double(X) -> X * 2.

doDouble() -> lists:map(fun double/1, [1, 2, 3]).

tryF(F) ->
  try(F())
  of
    true -> yes;
    false -> no;
    _ -> unknown
  catch
    throw: Throw -> {caught_throw, Throw};
    error: Error -> {caught_error, Error};
    exit: Exit -> {caught_exit, Exit}
    % Exception: Reason -> {caught_exception, Exception, Reason} % catch anything
  after
    % in other langhage, `finally`
    io:format("after!!!~n")
  end.

tryF2(F) ->
  try(F())
  catch
    Exception: Reason ->
      io:format("StackTrace~n~p~n", [erlang:get_stacktrace()]),
      {caught_exception, Exception, Reason} % catch anything
  end.

