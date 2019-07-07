-module(curling_scoreboard).
-behavior(gen_event).
-export([init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3,
terminate/2]).

init([]) ->
  {ok, []}.

handle_event({set_teams, TeamA, TeamB}, State) ->
  curling_scoreboard_hw:set_teams(TeamA, TeamB),
  {ok, State};

handle_event({add_points, Team, N}, State) ->
  [curling_scoreboard_hw:add_point(Team) || _ <- lists:seq(1,N)],
  {ok, State};

handle_event(next_round, State) ->
  curling_scoreboard_hw:next_round(),
  {ok, State};

handle_event(_, State) ->
  {ok, State}.

handle_call(_, State) ->
  {ok, ok, State}.

handle_info(_, State) ->
  {ok, State}.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

terminate(_Reason, _State) -> ok.

%% TEST
%% 1> c(curling_scoreboard_hw).
%%   {ok,curling_scoreboard_hw}
%% 2> c(curling_scoreboard).
%%   {ok,curling_scoreboard}
%% 3> {ok, Pid} = gen_event:start_link().
%%   {ok,<0.43.0>}
%% 4> gen_event:add_handler(Pid, curling_scoreboard, []).
%%   ok
%% 5> gen_event:notify(Pid, {set_teams, "Pirates", "Scotsmen"}).
%%   Scoreboard: Team Pirates vs. Team Scotsmen
%%   ok
%% 6> gen_event:notify(Pid, {add_points, "Pirates", 3}).
%%   ok
%%   Scoreboard: increased score of team Pirates by 1
%%   Scoreboard: increased score of team Pirates by 1
%%   Scoreboard: increased score of team Pirates by 1
%% 7> gen_event:notify(Pid, next_round).
%%   Scoreboard: round over
%%   ok
%% 8> gen_event:delete_handler(Pid, curling_scoreboard, turn_off).
%%   ok
%% 9> gen_event:notify(Pid, next_round).
%%   ok
