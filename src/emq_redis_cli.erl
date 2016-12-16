-module(emq_redis_cli).

-behaviour(ecpool_worker).

-include("emq_hook.hrl").

-include_lib("emqttd/include/emqttd.hrl").

-define(ENV(Key, Opts), proplists:get_value(Key, Opts)).

-export([connect/1, set/2, get/1]).

%%--------------------------------------------------------------------
%% Redis Connect/Query
%%--------------------------------------------------------------------

connect(Opts) ->
    eredis:start_link(?ENV(host, Opts),
                      ?ENV(port, Opts),
                      ?ENV(database, Opts),
                      ?ENV(password, Opts),
                      no_reconnect).

%% Redis Query.
-spec(set(string(), string()) -> {ok, undefined | binary() | list()} | {error, atom() | binary()}).
set(Key, Value) ->
    ecpool:with_client(?APP, fun(C) -> eredis:q(C, ["SET", Key, Value]) end).

-spec(get(string()) -> {ok, undefined | binary() | list()} | {error, atom() | binary()}).
get(Key) ->
    ecpool:with_client(?APP, fun(C) -> eredis:q(C, ["GET", Key]) end).
