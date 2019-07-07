-module(multiproc).
-compile(export_all).

sleep(T) ->
  receive
  after T -> ok
  end.

flush() ->
  receive
    _ -> flush()
  after 0 -> ok
  end.

important() ->
  receive
    {Priority, Message} when Priority > 10 ->
      [Message | important()]
  after 0 ->
    normal()
  end.

normal() ->
  receive
    {_, Message} ->
      [Message | normal()]
  after 0 ->
    []
  end.

%% c(multiproc).
%% self() ! {15, high}, self() ! {7, low}, self() ! {1, low}, self() ! {17, high}.
%% multiproc:important().
