function [g_x] = Build_gx(Condition, Junc, Component, g0)

Num_junc = size(Junc, 2);

g_x = zeros(1, 2*Num_junc);

for i=1:Num_junc
    
    delT = Junc(i).T * Condition.delt;
    delP = Junc(i).P * Condition.delt;
    
    iJunc = Junc;
    iJunc(i).T = iJunc(i).T + delT;
    
    iiJunc = Junc;
    iiJunc(i).P = iiJunc(i).P + delP;
    
    g_x(Num_junc + i) = (get_g(Condition, iJunc, Component) - g0)/delT;
    
    g_x(i) = (get_g(Condition, iiJunc, Component) - g0)/delP;
    
end
end

