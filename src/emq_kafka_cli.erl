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
    io:format("start conncet zk"),
    P = spawn(fun() -> receive ok -> ok end end),
    %monitor(P),

    ChangeWatch = spawn(fun() ->
        receive
            {Event, Path} ->
                Path = "/test",
                Event = node_children_changed,
                io:format("node changed")
    end)

    {ok, Pid} = erlzk:connect([{"172.16.129.226", 2181}], 30000, [{chroot, "/test"}, {monitor, P}]),
    erlzk:get_data(Pid, "/test", ChangeWatch).

monitor(Pid) ->
    _MonitorRef = erlang:monitor(process, Pid),
    receive
        Msg ->
            io:format("pid exit: ~p~n", [Msg])
    end.
