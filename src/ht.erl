
%% @doc `ht' - a micro-webserver oriented towards programmer convenience and speed.  Descends from 
%% <a href="https://github.com/StoneCypher/htstub/">htstub</a> and 
%% <a href="https://gist.github.com/vinoski/4996859">Vinoski's gist</a>.  MIT licensed.

-module(ht).





-export( [

    stub/1,
      stub/2,

    default_handler/1

] ).





default_handler(_) ->

    <<"whargarbl todo">>.





-spec stub(Config :: function() | record() | list()) -> pid() | { error, any() }.

stub(Proplist) when is_list(Proplist) ->

    stub_serve( todo );





stub(Handler) when is_function(Handler) ->

    stub_serve( todo ).





-spec stub(Handler :: function(), Post :: integer()) -> pid() | { error, any() }.

stub(Handler, Port) when is_function(Handler), is_integer(Port), Port >= 0 ->

    stub_serve( todo ).





stub_serve(ConfigPL) when is_list(ConfigPL) -> 

    Handler = proplists:get_value(handler, ConfigPL, fun default_handler/1),
    Port    = proplists:get_value(port,    ConfigPL, 80),

    { whargarbl, todo, Handler, Port }.





start(Handler) ->
start(Handler, 8000).
start(Handler, Port) ->
{ok, LS} = gen_tcp:listen(Port, [{reuseaddr,true},binary,{backlog,1024}]),
spawn(fun() -> accept(LS, Handler) end),
receive stop -> gen_tcp:close(LS) end.
 
%% The accept/2 function accepts a connection, spawns a new acceptor, and
%% then handles its incoming request.
accept(LS, Handler) ->
{ok, S} = gen_tcp:accept(LS),
ok = inet:setopts(S, [{packet,http_bin}]),
spawn(fun() -> accept(LS, Handler) end),
serve(S, Handler, [{headers, []}]).
 
%% The serve/3 function reads the request headers, assembles the request
%% data property list, calls the handler/2 function to handle the request,
%% and assembles and returns the response.
serve(S, Handler, Req) ->
ok = inet:setopts(S, [{active, once}]),
HttpMsg = receive
{http, S, Msg} -> Msg;
_ -> gen_tcp:close(S)
end,
case HttpMsg of
{http_request, M, {abs_path, Uri}, Vsn} ->
NReq = [{method,M},{uri,Uri},{version,Vsn}|Req],
serve(S, Handler, NReq);
{http_header, _, Hdr, _, Val} ->
{headers, Hdrs} = lists:keyfind(headers, 1, Req),
serve(S, Handler, lists:keystore(headers, 1, Req,
{headers, [{Hdr,Val}|Hdrs]}));
http_eoh ->
ok = inet:setopts(S, [{packet, raw}]),
{Status, Hdrs, Resp} = try Handler(S, Req) catch _:_ -> {500, [], <<>>} end,
ok = gen_tcp:send(S, ["HTTP/1.0 ", integer_to_list(Status), "\r\n",
[[H, ": ", V, "\r\n"] || {H,V} <- Hdrs],
"\r\n", Resp]),
gen_tcp:close(S);
{http_error, Error} ->
exit(Error);
ok -> ok
end.