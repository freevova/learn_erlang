-module(erlcount).
-behavior(application).

-export([start/2, stop/1]).

start(normal, _Args) ->
  erlcount_sup:start_link().
stop(_State) ->
  ok.

%% TEST:
%% $ erl -env ERL_LIBS "."
%% 1> application:load(ppool).
%%   ok
%% 2> application:start(ppool), application:start(erlcount).
%%   ok
%%   Regex if\s.+-> has 20 results
%%   Regex case\s.+\sof has 26 results
%%  erl -env ERL_LIBS "." -erlcount directory '"/home/ferd/otp_src_R15B01/lib/"' regex '["shit","damn"]'
