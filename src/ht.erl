
%% @doc `ht' - a micro-webserver oriented towards programmer convenience and speed.  Descends from 
%% <a href="https://github.com/StoneCypher/htstub/">htstub</a> and 
%% <a href="https://gist.github.com/vinoski/4996859">Vinoski's gist</a>.  MIT licensed.

-module(ht).





-export( [

    stub/1,
      stub/2

] ).





-spec stub(Config :: function() | record() | list()) -> pid() | { error, any() }.

stub(Proplist) when is_list(Proplist) ->

    stub_serve( todo );





stub(Handler) when is_function(Handler) ->

    stub_serve( todo ).





-spec stub(Handler :: function(), Post :: integer()) -> pid() | { error, any() }.

stub(Handler, Port) when is_function(Handler), is_integer(Port), Port >= 0 ->

    stub_serve( todo ).





stub_serve(_) -> 

    { whargarbl, todo }.