function [ f ] = f_Junction(Condition, Junc, Component)

H_tot = 0;
for j=1:size(Component.inJunc, 2)
    H_tot = H_tot + refpropm('H', 'T', Junc(Component.inJunc(j)).T, 'P', Junc(Component.inJunc(j)).P, Condition.Fluid) * Junc(Component.inJunc(j)).m;
end

T_out = refpropm('T', 'H', H_tot, 'P', Junc(Component.outJunc).P, Condition.Fluid);

f = Junc(Component.outJunc).T - T_out;

end
