-module(emq_hook_sup).
-behaviour(supervisor).

-include("emq_hook.hrl").

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, Redis} = application:get_env(?APP, redis),
    RedisPoolSpec = ecpool:pool_spec(?APP, ?APP, emq_redis_cli, Redis),
    % {ok, Kafka} = application:get_env(?APP, kafka),
    % KafkaPoolSpec = ecpool:pool_spec(?APP, ?APP, emq_kafka_cli, Kafka),
    ClientConfig = [{reconnect_cool_down_seconds, 10}],
    KafkaSpec = brod:start_client([{"localhost", 9092}], brod_client_1, ClientConfig),
    Procs = [RedisPoolSpec, KafkaSpec],
    {ok, {{one_for_one, 10, 100}, Procs}}.
