function result = DecoupledPF(X, fArray, J)
    % Initial Guesses
    V2 = 1;
    V3 = 1;
    TETA2 = 0;
    TETA3 = 0;
    
    % Jacobian modification for method
    J(1,4) = 0;
    J(2,3) = 0;
    J(3,2) = 0;
    J(4,1) = 0;

    DeltaX = -inv(J) * fArray;
    for i = 1:20
        result = double(subs(X)) + double(subs(DeltaX));
        V2 = result(1);
        V3 = result(2);
        TETA2 = result(3);
        TETA3 = result(4);
    end
    return
end
