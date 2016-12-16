-module(emq_hook_app).
-behaviour(application).

-include("emq_hook.hrl").

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	{ok, Sup} = emq_hook_sup:start_link(),
  emq_hook:load(application:get_all_env()),
  {ok, Sup}.
stop(_State) ->
	emq_hook:unload().
