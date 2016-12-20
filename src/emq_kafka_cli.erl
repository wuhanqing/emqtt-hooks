-module(emq_kafka_cli).

-behaviour(ecpool_worker).

-include("emq_hook.hrl").

-include_lib("emqttd/include/emqttd.hrl").

-define(ENV(Key, Opts), proplists:get_value(Key, Opts)).

-export([init/0]).

%%--------------------------------------------------------------------
%% Kafka Connect/Produce
%%--------------------------------------------------------------------

init() ->
    application:load(ekaf),
    application:set_env(ekaf, ekaf_bootstrap_broker, {"localhost", 9091}),
    {ok, _} = application:ensure_all_started(ekaf),
    Topic = <<"ekaf">>,
    ekaf:produc_async(Topic, [<<"foo">>, {<<"key">>, <<"value">>}, <<"back_to_binary">> ]),
