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
    Pid = spawn(fun() -> receive ok -> ok end end).
    monitor(Pid),
    {ok, Pid} = erlzk:connect([{"localhost", 2181}], 30000, [{chroot, "/test"},
                                                              {monitor, Pid}]).
