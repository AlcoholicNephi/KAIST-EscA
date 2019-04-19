function [g_p] = Build_gp(Condition, Junc, Parameters, Mechanics, Component, g0)

g_p = zeros(1, size(Parameters, 2));

for i=1:size(Parameters, 2)
    
    eval(['delta = ', Parameters{i}, ' *  Condition.delt;'])
    eval([Parameters{i}, ' = ', Parameters{i}, ' + delta;'])
    
    g_p(i) = (get_g(Condition, Junc, Component) - g0)/delta;
    
    eval([Parameters{i}, ' = ', Parameters{i}, ' - delta;'])
    
end

end

