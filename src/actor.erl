-module(actor).

% -export([ops/0, ]).

-compile(export_all).

ops() ->
  receive
    {From, {I, J, Ops}} ->
      From ! ops(I, J, Ops),
      ops();
    {I, J, Ops} ->
      io:format("received ~p, ~p, ~p~n", [I, J, Ops]),
      ops();
    hello ->
      io:format("hello actor~n"),
      ops();
    _ ->
      io:format("unknown...~n")
  end.

ops(I, J, plus) -> I + J;
ops(I, J, minus) -> I - J.

bank() -> bank(0).

bank(Current) ->
  receive
    {From, {add, Amount}} ->
      From ! {self(), ok},
      bank(Current + Amount);
    {From, {sub, Amount}} when Current >= Amount ->
      From ! {self(), ok},
      bank(Current - Amount);
    {From, {sub, Amount}} when Current < Amount ->
      From ! {self(), fail},
      bank(0);
    show ->
      io:format("current: ~p~n", [Current]),
      bank(Current);
    {From, finish} ->
      From ! Current,
      ok
  after 1 -> timeout
  end.

%% public APIs
create() -> spawn(fun bank/0).

store(Pid, Amount) ->
  Pid ! {self(), {add, Amount}},
  receive
    {_, Msg} -> Msg
  end.

withdraw(Pid, Amount) ->
  Pid ! {self(), {sub, Amount}},
  receive
    {_, Msg} -> Msg
  end.

show(Pid) -> Pid ! show.

%%
partition(E, F) -> partition(E, F, {[], []}).

partition([], _, R) -> R;
partition([H|T], F, {Ok, Ng}) ->
  check(self(), H, F),
  receive
    true -> partition(T, F, {[H|Ok], Ng});
    false -> partition(T, F, {Ok, [H|Ng]})
  after 0 -> {Ok, Ng}
  end.


check(Pid, E, F) ->
  Pid ! F(E).
