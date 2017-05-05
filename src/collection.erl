-module(collection).

-export([filter/2, reverse/1, foldLeft/3, sum/1]).
-import(sample, [add/2]).

filter(F, Seq) -> reverse(filter(F, Seq, [])).

filter(_, [], Acc) -> Acc;
filter(F, [H|T], Acc) ->
  case F(H) of
    true -> filter(F, T, [H|Acc]);
    false -> filter(F, T, Acc)
  end.

reverse(Seq) -> reverse(Seq, []).

reverse([], Acc) -> Acc;
reverse([H|T], Acc) -> reverse(T, [H|Acc]).

foldLeft(_, [], Acc) -> Acc;
foldLeft(F, [H|T], Acc) -> foldLeft(F, T, F(Acc, H)).

sum(Seq) -> foldLeft(fun sample:add/2, Seq, 0).
