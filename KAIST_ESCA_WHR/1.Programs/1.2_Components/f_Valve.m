function [f] = f_Valve(inJunc, outJunc, Condition, Valve_Condition)

P_out = outJunc.P;
H_in = refpropm('H', 'T', inJunc.T, 'P', inJunc.P, Condition.Fluid);
T_out = refpropm('T', 'H', H_in, 'P', P_out, Condition.Fluid);

f = T_out - outJunc.T;

end