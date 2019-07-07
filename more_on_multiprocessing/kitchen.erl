-module(kitchen).
-compile(export_all).

fridge1() ->
  receive
    {From, {store, _Food}} ->
      From ! {self(), ok},
      fridge1();
    {From, {take, _Food}} ->
      From ! {self(), not_found},
      fridge1();
    terminate ->
      ok
  end.

fridge2(FoodList) ->
  receive
    {From, {store, Food}} ->
      From ! {self(), ok},
      fridge2([Food|FoodList]);
    {From, {take, Food}} ->
      case lists:member(Food, FoodList) of
        true ->
          From ! {self(), {ok, Food}},
          fridge2(lists:delete(Food, FoodList));
        false ->
          From ! {self(), not_found},
          fridge2(FoodList)
      end;
    terminate ->
      ok
  end.

%% c(kitchen).
%% Pid = spawn(kitchen, fridge2, [[baking_soda]]).
%% Pid ! {self(), {store, milk}}.
%% flush().
%% Pid ! {self(), {take, bacon}}.
%% Pid ! {self(), {take, turkey}}.
%% flush().

%% We can use client API:
store(Pid, Food) ->
  Pid ! {self(), {store, Food}},
  receive
    {Pid, Msg} -> Msg
  after 3000 ->
    timeout
  end.

take(Pid, Food) ->
  Pid ! {self(), {take, Food}},
  receive
    {Pid, Msg} -> Msg
  after 3000 ->
    timeout
  end.

start(FoodList) ->
  spawn(?MODULE, fridge2, [FoodList]).
%% Pid = kitchen:start([rhubarb, dog, hotdog]).
%% kitchen:store(Pid, water).
%% kitchen:take(Pid, water).
