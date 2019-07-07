-module(erlcount).
-behavior(application).

-export([start/2, stop/1]).

start(normal, _Args) ->
  erlcount_sup:start_link().
stop(_State) ->
  ok.

%% RELESES WITH SYSTOOL TEST:
%% $ erl -env ERL_LIBS .
%%   ... <snip> ...
%% 1> systools:make_script("erlcount-1.0", [local]).
%%   ok
%% 2> systools:make_tar("erlcount-1.0", [{erts, "/Users/volodymyrgula/.asdf/installs/erlang/21.1/"}]).
%%   ok.
%% $ ./erts-10.1/bin/erl -boot releases/1.0.0/start
%% OR
%% $ ./erts-10.1/bin/erl -boot releases/1.0.0/start -erlcount directory '"/home/ferd/code/otp_src_R14B03/"' -noshell
%%
%%
%% RELESES WITH RELTOOL TEST:
%% 1> {ok, Conf} = file:consult("erlcount-1.0.config").
%%   {ok,[{sys,[{lib_dirs,["/home/ferd/code/learn-you-some-erlang/release/"]},
%%     {rel,"erlcount","1.0.0",
%%       [kernel,stdlib,{ppool,permanent},{erlcount,transient}]},
%%     {boot_rel,"erlcount"}]}]}
%% 2> {ok, Spec} = reltool:get_target_spec(Conf).
%%   {ok,[{create_dir,"releases",
%%   ... <snip> ...
%% 3> reltool:eval_target_spec(Spec, code:root_dir(), "rel").
%%   ok
%%  cd rel && .bin/erl -noshell
