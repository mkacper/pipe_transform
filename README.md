pipe_transform
=====

`pipe_transform` tries to bring Elixir pipe operator `|>` into Erlang
world. Instead of the operator `pipe_transform:pipe/X` function is
introduced. It works the same way the Elixir opertor does but intead of
using `|>` in the chain of functions we pass these functions as
consecutive arguments of the `pipe/X` function. See the next sections for
the examples.

## Examples

Consider the following Elixir module:

```elixir
defmodule Pipe do
    def pipe_example do
        1
        |> pipe1()
        |> pipe2()
        |> pipe3()
        |> ...
    end
end
```

In Erlang we could write similar code using `pipe_transfrom` as follows:

```erlang
-module(pipe).
-compile({parse_transform, pipe_transform}).
-define(p, pipe_transform:pipe)

pipe_example() ->
    ?p(1,
       pipe1(),
       pipe2(),
       pipe3(),
       ...).
```

Build
-----

    $ rebar3 compile
