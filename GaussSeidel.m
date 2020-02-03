function result = GaussSeidel(Y, BUS2_P, BUS3_P, BUS2_Q, BUS3_Q, BUS1_V)
    S2 = BUS2_P+BUS2_Q*i;
    S3 = BUS3_P+BUS3_Q*i;
    Y = -Y;
    % Initial guess
    V2(1)=1; 

    % Iteration for V2
    for ii = 1:1000 
        V2(ii+1) =(1/Y(2,2)) * (conj(S2)/conj(V2(ii))-Y(2,1)*BUS1_V);
        display(V2(ii+1))
        V2_mag(ii+1) = sqrt(real(V2(ii+1).^2+imag(V2(ii+1)).^2));
        V2_angle(ii+1) = atan(imag(V2(ii+1))/real(V2(ii+1)));
        if abs (V2_mag(ii+1)- V2_mag(ii)) <=0.0001
            break
        end
    end

    % Initial guess
    V3(1)=1; 
    V3_mag =1;
    V3_angle =0;

    % Iteration for V3
     for j = 1:1000
        V3(j+1)= (1/Y(3,3)) * (conj(S3)/conj(V3(j))-(Y(3,1)*BUS1_V)+Y(3,2)*V2(ii+1));
        V3_mag(j+1) = sqrt(real(V3(j+1).^2+imag(V3(j+1)).^2));
        V3_angle(j+1) = atan(imag(V3(j+1))/real(V3(j+1)));

        if abs (V3_mag(j+1)- V3_mag(j)) <=0.0001
            break
        end

     end
     display(V3_mag)
     result = [V2_mag(length(V2_mag)), V3_mag(length(V3_mag)),V2_angle(length(V2_angle)),V3_angle(length(V3_angle))];
     return

end

