function [ f_x ] = Compressor_fx(Junc, Condition, Component, Mechanics)

f_x = zeros(1, size(Junc, 2) * 2);
Num_junc = size(Junc, 2);

[f0] = f_Compressor(Junc(Component.inJunc), Junc(Component.outJunc), Condition, Mechanics.Compressor(Component.index));

dT = Junc(Component.inJunc).T * Condition.delt;
dP = Junc(Component.inJunc).P * Condition.delt;

Junc(Component.inJunc).T = Junc(Component.inJunc).T + dT;
[f01] = f_Compressor(Junc(Component.inJunc), Junc(Component.outJunc), Condition, Mechanics.Compressor(Component.index));
Junc(Component.inJunc).T = Junc(Component.inJunc).T - dT;

Junc(Component.inJunc).P = Junc(Component.inJunc).P + dP;
[f02] = f_Compressor(Junc(Component.inJunc), Junc(Component.outJunc), Condition, Mechanics.Compressor(Component.index));
Junc(Component.inJunc).P = Junc(Component.inJunc).P - dP;

Junc(Component.outJunc).T = Junc(Component.outJunc).T + dT;
[f03] = f_Compressor(Junc(Component.inJunc), Junc(Component.outJunc), Condition, Mechanics.Compressor(Component.index));
Junc(Component.outJunc).T = Junc(Component.outJunc).T - dT;

Junc(Component.outJunc).P = Junc(Component.outJunc).P + dP;
[f04] = f_Compressor(Junc(Component.inJunc), Junc(Component.outJunc), Condition, Mechanics.Compressor(Component.index));
Junc(Component.outJunc).P = Junc(Component.outJunc).P - dP;

f_x(Component.inJunc + Num_junc) = (f01 - f0)/dT;
f_x(Component.inJunc) = (f02 - f0)/dP;
f_x(Component.outJunc + Num_junc) = (f03 - f0)/dT;
f_x(Component.outJunc) = (f04 - f0)/dP;

end

