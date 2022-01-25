-module(numerl_tests).
-include_lib("eunit/include/eunit.hrl").

matrix_test() ->
    M0 = [[1.0, 0.0], [0.0, 1.0]],
    _ = numerl:matrix(M0).

print_test() ->
    M0 = numerl:matrix([[1.0/3.0, 0.0], [0.0, 1.0/3.0]]),
    numerl:print(M0).

get_test() ->
    %Testing access on square matrix
    M0 = [[1.0, 2.0], [3.0, 4.0]],
    CM0 = numerl:matrix(M0),
    V00 = 1.0,
    V00 = numerl:get(1,1,CM0),

    V11 = 4.0,
    V11 = numerl:get(2,2,CM0),

    V01 = 2.0,
    V01 = numerl:get(1,2,CM0),

    V10 = 3.0,
    V10 = numerl:get(2,1, CM0).

at_test()->
    0.0 = numerl:at(numerl:matrix([[1,0]]), 2),
    2.0 = numerl:at(numerl:matrix([[2,3,4]]), 1).

mtfli_test()->
    [1,2,3] = numerl:mtfli(numerl:matrix([[1.1, 2.9, 3]])).

equal_test() ->
    M0 = [[1.0, 2.0], [3.0, 4.0]],
    M1 = [[1.0, 2.0]],
    M2 = [[1.0], [2.0]],
    CM0 = numerl:matrix(M0),
    CM1 = numerl:matrix(M1),
    CM2 = numerl:matrix(M2),
    true = numerl:equals(CM1, CM1),
    true = numerl:equals(CM0, CM0),
    false = numerl:equals(CM1, CM2),
    false = numerl:equals(CM0, CM2),
    false = numerl:equals(CM0, CM1),
    false = numerl:equals(CM0,1).

row_test() ->
    M0 = [[1.0, 2.0], [3.0, 4.0]],
    R0 = [[3.0, 4.0]],
    CM0 = numerl:matrix(M0),
    CR0 = numerl:matrix(R0),
    true = numerl:equals(CR0, numerl:row(2, CM0)).


col_test() ->
    M0 = [[1.0, 2.0], [3.0, 4.0]],
    C0 = [[2.0], [4.0]],
    CM0 = numerl:matrix(M0),
    CC0 = numerl:matrix(C0),
    true = numerl:equals(CC0, numerl:col(2, CM0)).

plus_test()->
     M0 = [[1.0, 2.0], [3.0, 4.0]],
     M1 = [[2.0, 4.0], [6.0, 8.0]],
     CM0 = numerl:matrix(M0),
     CM1 = numerl:matrix(M1),
     CM0p = numerl:add(CM0, CM0),
     true = numerl:equals(CM1, CM0p).

minus_test()->
     M0 = [[1, 2], [3, 4]],
     M1 = [[0, 0], [0, 0]],
     CM0 = numerl:matrix(M0),
     CM1 = numerl:matrix(M1),
     CM0p = numerl:sub(CM0, CM0),
     true = numerl:equals(CM1, CM0p).

zero_test() ->
    CM0 = numerl:zeros(1,5),
    0.0 = numerl:get(1, 5, CM0).

eye_test() ->
    CM0 = numerl:eye(5),
    M0 = numerl:get(5,5,CM0),
    M0 = 1.0,
    M0 = numerl:get(1,1,CM0),
    M0 = numerl:get(2,2,CM0),
    M0 = numerl:get(4,4,CM0).

mult_num_test()->
    M0 = numerl:matrix([[1.0, 2.0]]),
    true = numerl:equals(numerl:matrix([[2,4]]), numerl:mult(M0, 2)),
    true = numerl:equals(numerl:matrix([[0,0]]), numerl:mult(M0, 0)),
    true = numerl:equals(numerl:matrix([[-1, -2]]), numerl:mult(M0, -1)).

mult_matrix_test() ->
    CM1 = numerl:matrix([[1, 2, 3]]),
    CM2 = numerl:matrix([[2, 1, 1]]),
    CM3 = numerl:matrix([[2, 2, 3]]),
    true = numerl:equals(CM3, numerl:mult(CM1, CM2)).

div_test()->
    M0 = numerl:matrix([[1,2,3]]),
    true = numerl:equals(numerl:divide(M0,2), numerl:matrix([[0.5, 1, 1.5]])).


tr_test() ->
    CM0 = numerl:eye(2),
    CM0 = numerl:transpose(CM0),
    CM1 = numerl:matrix([[1.0, 2.0],[3.0, 4.0]]),
    CM2 = numerl:matrix([[1.0, 3.0], [2.0, 4.0]]),
    CM3 = numerl:matrix([[1.0, 2.0]]),
    true = numerl:equals(CM3, numerl:transpose(numerl:matrix([[1.0], [2.0]]))),
    CM1 = numerl:transpose(CM2).

inv_test() ->
    F = fun()->
        N = rand:uniform(20),
        M = numerl:rnd_matrix(N),
        M_inv = numerl:inv(M),
        numerl:equals(numerl:dot(M, M_inv), numerl:eye(N))
    end,
    List = [F() || _ <- lists:seq(1,50)],
    lists:all(fun(_)-> true end, List).



ddot_test() ->
    Incs = numerl:matrix([[1, 2, 3, 4]]),
    Ones = numerl:matrix([[1], [1], [1], [1]]),
    10.0 = numerl:ddot(Incs, Ones),
    30.0 = numerl:ddot(Incs, Incs),
    4.0 = numerl:ddot(Ones, Ones).

daxpy_test()->
    Ones = numerl:matrix([[1, 1, 1, 1]]),
    Incs = numerl:matrix([[1, 2, 3, 4]]),
    true = numerl:equals(numerl:matrix([[3, 4, 5, 6]]), numerl:daxpy(4, 2, Ones, Incs)).

dgemv_test()->
    V10 = numerl:matrix([[1,2]]),
    V01 = numerl:matrix([[0], [1]]),
    M = numerl:matrix([[1,2],[3,4]]),
    true = numerl:equals(numerl:matrix([[10],[26]]), numerl:dgemv(2,M,V10, 4, V01)).

dot_test()->
    A = numerl:matrix([[1,2]]),
    B = numerl:matrix([[3,4], [5,6]]),
    true = numerl:equals(numerl:matrix([[13, 16]]), numerl:dot(A,B)).

memleak_test()->
    %For input matrices of size 10: run all function once, check memory, run 5 more times, check if memory increase.
    N = 10,
    AllFcts = fun()->
        M = numerl:rnd_matrix(N),
        _ = numerl:at(M,1),
        _ = numerl:mtfli(M),
        _ = numerl:equals(M,M),
        _ = numerl:add(M,M),
        _ = numerl:sub(M,M),
        _ = numerl:mult(M,M),
        _ = numerl:mult(M,1),
        _ = numerl:divide(M,2),
        _ = numerl:transpose(M),
        _ = numerl:inv(M),
        _ = numerl:dnrm2(M),
        _ = numerl:ddot(M,M),
        _ = numerl:dot(M,M)
        end,
    
    AllFcts(),
    erlang:garbage_collect(),
    {memory, M_first_run} = erlang:process_info(self(), memory),

    AllFcts(), AllFcts(), AllFcts(), AllFcts(),

    erlang:garbage_collect(),
    {memory, M_second_run} = erlang:process_info(self(), memory),

    M_first_run >= M_second_run.


    
    