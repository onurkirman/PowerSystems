function result = dishonestNewtonRaphson(X, fArray, J)
    % Initial Guesses
    V2 = 1;
    V3 = 1;
    TETA2 = 0;
    TETA3 = 0;
    
    Jacobian_Zero = subs(J);
    DeltaX = -inv(Jacobian_Zero) * fArray;
    
    for i = 1:20
        result = double(subs(X)) + double(subs(DeltaX));
        V2 = result(1);
        V3 = result(2);
        TETA2 = result(3);
        TETA3 = result(4);
    end
 
    return
end