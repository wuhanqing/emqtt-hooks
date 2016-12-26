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
    ZkSpec = {erlzk, {emq_zk_cli, start_link, []}, permanent, brutal_kill, worker, [emq_kafka_cli]},
    Procs = [ZkSpec],
    {ok, {{one_for_one, 1, 10}, Procs}}.
