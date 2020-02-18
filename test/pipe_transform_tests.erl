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
                                  pipe(2)) =:= 3)
    ].
