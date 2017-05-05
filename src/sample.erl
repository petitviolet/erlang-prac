-module(sample).

-export([add/2]).

add(0, 0) -> 0;
add(I, J) -> I + J.
