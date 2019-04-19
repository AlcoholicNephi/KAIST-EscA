function [T_out, P_out] = Comp_Valve(inJunc, P_target, Condition, Valve_Condition)

P_out = P_target;
H_in = refpropm('H', 'T', inJunc.T, 'P', inJunc.P, Condition.Fluid);
T_out = refpropm('T', 'H', H_in, 'P', P_out, Condition.Fluid);


end

