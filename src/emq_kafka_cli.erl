-module(emq_kafka_cli).

-behaviour(ecpool_worker).

-include("emq_hook.hrl").

-include_lib("emqttd/include/emqttd.hrl").

-define(ENV(Key, Opts), proplists:get_value(Key, Opts)).

%-export([produce/4]).

%%--------------------------------------------------------------------
%% Kafka Connect/Produce
%%--------------------------------------------------------------------

%% Redis Query.
%-spec(produce(client(), topic(), key(), value()) -> {ok, brod_call_ref()} | {error, any()}).
%produce(Client, Topic, Key, Value) ->
%    PartitionFun = fun(_Topic, PartitionsCount, _Key, _Value) ->
%                           {ok, crypto:rand_uniform(0, PartitionsCount)}
%                   end,
%    {ok, CallRef} = brod:produce(Client, Topic, PartitionFun, Key, Value).
