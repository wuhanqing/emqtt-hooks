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
    %P = spawn(fun() -> receive ok -> ok end end),
    %monitor(P),

    DataChangeWatch = spawn_link(fun() ->
        receive
            {Event, Path} ->
                Path = "/test",
                Event = node_data_changed,
                io:format("node data changed")
        end
    end),

    ChildrenDataChangeWatch = spawn_link(fun() ->
        receive
            {Event, Path} ->
                Path = "/test",
                Event = node_children_changed,
                 io:format("children changed")
        end
    end),

    {ok, Pid} = erlzk:connect([{"172.16.129.226", 2181}], 30000),
    erlzk:get_data(Pid, "/test", DataChangeWatch),
    erlzk:get_children(Pid, "/test", ChildrenDataChangeWatch),
    {ok, Pid}.

monitor(Pid) ->
    _MonitorRef = erlang:monitor(process, Pid),
    receive
        Msg ->
            io:format("pid exit: ~p~n", [Msg])
    end.
