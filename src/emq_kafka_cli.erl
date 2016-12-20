-module(emq_kafka_cli).

%-behaviour(ecpool_worker).

-include("emq_hook.hrl").

-include_lib("emqttd/include/emqttd.hrl").

-define(ENV(Key, Opts), proplists:get_value(Key, Opts)).

-export([start_link/0, monitor/1]).

%%--------------------------------------------------------------------
%% Kafka Connect/Produce
%%--------------------------------------------------------------------

start_link() ->
    io.format("start conncet zk"),
    P = spawn(fun() -> receive ok -> ok end end),
                                                %monitor(P),
    {ok, Pid} = erlzk:connect([{"172.16.129.226", 2181}], 30000, [{chroot, "/test"}, {monitor, P}]).

monitor(Pid) ->
    _MonitorRef = erlang:monitor(process, Pid),
    receive
        Msg ->
            io:format("pid exit: ~p~n", [Msg])
    end.
