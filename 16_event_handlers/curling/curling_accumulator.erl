-module(curling_accumulator).
-behavior(gen_event).

-export([init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3,
terminate/2]).

-record(state, {teams=orddict:new(), round=0}).

init([]) -> {ok, #state{}}.

handle_event({set_teams, TeamA, TeamB}, S=#state{teams=T}) ->
  Teams = orddict:store(TeamA, 0, orddict:store(TeamB, 0, T)),
  {ok, S#state{teams=Teams}};
handle_event({add_points, Team, N}, S=#state{teams=T}) ->
  Teams = orddict:update_counter(Team, N, T),
  {ok, S#state{teams=Teams}};
handle_event(next_round, S=#state{}) ->
    {ok, S#state{round = S#state.round+1}};
handle_event(_Event, State=#state{}) ->
    {ok, State}.

handle_call(game_data, S=#state{teams=T, round=R}) ->
    {ok, {orddict:to_list(T), {round, R}}, S};
handle_call(_, State) ->
    {ok, ok, State}.

handle_info(_, State) -> {ok, State}.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

terminate(_Reason, _State) -> ok.

%% TEST:
%% 1> c(curling), c(curling_accumulator).
%%   {ok,curling_accumulator}
%% 2> {ok, Pid} = curling:start_link("Pigeons", "Eagles").
%%   Scoreboard: Team Pigeons vs. Team Eagles {ok,<0.242.0>}
%% 3> curling:add_points(Pid, "Pigeons", 2).
%%   Scoreboard: increased score of team Pigeons by 1
%%   ok
%%   Scoreboard: increased score of team Pigeons by 1
%% 4> curling:next_round(Pid).
%%   Scoreboard: round over
%%   ok
%% 5> curling:add_points(Pid, "Eagles", 3).
%%   Scoreboard: increased score of team Eagles by 1
%%   ok
%%   Scoreboard: increased score of team Eagles by 1
%%   Scoreboard: increased score of team Eagles by 1
%% 6> curling:next_round(Pid).
%%   Scoreboard: round over
%%   ok
%% 7> curling:game_info(Pid).
%%   {[{"Eagles",3},{"Pigeons",2}],{round,2}}
