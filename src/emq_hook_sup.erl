-module(emq_hook_sup).
-behaviour(supervisor).

-include("emq_hook.hrl").

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  {ok, Server} = application:get_env(?APP, server),
  RedisPoolSpec = ecpool:pool_spec(?APP, ?APP, emq_redis_cli, Server),
  Procs = [RedisPoolSpec],
	{ok, {{one_for_one, 10, 100}, Procs}}.
