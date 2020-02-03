function result = slackPower(B1,G1,V2,V3,TETA2,TETA3)

P1 = G1(1)+V2*(G1(2)*cos(TETA2)-B1(2)*sin(TETA2))+V3*(G1(3)*cos(TETA3)-B1(3)*sin(TETA3));
Q1 = -B1(1) - V2*(G1(2)*sin(TETA2)+B1(2)*cos(TETA2)) - V3*(G1(3)*sin(TETA3)+B1(3)*cos(TETA3));

result = [subs(P1), subs(Q1)];
return
end

