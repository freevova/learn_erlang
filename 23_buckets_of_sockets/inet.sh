1> {ok, Listen} = gen_tcp:listen(8088, [{active,false}]).
  {ok,#Port<0.597>}
2> {ok, Accept} = gen_tcp:accept(Listen).

# FROM THE SECOND SHELL:
1> {ok, Socket} = gen_tcp:connect({127,0,0,1}, 8088, []).
  {ok,#Port<0.596>}
2> gen_tcp:send(Socket, "hey there").
  ok

FROM THE FIRST:
4> inet:setopts(Accept, [{active, true}]).
  ok
5> flush().
  Shell got {tcp,#Port<0.598>,"hey there"}
  ok

# ACTIVE ONCE MODE:
6> inet:setopts(Accept, [{active, once}]).
  ok

# FROM CLIENT SHELL:
3> gen_tcp:send(Socket, "one").
  ok
4> gen_tcp:send(Socket, "two").
  ok

# FROM SERVER SHELL:
7> flush().
  Shell got {tcp,#Port<0.598>,"one"}
  ok
8> flush().
  ok
9> inet:setopts(Accept, [{active, once}]).
  ok
10> flush().
  Shell got {tcp,#Port<0.598>,"two"}
  ok
