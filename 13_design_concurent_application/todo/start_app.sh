# To compile the application:
erl -make

# To run the application:
erl -pa ebin/

# From the erlang shell type:
#
# 0> make:all([load]). %% Recompile and load new files from Emakefile
#
# 1> event_server:start().
# <0.34.0>
# 2> event_server:subscribe(self()).
# {ok,#Ref<0.0.0.31>}
# 3> event_server:add_event("Hey there", "test", FutureDateTime).
# ok
# 4> event_server:listen(5).
# []
# 5> event_server:cancel("Hey there").
# ok
# 6> event_server:add_event("Hey there2", "test", NextMinuteDateTime). ok
# 7> event_server:listen(2000).
# [{done,"Hey there2","test"}]

# After we add the supervisor to treck our processes
# we can start the application with next steps:
#
# 1> c(event_server), c(sup).
# {ok,sup}
# 2> SupPid = sup:start(event_server, []). <0.43.0>
# 3> whereis(event_server).
# <0.44.0>
# 4> exit(whereis(event_server), die).
# true
# Process <0.44.0> exited for reason die 5> exit(whereis(event_server), die).
# Process <0.48.0> exited for reason die true
# 6> exit(SupPid, shutdown).
# true
# 7> whereis(event_server).
# undefined
