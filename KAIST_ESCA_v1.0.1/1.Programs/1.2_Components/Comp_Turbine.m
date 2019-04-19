function [T_out, P_out, Work] = Comp_Turbine(inJunc, P_target, Condition, Turbo_Condition)

T_in = inJunc.T;
P_in = inJunc.P;

h_in = refpropm('H', 'T', T_in, 'P', P_in, Condition.Fluid);
s_in = refpropm('S', 'T', T_in, 'P', P_in, Condition.Fluid);

P_out = P_target;

h_out_isentropic = refpropm('H', 'P', P_out, 'S', s_in, Condition.Fluid);
h_out = h_in-Turbo_Condition.Eff*(h_in-h_out_isentropic);

T_out = refpropm('T', 'H', h_out, 'P', P_out, Condition.Fluid);

Work = inJunc.m_flow_rate*(h_in-h_out); % [J/kg]

end