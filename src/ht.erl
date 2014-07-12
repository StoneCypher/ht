
-module(ht).





-export( [

    stub/1,
      stub/2

] ).





-record(ht_options, {

} ).





stub(Proplist) when is_list(Proplist) ->

    stub(#ht_options{  });





stub(Proplist) when is_record(Proplist, ht_options) ->

    stub(#ht_options{  });





stub(Handler) when is_function(Handler) ->

    stub(#ht_options{  }).
