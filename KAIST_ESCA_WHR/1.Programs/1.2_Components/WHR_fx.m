function [ f_x ] = WHR_fx(Junc, Condition, Component, Mechanics)

f_x = zeros(2, size(Junc, 2) * 2);
Num_junc = size(Junc, 2);


tl = [Component.inJunc(1), Component.inJunc(2), Component.outJunc(1), Component.outJunc(2)];

[T1, Junc(Component.outJunc(1)).P, T2, Junc(Component.outJunc(2)).P] ...
    = Comp_WHR(Junc(Component.inJunc(1)), Junc(Component.inJunc(2)), Condition, Mechanics.WHR(Component.index));

ff0(1) = Junc(Component.outJunc(1)).T - T1;
ff0(2) = Junc(Component.outJunc(2)).T - T2;

for j=1:4
    
    dT = Junc(tl(j)).T * Condition.delt;
    dP = Junc(tl(j)).P * Condition.delt;
    
    Junc(tl(j)).T = Junc(tl(j)).T + dT;
    
    
    [T1, P1, T2, P2] ...
        = Comp_WHR(Junc(Component.inJunc(1)), Junc(Component.inJunc(2)), Condition, Mechanics.WHR(Component.index));
    
    ff1(1) = Junc(Component.outJunc(1)).T - T1;
    ff1(2) = Junc(Component.outJunc(2)).T - T2;
    Junc(tl(j)).T = Junc(tl(j)).T - dT;
    
    f_x(1, tl(j)+Num_junc) = (ff1(1) - ff0(1))/dT;
    f_x(2, tl(j)+Num_junc) = (ff1(2) - ff0(2))/dT;
    
    Junc(tl(j)).P = Junc(tl(j)).P + dP;
    
    
    [T1, P1, T2, P2] ...
        = Comp_WHR(Junc(Component.inJunc(1)), Junc(Component.inJunc(2)), Condition, Mechanics.WHR(Component.index));
    
    ff1(1) = Junc(Component.outJunc(1)).T - T1;
    ff1(2) = Junc(Component.outJunc(2)).T - T2;
    Junc(tl(j)).P = Junc(tl(j)).P - dP;
    
    f_x(1, tl(j)) = (ff1(1) - ff0(1))/dP;
    f_x(2, tl(j)) = (ff1(2) - ff0(2))/dP;
    
    
end

end

