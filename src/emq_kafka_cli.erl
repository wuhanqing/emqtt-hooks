-module(emq_kafka_cli).

%-behaviour(ecpool_worker).

-include("emq_hook.hrl").

-include_lib("emqttd/include/emqttd.hrl").

-define(ENV(Key, Opts), proplists:get_value(Key, Opts)).

-export([init/0, monitor/1]).

%%--------------------------------------------------------------------
%% Kafka Connect/Produce
%%--------------------------------------------------------------------


monitor(Pid) ->
    _MonitorRef = erlang:monitor(process, Pid),
    receive
        Msg ->
            io:format("pid exit: ~p~n", [Msg])
    end.

init() ->
    P = spawn(fun() -> receive ok -> ok end end),
    monitor(P),
    {ok, Pid} = erlzk:connect([{"172.16.129.226", 2181}], 30000, [{chroot, "/test"},
                                                              {monitor, P}]).
