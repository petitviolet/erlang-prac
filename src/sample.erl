-module(sample).

-export([add/2, f/2]).

add(0, 0) -> 0;
add(I, J) -> I + J.

f(0, 0) -> 1;
f(0, _) -> 2;
f(_, 0) -> 3;
f(I, _) when I rem 2 == 0, I rem 3 == 0 -> 4; % andalso
f(_, J) when J rem 2 == 0; J rem 3 == 0 -> 5; % orelse
% f(I, J) ->
%   case I + J of
%     10 -> 10;
%     11 -> 11;
%     N when N < 100 -> N;
%     _ -> 999
%   end.
f(I, J) ->
  if I + J =:= 10 -> 10;
     I + J =:= 10 -> 11;
     I + J < 100 -> I + J;
     true -> 999
  end.

