%% coding: utf-8
%% app generated at {2019,6,22} {23,9,52}
{application,sockserv,
             [{description,"Socket server to forward ProcessQuest messages to a client"},
              {vsn,"1.0.1"},
              {id,[]},
              {modules,[sockserv,sockserv_pq_events,sockserv_serv,
                        sockserv_sup,sockserv_trans]},
              {registered,[sockserv_sup]},
              {applications,[stdlib,kernel,processquest]},
              {included_applications,[]},
              {env,[{port,8082}]},
              {maxT,infinity},
              {maxP,infinity},
              {mod,{sockserv,[]}}]}.

