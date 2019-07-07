1> {ok, ListenSocket} = gen_tcp:listen(8091, [{active,true}, binary]).
  {ok,#Port<0.661>}
2> {ok, AcceptSocket} = gen_tcp:accept(ListenSocket, 2000).
  ** exception error: no match of right hand side value {error,timeout}
3> {ok, AcceptSocket} = gen_tcp:accept(ListenSocket).
  ** exception error: no match of right hand side value {error,closed}


4> f().
  ok
5> {ok, ListenSocket} = gen_tcp:listen(8091, [{active, true}, binary]).
  {ok,#Port<0.728>}
6> {ok, AcceptSocket} = gen_tcp:accept(ListenSocket).

# FROM THE SECONS SHELL:
1> {ok, Socket} = gen_tcp:connect({127,0,0,1}, 8091, [binary, {active,true}]).
  {ok,#Port<0.596>}
3> gen_tcp:send(Socket, "Hey there first shell!").
  ok

