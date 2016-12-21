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

    {ok, Pid} = erlzk:connect([{"172.16.129.226", 2181}], 30000),
    subscibe_watch(Pid),
    {ok, Pid}.

subscibe_watch(Pid) ->

    erlzk:get_data(Pid, "/test", spawn_link(add(Pid, node_data_changed, "/test"))),
    erlzk:get_children(Pid, "/test", spawn_link(add(Pid, node_children_changed, "/test"))).

add(Pid, node_data_changed, Path) ->
    receive
        {Event, Path} ->
            Path = "/test",
            Event = node_data_changed,
            io:format("node data changed"),
            erlzk:get_data(Pid, "/test", spawn_link(add(Pid, node_data_changed, Path)))
    end;
add(Pid, node_children_changed, Path) ->
    receive
        {Event, Path} ->
            Path = "/test",
            Event = node_data_changed,
            io:format("node child changed"),
            erlzk:get_data(Pid, "/test", spawn_link(add(Pid, node_children_changed, Path)))
    end.



monitor(Pid) ->
    _MonitorRef = erlang:monitor(process, Pid),
    receive
        Msg ->
            io:format("pid exit: ~p~n", [Msg])
    end.
