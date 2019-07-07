%%% API module for the pool
-module(ppool).
-export([start/2, stop/0, start_pool/3,
         run/2, sync_queue/2, async_queue/2, stop_pool/1]).

start(normal, _Args) ->
  %% ppool_supersup:start_link().
  io:format("sraka").

stop() ->
  ok.

start_pool(Name, Limit, {M,F,A}) ->
  ppool_supersup:start_pool(Name, Limit, {M,F,A}).

stop_pool(Name) ->
  ppool_supersup:stop_pool(Name).

run(Name, Args) ->
  ppool_serv:run(Name, Args).

async_queue(Name, Args) ->
  ppool_serv:async_queue(Name, Args).

sync_queue(Name, Args) ->
  ppool_serv:sync_queue(Name, Args).

%% TEST:
%% $ erl -make
%% Recompile: src/ppool_worker_sup Recompile: src/ppool_supersup ... <snip> ...
%%
%% $ erl -pa ebin/
%% ... <snip> ...
%%
%% 1> make:all([load]).
%%   ... <snip> ...
%% 2> eunit:test(ppool_tests).
%%   All 14 tests passed.
%%   ok
%% 3> application:start(ppool).
%%   ok
%% 4> ppool:start_pool(nag, 2, {ppool_nagger, start_link, []}).
%%   {ok,<0.142.0>}
%% 5> ppool:run(nag, [make_ref(), 500, 10, self()]).
%%   {ok,<0.146.0>}
%% 6> ppool:run(nag, [make_ref(), 500, 10, self()]).
%%   {ok,<0.148.0>}
%% 7> ppool:run(nag, [make_ref(), 500, 10, self()]).
%%   noalloc
%% 9> flush().
%%   Shell got {<0.146.0>,#Ref<0.0.0.625>}
%%   Shell got {<0.148.0>,#Ref<0.0.0.632>}
%%   ... <snip> ...
%%   received down msg
%%   received down msg
%% 10> application:which_applications().
%%   [{ppool,[],"1.0.0"},
%%   {stdlib,"ERTS  CXC 138 10","1.17.4"},
%%   {kernel,"ERTS  CXC 138 10","2.14.4"}]
%% 11> application:stop(ppool).
%%   =INFO REPORT==== DD-MM-YYYY::23:14:50 ===
%%       application: ppool
%%       exited: stopped
%%       type: temporary
%%   ok
