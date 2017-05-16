#!/usr/bin/env escript

%% escript app.erl target.txt

-module(app).
-import(sample,[read_lines/1]).
% -export([main/1]).

main(Args) ->
  [File] = Args,
  io:format("~p~n", [sample:read_lines(File)]),
  erlang:halt().

