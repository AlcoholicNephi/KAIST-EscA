function [f_p] = Build_fp(Condition, Junc, Mechanics, Component, Parameters, f0)

% Num_junc = size(Junc, 2);
% 
% f_p = zeros(2*Num_junc, size(Parameters, 2));

for i=1:size(Parameters, 2)
    
    eval(['delta = ', Parameters{i}, ' *  Condition.delt;'])
    eval([Parameters{i}, ' = ', Parameters{i}, ' + delta;'])
    
    f_p(:, i) = (Build_f(Junc, Condition, Component, Mechanics) - f0)/delta;
    
    eval([Parameters{i}, ' = ', Parameters{i}, ' - delta;'])
    
end


end

