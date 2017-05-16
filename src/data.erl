-module(record).
% -export([create_user/3]).
-compile(export_all).

-record(user, {id, name, status, address = ""}).

create_user(Id, Name, Address) ->
  #user{id = Id, name = Name, status = active, address = Address }.

id(User) -> User#user.id.
name(User) -> User#user.name.

hello(#user{status = active}) -> "active";
hello(#user{status = paused}) -> "paused".

