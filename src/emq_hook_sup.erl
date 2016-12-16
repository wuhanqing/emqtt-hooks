-module(emq_hook_sup).
-behaviour(supervisor).

-include("emq_hook.hrl").

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  {ok, Server} = application:get_env(?REDIS_APP, server),
  RedisPoolSpec = ecpool:pool_spec(?REDIS_APP, ?REDIS_APP, emq_redis_cli, Server),
  Procs = [RedisPoolSpec],
	{ok, {{one_for_one, 1, 5}, Procs}}.
