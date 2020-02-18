-module(pipe_transform).
-export([parse_transform/2]).

parse_transform(Ast, _Opt) ->
    %io:format ("AST: ~p~n", [Ast]),
    NewAst = [parse(A) || A <- Ast],
    %io:format("NewAST: ~p~n", [NewAst]),
    NewAst.

% Parsing

parse({function, Line, FunName, ArgNum, Clause}) ->
    {function, Line, FunName, ArgNum, [parse(C) || C <- Clause]};

parse({clause, Line, Vars, Gaurd, ExprCalls}) ->
    {clause, Line, Vars, Gaurd, [parse(E) || E <- ExprCalls]};

parse({match, Line, Var, Expr}) ->
    {match, Line, Var, parse(Expr)};

parse({'fun', Line, {clauses, Clauses}}) ->
    {'fun', Line, {clauses, [parse(C) || C <- Clauses]}};

parse({call, _, {remote, _, {atom, _, pipe_transform}, {atom, _, pipe}}, [{Type, _, Val} | PipedCalls]}) ->
    lists:foldl(fun(Call, {}) ->
                    NewArgs = [{Type, 0, Val} | element(size(Call), Call)],
                    replace_args_for_call(Call, NewArgs);
                   (Call, ArgsCall) ->
                    replace_args_for_call(Call, [ArgsCall | element(size(Call), Call)])
                end, {}, PipedCalls);

parse(Other) -> Other.

% Helpers

replace_args_for_call(Call, Args) ->
    list_to_tuple(lists:droplast(tuple_to_list(Call)) ++ [Args]).
