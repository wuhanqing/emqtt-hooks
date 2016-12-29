%%%-------------------------------------------------------------------
%%% @author 吴汗青 <wuhanqing@wuhanqingdeMacBook-Pro.local>
%%% @copyright (C) 2016, 吴汗青
%%% @doc
%%%
%%% @end
%%% Created : 21 Dec 2016 by 吴汗青 <wuhanqing@wuhanqingdeMacBook-Pro.local>
%%%-------------------------------------------------------------------
-module(emq_zk_cli).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3, getNodes/1]).

-define(SERVER, ?MODULE).

-record(state, {conn,
               worker = []}).

getNodes(htcf) -> gen_server:call(?MODULE, worker).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% erlzk:create(Conn, "/test1"),@spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    process_flag(trap_exit, true),
    io:format("start conncet zk"),
    {ok, Pid} = erlzk:connect([{"127.0.0.1", 2181}], 30000),
    io:format("Pid: ~p~n", [Pid]),
    Path = list_to_binary("/htcf/im/worker"),
    {ok, Children} = getChildren(node_children_changed, Path, Pid),
    {ok, #state{conn = Pid, worker = Children}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call({node_children_changed, htcf, Path}, _From, #state{conn=Conn}=State) ->
    {ok, Children} = getChildren(node_children_changed, Path, Conn),
    Reply = {ok, Children},
    NewState = State#state{worker=Children},
    {reply, Reply, NewState};

handle_call(worker, _From, #state{worker=Worker}=State) -> {reply, Worker, State}. 

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} 
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @endemq
%%--------------------------------------------------------------------
handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
getChildren(node_children_changed, Path, Conn) ->
    DataChangeWatch = spawn(fun() ->
        receive
            {Event, Path} ->
            gen_server:call(?MODULE, {node_children_changed, htcf, Path}),
            io:format("node changed ~s ~n", [Event])
        end
    end),
    io:format("watcher: ~p~n", [DataChangeWatch]),
    {ok, Children} = erlzk:get_children(Conn, Path, DataChangeWatch),
    io:format("children : ~s~n", [Children]),
    {ok, Children}.
