function [T_H_out, P_H_out, T_C_out, P_C_out] = Comp_Recuperator(Hjunction, Cjunction, Condition, HX_Condition, Tm)

T_C_in = Cjunction.T;
P_C_in = Cjunction.P;

T_H_in = Hjunction.T;
P_H_in = Hjunction.P;

% Dostal definition of HX effectiveness is used
if(HX_Condition.dP(1) > 0)
    P_H_out = P_H_in-HX_Condition.dP(1);
else
    P_H_out = P_H_in * (1+HX_Condition.dP(1));
end

if(HX_Condition.dP(2) > 0)
    P_C_out = P_C_in-HX_Condition.dP(2);
else
    P_C_out = P_C_in * (1+HX_Condition.dP(2));
end

mh = Hjunction.m;
Ph = Hjunction.P;
Thi = Hjunction.T;

mc = Cjunction.m;
Tci = Cjunction.T;
Pc = Cjunction.P;

dQ1 = mh * abs(refpropm('H', 'T', Thi, 'P', Ph, Condition.Fluid) - refpropm('H', 'T', Tci, 'P', Ph, Condition.Fluid));
dQ2 = mc * abs(refpropm('H', 'T', Thi, 'P', Pc, Condition.Fluid) - refpropm('H', 'T', Tci, 'P', Pc, Condition.Fluid));
dQ_ideal = min(dQ1, dQ2);
% Eff_ideal = 1;

if(Tm < 0)
    Eff_ideal = 1;
elseif(Tci > Tm)
    Eff_ideal = 1;
elseif(Thi < Tm)
    Eff_ideal = 1;
else

    dQ_ideal2 = mh * (refpropm('H', 'T', Thi, 'P', Ph, 'CO2') - refpropm('H', 'T', Tm, 'P', Ph, 'CO2')) + mc * (refpropm('H', 'T', Tm, 'P', Pc, 'CO2') - refpropm('H', 'T', Tci, 'P', Pc, 'CO2'));
    
    Eff_ideal = min(dQ_ideal, dQ_ideal2) / dQ_ideal;

end

% Eff_ideal

dQ_real = dQ_ideal * HX_Condition.Eff * Eff_ideal;

h_H_out = refpropm('H', 'T', Thi, 'P', Ph, Condition.Fluid) - dQ_real / mh;
h_C_out = refpropm('H', 'T', Tci, 'P', Pc, Condition.Fluid) + dQ_real / mc;

T_C_out =refpropm('T', 'H', h_C_out, 'P', P_C_out, Condition.Fluid);
T_H_out =refpropm('T', 'H', h_H_out, 'P', P_H_out, Condition.Fluid);

end
