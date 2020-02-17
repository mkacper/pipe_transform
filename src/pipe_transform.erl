-module(pipe_transform).
-export([parse_transform/2]).

parse_transform(Ast, _Opt) ->
    [parse(A) || A <- Ast].

% Helpers

parse({function, Line, FunName, ArgNum, Clause}) ->
    {function, Line, FunName, ArgNum, [parse(X) || X <- Clause]};

parse({clause, Line, Vars, Gaurd, ExprCalls}) ->
    {clause, Line, Vars, Gaurd, parse(ExprCalls)};

parse([{call, _, {remote, _, {atom, _, pipe_transform}, {atom, _, pipe}}, [{Type, _, Val} | PipedCalls]}]) ->
    [lists:foldl(fun(CCall, {}) ->
                     NewArgs = [{Type, 0, Val} | element(size(CCall), CCall)],
                     replace_args_for_call(CCall, NewArgs);
                    (CCall, ArgCall) ->
                     replace_args_for_call(CCall, [ArgCall | element(size(CCall), CCall)])
                end, {}, PipedCalls)];

parse(X) -> X.

replace_args_for_call(Call, Args) ->
    list_to_tuple(lists:droplast(tuple_to_list(Call)) ++ [Args]).
