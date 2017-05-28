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

% accumulate messages in Mailbox
acc() -> lists:reverse(acc([])).
acc(Acc) ->
  receive
    done ->
      Acc;
    Msg ->
      % io:format("receive: ~w~n", [Msg]),
      acc([Msg|Acc])
  end.

% bank account state
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

%% bank public APIs
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

%% partitioning elements using actor
partition(E, F) -> partition(E, F, {[], []}).
%%% internal
partition([], _, R) -> R;
partition([H|T], F, {Ok, Ng}) ->
  self() ! F(H),
  receive
    true -> partition(T, F, {[H|Ok], Ng});
    false -> partition(T, F, {Ok, [H|Ng]})
  after 0 -> {Ok, Ng}
  end.

%% partitioning elements using actor with selective receive
p(E, F) ->
  {ok, Pid} = part(self()),
  ok = p(E, F, Pid),
  acc().

%%% internal
p([], _, _) -> ok;
p([H|T], F, Pid) ->
  Pid ! {F(H), H},
  p(T, F, Pid).

part(From) ->
  {ok, spawn(actor, positive, [From])}.

%%% receive messages which satisfy condition
positive(From) ->
  receive
    {true, Msg} ->
      % io:format("positive msg: ~w~n", [Msg]),
      From ! Msg,
      positive(From)
  after
    0 -> negative(From)
  end.

%%% receive messages which do not satisfy condition
negative(From) ->
  receive
    {false, Msg} ->
      % io:format("negative msg: ~w~n", [Msg]),
      From ! Msg,
      negative(From)
  after
    0 -> From ! done
  end.


%%% link each process
countdown(0) ->
  io:format("FINISH"),
  exit(countdown_finish);
countdown(I) ->
  process_flag(trap_exit, true),
  io:format("now: ~p~n", [I]),
  timer:sleep(1000),
  % spawn_link(fun() -> countdown(I - 1) end),
  spawn_link(?MODULE, countdown, [I - 1]),
  % link(Next),0
  receive
    _ -> ok
  end.

