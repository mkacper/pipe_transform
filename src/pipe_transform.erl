-module(pipe_transform).
-export([parse_transform/2]).

parse_transform(Forms, _Opt) ->
    %io:format ("AST: ~p~n", [Forms]),
    NewForms = parse_trans:plain_transform(fun do_transform/1,  Forms),
    %io:format("NewAST: ~p~n", [NewForms]),
    NewForms.

% Parsing

do_transform({call, _, {remote, _, {atom, _, pipe_transform}, {atom, _, pipe}}, [{Type, _, Val} | PipedCalls]}) ->
    lists:foldl(fun(Call, {}) ->
                    NewArgs = [{Type, 0, Val} | element(size(Call), Call)],
                    replace_args_for_call(Call, NewArgs);
                   (Call, ArgsCall) ->
                    replace_args_for_call(Call, [ArgsCall | element(size(Call), Call)])
                end, {}, PipedCalls);

do_transform(_) -> continue.

% Helpers

replace_args_for_call(Call, Args) ->
    list_to_tuple(lists:droplast(tuple_to_list(Call)) ++ [Args]).
