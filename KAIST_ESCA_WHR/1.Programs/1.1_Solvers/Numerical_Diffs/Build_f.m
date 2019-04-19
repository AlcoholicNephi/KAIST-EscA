function [f] = Build_f(Junc, Condition, Component, Mechanics)
% WHR update / 20171030

for i=1:size(Condition.split_link_value, 2)
    Condition.split(Condition.split_link(2*i)) = Condition.split_link_value(i) - Condition.split(Condition.split_link(i*2 - 1));
end

for i=1:size(Component, 2)
    for j=1:size(Component(i).inJunc, 2)
        Junc(Component(i).inJunc(j)).out_comp = i;
    end
    for j=1:size(Component(i).outJunc, 2)
        Junc(Component(i).outJunc(j)).in_comp = i;
    end
end

% Set mass flow rate %

for i=1:size(Component, 2)
    if(strcmp(Component(i).type, 'Junction'))
        cnt=1;
        for j=1:size(Component(i).inJunc, 2)
            if(Component(i).split(cnt) == -1)
                Junc(Component(i).inJunc(j)).m = 1;
            else
                Junc(Component(i).inJunc(j)).m = Condition.split(Component(i).split(cnt));
            end
            cnt = cnt+1;
        end
        for j=1:size(Component(i).outJunc, 2)
            if(Component(i).split(cnt) == -1)
                Junc(Component(i).outJunc(j)).m = 1;
            else
                Junc(Component(i).outJunc(j)).m = Condition.split(Component(i).split(cnt));
            end
            cnt = cnt+1;
        end
    else
        for j=1:size(Component(i).inJunc, 2)
            if(Component(i).split(j) == -1)
                Junc(Component(i).inJunc(j)).m = 1;
                Junc(Component(i).outJunc(j)).m = 1;
            elseif(Component(i).split(j) == -2)
                Junc(Component(i).inJunc(j)).m = -2;
                Junc(Component(i).outJunc(j)).m = -2;
            else
                Junc(Component(i).inJunc(j)).m = Condition.split(Component(i).split(j));
                Junc(Component(i).outJunc(j)).m = Condition.split(Component(i).split(j));
            end
        end
    end
end

% T P Initiallization %

for i=1:size(Junc, 2)
    if(Junc(i).m == -2)
        Junc(i).m_flow_rate = Condition.Pri_m;
    else
        Junc(i).m_flow_rate = Junc(i).m * Condition.m_flow_rate;
    end
end


% Set Tm
for i=1:size(Component, 2)
    if(strcmp(Component(i).type, 'Recuperator'))
        Tm(Component(i).index) = getTm(Junc(Component(i).inJunc(1)).P, Junc(Component(i).inJunc(2)).P, Junc(Component(i).inJunc(2)).m/Junc(Component(i).inJunc(1)).m);
%         disp(['Ph : ', num2str(Junc(Component(i).inJunc(1)).P), ' Pc : ', num2str(Junc(Component(i).inJunc(2)).P), ' m : ', num2str(Junc(Component(i).inJunc(2)).m/Junc(Component(i).inJunc(1)).m), ' Tm : ', num2str(Tm(Component(i).index))])
    end
end

Num_junc = size(Junc, 2);
f = -1 * ones(Num_junc * 2, 1);

% Build P function system

cnt = 1;

% Boundaries
for i=1:size(Condition.P_bound.ID, 2)
    f(cnt) = Junc(Condition.P_bound.ID(i)).P - Condition.P_bound.value(i);
    cnt = cnt+1;
end

% Else

