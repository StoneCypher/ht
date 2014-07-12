
-module(ht).





-export( [

    stub/1,
      stub/2

] ).





-record(ht_options, {

} ).





-spec stub(Config :: function() | record() | list()) -> pid() | { error, any() }.

stub(Proplist) when is_list(Proplist) ->

    stub(#ht_options{  });





stub(Proplist) when is_record(Proplist, ht_options) ->

    stub(#ht_options{  });





stub(Handler) when is_function(Handler) ->

    stub(#ht_options{  }).





-spec stub(Handler :: function(), Post :: integer()) -> pid() | { error, any() }.

stub(Handler, Port) when is_function(Handler), is_integer(Port), Port >= 0 ->

    stub(#ht_options{  }).
