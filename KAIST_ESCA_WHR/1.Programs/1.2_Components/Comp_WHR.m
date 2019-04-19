function [T_C_out, P_C_out, T_H_out, P_H_out] = Comp_WHR(Cjunction, Hjunction, Condition, HX_Condition)

T_C_in = Cjunction.T;
P_C_in = Cjunction.P;

T_H_in = Hjunction.T;
P_H_in = Hjunction.P;

% Dostal definition of HX effectiveness is used
if(HX_Condition.dP(2) > 0)
    P_H_out = P_H_in-HX_Condition.dP(2);
else
    P_H_out = P_H_in * (1+HX_Condition.dP(2));
end

if(HX_Condition.dP(1) > 0)
    P_C_out = P_C_in-HX_Condition.dP(1);
else
    P_C_out = P_C_in * (1+HX_Condition.dP(1));
end

mh = Hjunction.m_flow_rate;
Ph = Hjunction.P;
Thi = Hjunction.T;

mc = Cjunction.m_flow_rate;
Tci = Cjunction.T;
Pc = Cjunction.P;

dQ1 = mh * abs(Primary_H(Thi, Ph) - Primary_H(Tci, Ph));
dQ2 = mc * abs(refpropm('H', 'T', Thi, 'P', Pc, Condition.Fluid) - refpropm('H', 'T', Tci, 'P', Pc, Condition.Fluid));
dQ_ideal = min(dQ1, dQ2);
% Eff_ideal = 1;


% Eff_ideal

dQ_real = dQ_ideal * HX_Condition.Eff;

h_H_out = Primary_H(Thi, Ph) - dQ_real / mh;
h_C_out = refpropm('H', 'T', Tci, 'P', Pc, Condition.Fluid) + dQ_real / mc;

T_C_out =refpropm('T', 'H', h_C_out, 'P', P_C_out, Condition.Fluid);
T_H_out =Primary_T(h_H_out, P_H_out);

end
