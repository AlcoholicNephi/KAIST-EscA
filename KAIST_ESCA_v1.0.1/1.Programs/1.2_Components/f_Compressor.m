function [f] = f_Compressor(inJunc, outJunc, Condition, Turbo_Condition)

T_in = inJunc.T;
P_in = inJunc.P;

h_in = refpropm('H', 'T', T_in, 'P', P_in, Condition.Fluid);
s_in = refpropm('S', 'T', T_in, 'P', P_in, Condition.Fluid);

P_Ratio = outJunc.P/P_in*Turbo_Condition.Rel_P_ratio;
P_out = P_in*P_Ratio;

h_out_isentropic = refpropm('H', 'P', P_out, 'S', s_in, Condition.Fluid);
h_out = h_in+1/Turbo_Condition.Eff*(h_out_isentropic-h_in);

T_out = refpropm('T', 'H', h_out, 'P', P_out, Condition.Fluid);

f = T_out - outJunc.T;

end