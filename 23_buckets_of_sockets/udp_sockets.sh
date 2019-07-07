1> {ok, Socket} = gen_udp:open(8789, [binary, {active,true}]).
  {ok,#Port<0.676>}
2> gen_udp:open(8789, [binary, {active,true}]).
  {error,eaddrinuse}

# FROM THE NEW SHELL:
1> {ok, Socket} = gen_udp:open(8790).
  {ok,#Port<0.587>}
2> gen_udp:send(Socket, {127,0,0,1}, 8789, "hey there!").
  ok

3> flush().
  Shell got {udp,#Port<0.676>,{127,0,0,1},8790,<<"hey there!">>}
  ok

# FOR THE PASSIVE MODE:
4> gen_udp:close(Socket).
  ok
5> f(Socket).
  ok
6> {ok, Socket} = gen_udp:open(8789, [binary, {active,false}]).
  {ok,#Port<0.683>}
7> gen_udp:recv(Socket, 0).

3> gen_udp:send(Socket, {127,0,0,1}, 8789, "hey there!").
  ok
