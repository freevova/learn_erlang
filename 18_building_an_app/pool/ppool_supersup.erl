 -module(ppool_supersup).
 -behavior(supervisor).

 -export([start_link/0, stop/0, start_pool/3, stop_pool/1]).
 -export([init/1]).

start_link() ->
  supervisor:start_link({local, ppool}, ?MODULE, []).

%% Technically, a supervisor cannot be killed in an easy way.
%% Let's do it brutally!
stop() ->
  case whereis(ppool) of
    P when is_pid(P) ->
      exit(P, kill);
    _ -> ok
end.

start_pool(Name, Limit, MFA) ->
  ChildSpec = {Name,
               {ppool_sup, start_link, [Name, Limit, MFA]},
               permanent, 10500, supervisor, [ppool_sup]},
  supervisor:start_child(ppool, ChildSpec).

stop_pool(Name) ->
  supervisor:terminate_child(ppool, Name),
  supervisor:delete_child(ppool, Name).

init([]) ->
  MaxRestart = 6,
  MaxTime = 3600,
  {ok, {{one_for_one, MaxRestart, MaxTime}, []}}.


%% TEST:
%% $ erlc *.erl
%% $ erl
%% ... <snip> ...
%% 1> ppool:start_link().
%%   {ok,<0.33.0>}
%% 2> ppool:start_pool(nagger, 2, {ppool_nagger, start_link, []}).
%%   {ok,<0.35.0>}
%% 3> ppool:run(nagger, ["finish the chapter!", 10000, 10, self()]).
%%   {ok,<0.39.0>}
%% 4> ppool:run(nagger, ["Watch a good movie", 10000, 10, self()]).
%%   {ok,<0.41.0>}
%% 5> flush().
%%   Shell got {<0.39.0>,"finish the chapter!"}
%%   Shell got {<0.39.0>,"finish the chapter!"}
%%   ok
%% 6> ppool:run(nagger, ["clean up a bit", 10000, 10, self()]).
%%   noalloc
%% 7> flush().
%%   Shell got {<0.41.0>,"Watch a good movie"}
%%   Shell got {<0.39.0>,"finish the chapter!"}
%%   Shell got {<0.41.0>,"Watch a good movie"}
%%   Shell got {<0.39.0>,"finish the chapter!"}
%%   Shell got {<0.41.0>,"Watch a good movie"}
%%   ... <snip> ...
