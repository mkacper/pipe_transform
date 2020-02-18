-module(pipe_transform_tests).
-compile({parse_transform, pipe_transform}).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

pipe(X) -> X.

pipe(X, Y) -> X + Y.

pipe_rand(X) -> rand:uniform(X).

pipe_test_() ->
    [
     ?_assert(pipe_transform:pipe(1,
                                  pipe(),
                                  pipe()) =:= 1),
     ?_assert(pipe_transform:pipe(1,
                                  pipe(1),
                                  pipe(2)) =:= 4),
     ?_assert(pipe_transform:pipe(1,
                                  pipe(9),
                                  rand:uniform()) =< 10),
     fun() ->
        A = 1,
        ?assert(pipe_transform:pipe(A,
                                    pipe(),
                                    pipe()) =:= 1)
     end,
     fun() ->
        A = 1,
        B = pipe_transform:pipe(A,
                                pipe(),
                                pipe()),
        ?assert(B =:= 1)
     end
    ].