for i=1:size(Component, 2)
    switch(Component(i).type)
        case 'IHX'
            if(Mechanics.IHX(Component(i).index).dP > 0)
                f(cnt) = Junc(Component(i).outJunc).P - Junc(Component(i).inJunc).P + Mechanics.IHX(Component(i).index).dP;
            else
                f(cnt) = Junc(Component(i).outJunc).P - Junc(Component(i).inJunc).P * (1 + Mechanics.IHX(Component(i).index).dP);
            end
            cnt = cnt+1;
            %%%
        case 'Valve'
            if(Mechanics.Valve(Component(i).index).indicator == 0)
                if(Mechanics.Valve(Component(i).index).dP > 0)
                    f(cnt) = Junc(Component(i).outJunc).P - Junc(Component(i).inJunc).P + Mechanics.Valve(Component(i).index).dP;
                else
                    f(cnt) = Junc(Component(i).outJunc).P - Junc(Component(i).inJunc).P * (1 + Mechanics.Valve(Component(i).index).dP);
                end
                cnt = cnt+1;
            else
                f(cnt) = Junc(Component(i).outJunc).P - Junc(Mechanics.Valve(Component(i).index).indicator).P;
                cnt = cnt+1;
            end
            %%%
        case 'Turbine'
            if(Mechanics.Turbine(Component(i).index).indicator == 0)
                f(cnt) = Junc(Component(i).outJunc).P - Junc(Component(i).inJunc).P / Mechanics.Turbine(Component(i).index).P_ratio;
                cnt = cnt+1;
            elseif(Mechanics.Turbine(Component(i).index).indicator > 0)
                f(cnt) = Junc(Component(i).outJunc).P - Junc(Mechanics.Turbine(Component(i).index).indicator).P;
                cnt = cnt+1;
            end
        case 'Compressor'
            if(Mechanics.Compressor(Component(i).index).indicator == 0)
                f(cnt) = Junc(Component(i).outJunc).P - Junc(Component(i).inJunc).P * Mechanics.Compressor(Component(i).index).P_ratio;
                cnt = cnt+1;
            elseif(Mechanics.Compressor(Component(i).index).indicator > 0)
                f(cnt) = Junc(Component(i).outJunc).P - Junc(Mechanics.Compressor(Component(i).index).indicator).P;
                cnt = cnt+1;
            end
        case 'Cooler'
            if(Mechanics.Cooler(Component(i).index).dP > 0)
                f(cnt) = Junc(Component(i).outJunc).P - Junc(Component(i).inJunc).P + Mechanics.Cooler(Component(i).index).dP;
            else
                f(cnt) = Junc(Component(i).outJunc).P - Junc(Component(i).inJunc).P * (1 + Mechanics.Cooler(Component(i).index).dP);
            end
            cnt = cnt+1;
        case 'Recuperator'
            if(Mechanics.Recuperator(Component(i).index).dP(1) > 0)
                f(cnt) = Junc(Component(i).outJunc(1)).P - Junc(Component(i).inJunc(1)).P + Mechanics.Recuperator(Component(i).index).dP(1);
            else
                f(cnt) = Junc(Component(i).outJunc(1)).P - Junc(Component(i).inJunc(1)).P *( 1 + Mechanics.Recuperator(Component(i).index).dP(1) );
            end
            cnt = cnt+1;
            
            if(Mechanics.Recuperator(Component(i).index).dP(2) > 0)
                f(cnt) = Junc(Component(i).outJunc(2)).P - Junc(Component(i).inJunc(2)).P + Mechanics.Recuperator(Component(i).index).dP(2);
            else
                f(cnt) = Junc(Component(i).outJunc(2)).P - Junc(Component(i).inJunc(2)).P * (1 + Mechanics.Recuperator(Component(i).index).dP(2));
            end
            cnt = cnt+1;
        case 'WHR'
            if(Mechanics.WHR(Component(i).index).dP(1) > 0)
                f(cnt) = Junc(Component(i).outJunc(1)).P - Junc(Component(i).inJunc(1)).P + Mechanics.WHR(Component(i).index).dP(1);
            else
                f(cnt) = Junc(Component(i).outJunc(1)).P - Junc(Component(i).inJunc(1)).P *( 1 + Mechanics.WHR(Component(i).index).dP(1) );
            end
            cnt = cnt+1;
            
            if(Mechanics.WHR(Component(i).index).dP(2) > 0)
                f(cnt) = Junc(Component(i).outJunc(2)).P - Junc(Component(i).inJunc(2)).P + Mechanics.WHR(Component(i).index).dP(2);
            else
                f(cnt) = Junc(Component(i).outJunc(2)).P - Junc(Component(i).inJunc(2)).P * (1 + Mechanics.WHR(Component(i).index).dP(2));
            end
            cnt = cnt+1;
            
        case 'Junction'
            if(size(Component(i).inJunc, 2) == 1)
                for j=1:size(Component(i).outJunc, 2)
                    f(cnt) = Junc(Component(i).outJunc(j)).P - Junc(Component(i).inJunc).P;
                    cnt = cnt+1;
                end
            else
                f(cnt) = Junc(Component(i).outJunc).P - Junc(Component(i).inJunc(1)).P;
                cnt = cnt+1;
            end
    end
end

% Build T function system


% Boundaries
for i=1:size(Condition.T_bound.ID, 2)
    f(cnt) = Junc(Condition.T_bound.ID(i)).T - Condition.T_bound.value(i);
    cnt = cnt+1;
end

% Else

for i=1:size(Component, 2)
    switch(Component(i).type)
        case 'Turbine'
            [f(cnt)] = f_Turbine(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Turbine(Component(i).index));
            cnt = cnt+1;
        %%%
        case 'Valve'
            [f(cnt)] = f_Valve(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Valve(Component(i).index));
            cnt = cnt+1;
        %%%
        case 'Compressor'
            [f(cnt)] = f_Compressor(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Compressor(Component(i).index));
            cnt = cnt+1;
        case 'Recuperator'
            [T1, P1, T2, P2] ...
                = Comp_Recuperator(Junc(Component(i).inJunc(1)), Junc(Component(i).inJunc(2)), Condition, Mechanics.Recuperator(Component(i).index), Tm(Component(i).index));
            f(cnt) = Junc(Component(i).outJunc(1)).T - T1;
            cnt = cnt+1;
            f(cnt) = Junc(Component(i).outJunc(2)).T - T2;
            cnt = cnt+1;
        case 'WHR'
            [T1, P1, T2, P2] ...
                = Comp_WHR(Junc(Component(i).inJunc(1)), Junc(Component(i).inJunc(2)), Condition, Mechanics.WHR(Component(i).index));
            f(cnt) = Junc(Component(i).outJunc(1)).T - T1;
            cnt = cnt+1;
            f(cnt) = Junc(Component(i).outJunc(2)).T - T2;
            cnt = cnt+1;
        case 'Junction'
            if(size(Component(i).inJunc, 2) == 1)
                for j=1:size(Component(i).outJunc, 2)
                    f(cnt) = Junc(Component(i).outJunc(j)).T - Junc(Component(i).inJunc).T;
                    cnt = cnt+1;
                end
            else
                H_tot = 0;
                for j=1:size(Component(i).inJunc, 2)
                    H_tot = H_tot + refpropm('H', 'T', Junc(Component(i).inJunc(j)).T, 'P', Junc(Component(i).inJunc(j)).P, Condition.Fluid) * Junc(Component(i).inJunc(j)).m;
                end
                H_tot = H_tot / Junc(Component(i).outJunc(1)).m;
                
                T_out = refpropm('T', 'H', H_tot, 'P', Junc(Component(i).outJunc).P, Condition.Fluid);
                
                f(cnt) = Junc(Component(i).outJunc).T - T_out;
                cnt = cnt+1;
            end
    end
end




end

