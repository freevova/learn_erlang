# MAKE RELEASE:
1> {ok, Conf} = file:consult("processquest-1.0.0.config"),
1> {ok, Spec} = reltool:get_target_spec(Conf),
1> reltool:eval_target_spec(Spec, code:root_dir(), "rel").
  ok

./rel/bin/erl -sockserv port 8888

erl -env ERL_LIBS apps/ -pa apps/processquest-1.0.0/ebin/ -pa apps/sockserv-1.0.0/ebin/

# MAKE RELUP FILE:
1> systools:make_relup("./rel/releases/1.1.0/processquest-1.1.0",
1> ["rel/releases/1.0.0/processquest-1.0.0"],
1> ["rel/releases/1.0.0/processquest-1.0.0"]).
  ok

2> systools:make_tar("rel/releases/1.1.0/processquest-1.1.0").
  ok
$ mv rel/releases/1.1.0/processquest-1.1.0.tar.gz rel/releases/

# TO HAVE ABILITY TO ROLLBACK TO PREVIOUS VERSION:
1> release_handler:create_RELEASES( "rel",
  "rel/releases", "rel/releases/1.0.0/processquest-1.0.0.rel", [{kernel,"2.14.4", "rel/lib"}, {stdlib,"1.17.4","rel/lib"},
  {crypto,"2.0.3","rel/lib"},{regis,"1.0.0", "rel/lib"}, {processquest,"1.0.0","rel/lib"},{sockserv,"1.0.0", "rel/lib"}, {sasl,"2.1.9.4", "rel/lib"}]
  ).

# TO START RELEASE:
./rel/bin/erl -boot rel/releases/1.0.0/processquest

1> release_handler:unpack_release("processquest-1.1.0"). {ok,"1.1.0"}
2> release_handler:which_releases(). [{"processquest","1.1.0",
  ["kernel-2.14.4","stdlib-1.17.4","crypto-2.0.3",
   "regis-1.0.0","processquest-1.1.0","sockserv-1.0.1",
   "sasl-2.1.9.4"],
  unpacked},
 {"processquest","1.0.0",
  ["kernel-2.14.4","stdlib-1.17.4","crypto-2.0.3",
   "regis-1.0.0","processquest-1.0.0","sockserv-1.0.0",
   "sasl-2.1.9.4"],
permanent}]
3> release_handler:install_release("1.1.0").
{ok,"1.0.0",[]}
4> release_handler:which_releases().
[{"processquest","1.1.0",
  ["kernel-2.14.4","stdlib-1.17.4","crypto-2.0.3",
   "regis-1.0.0","processquest-1.1.0","sockserv-1.0.1",
   "sasl-2.1.9.4"],
  current},
 {"processquest","1.0.0",
  ["kernel-2.14.4","stdlib-1.17.4","crypto-2.0.3",
   "regis-1.0.0","processquest-1.0.0","sockserv-1.0.0",
   "sasl-2.1.9.4"],
permanent}]
5> release_handler:make_permanent("1.1.0").
ok.
6> supervisor:which_children(sockserv_sup). [{undefined,<0.51.0>,worker,[sockserv_serv]}]
7> [sockserv_sup:start_socket() || _ <- lists:seq(1,20)]. [{ok,<0.99.0>},
 {ok,<0.100.0>},
 ... <snip> ...
 {ok,<0.117.0>},
 {ok,<0.118.0>}]
8> supervisor:which_children(sockserv_sup). [{undefined,<0.112.0>,worker,[sockserv_serv]}, {undefined,<0.113.0>,worker,[sockserv_serv]},
 ... <snip> ...
 {undefined,<0.109.0>,worker,[sockserv_serv]},
 {undefined,<0.110.0>,worker,[sockserv_serv]},
 {undefined,<0.111.0>,worker,[sockserv_serv]}]
