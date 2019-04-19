function [f_x] = Junction_fx(Junc, Condition, Component)

f_x = zeros(1, size(Junc, 2) * 2);
Num_junc = size(Junc, 2);

[ f0 ] = f_Junction(Condition, Junc, Component);

for j=1:size(Component.inJunc, 2)
    
    if(Junc(Component.inJunc(j)).m_flow_rate == 0)
        f_x(Component.inJunc(j) + Num_junc) = 0;
        f_x(Component.inJunc(j)) = 0;
    else
        dT = Junc(Component.inJunc(j)).T * Condition.delt;
        
        Junc(Component.inJunc(j)).T = Junc(Component.inJunc(j)).T + dT;
        [ f01 ] = f_Junction(Condition, Junc, Component);
        Junc(Component.inJunc(j)).T = Junc(Component.inJunc(j)).T - dT;
        
        f_x(Component.inJunc(j) + Num_junc) = (f01 - f0)/dT;
        
        dP = Junc(Component.inJunc(j)).P * Condition.delt;
        
        Junc(Component.inJunc(j)).P = Junc(Component.inJunc(j)).P + dP;
        [ f01 ] = f_Junction(Condition, Junc, Component);
        Junc(Component.inJunc(j)).P = Junc(Component.inJunc(j)).P - dP;
        
        f_x(Component.inJunc(j)) = (f01 - f0)/dP;
    end
end

% if(Junc(Component.outJunc).m_flow_rate == 0)
%     f_x(Component.outJunc + Num_junc) = 0;
%     f_x(Component.outJunc) = 0;
% else
    f_x(Component.outJunc + Num_junc) = 1;
    
    dP = Junc(Component.outJunc).P * Condition.delt;
    
    Junc(Component.outJunc).P = Junc(Component.outJunc).P + dP;
    [ f01 ] = f_Junction(Condition, Junc, Component);
    Junc(Component.outJunc).P = Junc(Component.outJunc).P - dP;
    
    f_x(Component.outJunc) = (f01 - f0)/dP;
% end

end

