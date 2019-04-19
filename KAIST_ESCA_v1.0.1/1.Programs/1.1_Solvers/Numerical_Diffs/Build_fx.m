function [f_x] = Build_fx(Junc, Condition, Component, Mechanics)

for i=1:size(Condition.split_link_value, 2)
    Condition.split(Condition.split_link(2*i)) = Condition.split_link_value(i) - Condition.split(Condition.split_link(i*2 - 1));
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
            else
                Junc(Component(i).inJunc(j)).m = Condition.split(Component(i).split(j));
                Junc(Component(i).outJunc(j)).m = Condition.split(Component(i).split(j));
            end
        end
    end
end


Num_junc = size(Junc, 2);
f_x = zeros(Num_junc * 2, Num_junc * 2);

% Build P function system

cnt = 1;

% Boundaries
for i=1:size(Condition.P_bound.ID, 2)
    f_x(cnt, Condition.P_bound.ID(i)) = 1;
    cnt = cnt+1;
end

% Else

for i=1:size(Component, 2)
    switch(Component(i).type)
        case 'IHX'
            if(Mechanics.IHX(Component(i).index).dP > 0)
                f_x(cnt, Component(i).outJunc) = 1;
                f_x(cnt, Component(i).inJunc) = -1;
            else
                f_x(cnt, Component(i).outJunc) = 1;
                f_x(cnt, Component(i).inJunc) = -(1 + Mechanics.IHX(Component(i).index).dP);
            end
            cnt = cnt+1;
            %%%
        case 'Valve'
            if(Mechanics.Valve(Component(i).index).indicator == 0)
                if(Mechanics.Valve(Component(i).index).dP > 0)
                    f_x(cnt, Component(i).outJunc) = 1;
                    f_x(cnt, Component(i).inJunc) = -1;
                else
                    f_x(cnt, Component(i).outJunc) = 1;
                    f_x(cnt, Component(i).inJunc) = -(1 + Mechanics.Valve(Component(i).index).dP);
                end
                cnt = cnt+1;
            else
                f_x(cnt, Component(i).outJunc) = 1;
                f_x(cnt, Mechanics.Valve(Component(i).index).indicator) = -1;
                cnt = cnt+1;
            end
            %%%
        case 'Turbine'
            if(Mechanics.Turbine(Component(i).index).indicator == 0)
                f_x(cnt, Component(i).outJunc) = 1;
                f_x(cnt, Component(i).inJunc) = -1 / Mechanics.Turbine(Component(i).index).P_ratio;
                cnt = cnt+1;
            elseif(Mechanics.Turbine(Component(i).index).indicator > 0)
                f_x(cnt, Component(i).outJunc) = 1;
                f_x(cnt, Mechanics.Turbine(Component(i).index).indicator) = -1;
                cnt = cnt+1;
            end
        case 'Compressor'
            if(Mechanics.Compressor(Component(i).index).indicator == 0)
                f_x(cnt, Component(i).outJunc) = 1;
                f_x(cnt, Component(i).inJunc) = -1 * Mechanics.Compressor(Component(i).index).P_ratio;
                cnt = cnt+1;
            elseif(Mechanics.Compressor(Component(i).index).indicator > 0)
                f_x(cnt, Component(i).outJunc) = 1;
                f_x(cnt, Mechanics.Compressor(Component(i).index).indicator) = -1;
                cnt = cnt+1;
            end
        case 'Cooler'
            if(Mechanics.Cooler(Component(i).index).dP > 0)
                f_x(cnt, Component(i).outJunc) = 1;
                f_x(cnt, Component(i).inJunc) = -1;
            else
                f_x(cnt, Component(i).outJunc) = 1;
                f_x(cnt, Component(i).inJunc) = - (1 + Mechanics.Cooler(Component(i).index).dP);
            end
            cnt = cnt+1;
        case 'Recuperator'
            if(Mechanics.Recuperator(Component(i).index).dP(1) > 0)
                f_x(cnt, Component(i).outJunc(1)) = 1;
                f_x(cnt, Component(i).inJunc(1)) = -1;
            else
                f_x(cnt, Component(i).outJunc(1)) = 1;
                f_x(cnt, Component(i).inJunc(1)) = -(1+Mechanics.Recuperator(Component(i).index).dP(1));
            end
            cnt = cnt+1;
            
            if(Mechanics.Recuperator(Component(i).index).dP(2) > 0)
                f_x(cnt, Component(i).outJunc(2)) = 1;
                f_x(cnt, Component(i).inJunc(2)) = -1;
            else
                f_x(cnt, Component(i).outJunc(2)) = 1;
                f_x(cnt, Component(i).inJunc(2)) = -(1+Mechanics.Recuperator(Component(i).index).dP(2));
            end
            cnt = cnt+1;
        case 'Junction'
            if(size(Component(i).inJunc, 2) == 1)
                for j=1:size(Component(i).outJunc, 2)
                    
                    f_x(cnt, Component(i).outJunc(j)) = 1;
                    f_x(cnt, Component(i).inJunc) = -1;
                    cnt = cnt+1;
                end
            else
                f_x(cnt, Component(i).outJunc) = 1;
                f_x(cnt, Component(i).inJunc(1)) = -1;
                cnt = cnt+1;
            end
    end
end



% Build T function system


% Boundaries
for i=1:size(Condition.T_bound.ID, 2)
    f_x(cnt, Condition.T_bound.ID(i) + Num_junc) = 1;
    cnt = cnt+1;
end

% Else

for i=1:size(Component, 2)
    switch(Component(i).type)
        case 'Turbine'
            [f0] = f_Turbine(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Turbine(Component(i).index));
            
            dT = Junc(Component(i).inJunc).T * Condition.delt;
            dP = Junc(Component(i).inJunc).P * Condition.delt;
            
            Junc(Component(i).inJunc).T = Junc(Component(i).inJunc).T + dT;
            [f01] =  f_Turbine(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Turbine(Component(i).index));
            Junc(Component(i).inJunc).T = Junc(Component(i).inJunc).T - dT;
            
            Junc(Component(i).inJunc).P = Junc(Component(i).inJunc).P + dP;
            [f02] =  f_Turbine(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Turbine(Component(i).index));
            Junc(Component(i).inJunc).P = Junc(Component(i).inJunc).P - dP;
            
            Junc(Component(i).outJunc).T = Junc(Component(i).outJunc).T + dT;
            [f03] =  f_Turbine(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Turbine(Component(i).index));
            Junc(Component(i).outJunc).T = Junc(Component(i).outJunc).T - dT;
            
            Junc(Component(i).outJunc).P = Junc(Component(i).outJunc).P + dP;
            [f04] =  f_Turbine(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Turbine(Component(i).index));
            Junc(Component(i).outJunc).P = Junc(Component(i).outJunc).P - dP;
            
            f_x(cnt, Component(i).inJunc + Num_junc) = (f01 - f0)/dT;
            f_x(cnt, Component(i).inJunc) = (f02 - f0)/dP;
            f_x(cnt, Component(i).outJunc + Num_junc) = (f03 - f0)/dT;
            f_x(cnt, Component(i).outJunc) = (f04 - f0)/dP;
            
            cnt = cnt+1;
            
        case 'Valve'
            [f0] = f_Valve(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Valve(Component(i).index));
            
            dT = Junc(Component(i).inJunc).T * Condition.delt;
            dP = Junc(Component(i).inJunc).P * Condition.delt;
            
            Junc(Component(i).inJunc).T = Junc(Component(i).inJunc).T + dT;
            [f01] =  f_Valve(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Valve(Component(i).index));
            Junc(Component(i).inJunc).T = Junc(Component(i).inJunc).T - dT;
            
            Junc(Component(i).inJunc).P = Junc(Component(i).inJunc).P + dP;
            [f02] =  f_Valve(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Valve(Component(i).index));
            Junc(Component(i).inJunc).P = Junc(Component(i).inJunc).P - dP;
            
            Junc(Component(i).outJunc).T = Junc(Component(i).outJunc).T + dT;
            [f03] =  f_Valve(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Valve(Component(i).index));
            Junc(Component(i).outJunc).T = Junc(Component(i).outJunc).T - dT;
            
            Junc(Component(i).outJunc).P = Junc(Component(i).outJunc).P + dP;
            [f04] =  f_Valve(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Valve(Component(i).index));
            Junc(Component(i).outJunc).P = Junc(Component(i).outJunc).P - dP;
            
            f_x(cnt, Component(i).inJunc + Num_junc) = (f01 - f0)/dT;
            f_x(cnt, Component(i).inJunc) = (f02 - f0)/dP;
            f_x(cnt, Component(i).outJunc + Num_junc) = (f03 - f0)/dT;
            f_x(cnt, Component(i).outJunc) = (f04 - f0)/dP;
            
            cnt = cnt+1;
            
        case 'Compressor'
            [f0] = f_Compressor(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Compressor(Component(i).index));
            
            dT = Junc(Component(i).inJunc).T * Condition.delt;
            dP = Junc(Component(i).inJunc).P * Condition.delt;
            
            Junc(Component(i).inJunc).T = Junc(Component(i).inJunc).T + dT;
            [f01] = f_Compressor(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Compressor(Component(i).index));
            Junc(Component(i).inJunc).T = Junc(Component(i).inJunc).T - dT;
            
            Junc(Component(i).inJunc).P = Junc(Component(i).inJunc).P + dP;
            [f02] = f_Compressor(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Compressor(Component(i).index));
            Junc(Component(i).inJunc).P = Junc(Component(i).inJunc).P - dP;
            
            Junc(Component(i).outJunc).T = Junc(Component(i).outJunc).T + dT;
            [f03] = f_Compressor(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Compressor(Component(i).index));
            Junc(Component(i).outJunc).T = Junc(Component(i).outJunc).T - dT;
            
            Junc(Component(i).outJunc).P = Junc(Component(i).outJunc).P + dP;
            [f04] = f_Compressor(Junc(Component(i).inJunc), Junc(Component(i).outJunc), Condition, Mechanics.Compressor(Component(i).index));
            Junc(Component(i).outJunc).P = Junc(Component(i).outJunc).P - dP;
            
            f_x(cnt, Component(i).inJunc + Num_junc) = (f01 - f0)/dT;
            f_x(cnt, Component(i).inJunc) = (f02 - f0)/dP;
            f_x(cnt, Component(i).outJunc + Num_junc) = (f03 - f0)/dT;
            f_x(cnt, Component(i).outJunc) = (f04 - f0)/dP;
            
            cnt = cnt+1;
            
        case 'Recuperator'
            tl = [Component(i).inJunc(1), Component(i).inJunc(2), Component(i).outJunc(1), Component(i).outJunc(2)];
            
            Tm(Component(i).index) = getTm(Junc(Component(i).inJunc(1)).P, Junc(Component(i).inJunc(2)).P, Junc(Component(i).inJunc(2)).m/Junc(Component(i).inJunc(1)).m);
            
            [T1, Junc(Component(i).outJunc(1)).P, T2, Junc(Component(i).outJunc(2)).P] ...
                = Comp_Recuperator(Junc(Component(i).inJunc(1)), Junc(Component(i).inJunc(2)), Condition, Mechanics.Recuperator(Component(i).index), Tm(Component(i).index));
            
            ff0(1) = Junc(Component(i).outJunc(1)).T - T1;
            ff0(2) = Junc(Component(i).outJunc(2)).T - T2;
            
            for j=1:4
                
                dT = Junc(tl(j)).T * Condition.delt;
                dP = Junc(tl(j)).P * Condition.delt;
                
                Junc(tl(j)).T = Junc(tl(j)).T + dT;
                
                Tm(Component(i).index) = getTm(Junc(Component(i).inJunc(1)).P, Junc(Component(i).inJunc(2)).P, Junc(Component(i).inJunc(2)).m/Junc(Component(i).inJunc(1)).m);
                
                [T1, P1, T2, P2] ...
                    = Comp_Recuperator(Junc(Component(i).inJunc(1)), Junc(Component(i).inJunc(2)), Condition, Mechanics.Recuperator(Component(i).index), Tm(Component(i).index));
                
                ff1(1) = Junc(Component(i).outJunc(1)).T - T1;
                ff1(2) = Junc(Component(i).outJunc(2)).T - T2;
                Junc(tl(j)).T = Junc(tl(j)).T - dT;
                
                f_x(cnt, tl(j)+Num_junc) = (ff1(1) - ff0(1))/dT;
                f_x(cnt+1, tl(j)+Num_junc) = (ff1(2) - ff0(2))/dT;
                
                Junc(tl(j)).P = Junc(tl(j)).P + dP;
                
                Tm(Component(i).index) = getTm(Junc(Component(i).inJunc(1)).P, Junc(Component(i).inJunc(2)).P, Junc(Component(i).inJunc(2)).m/Junc(Component(i).inJunc(1)).m);
                
                [T1, P1, T2, P2] ...
                    = Comp_Recuperator(Junc(Component(i).inJunc(1)), Junc(Component(i).inJunc(2)), Condition, Mechanics.Recuperator(Component(i).index), Tm(Component(i).index));
                ff1(1) = Junc(Component(i).outJunc(1)).T - T1;
                ff1(2) = Junc(Component(i).outJunc(2)).T - T2;
                Junc(tl(j)).P = Junc(tl(j)).P - dP;
                
                f_x(cnt, tl(j)) = (ff1(1) - ff0(1))/dP;
                f_x(cnt+1, tl(j)) = (ff1(2) - ff0(2))/dP;
                
                
            end
            cnt = cnt+2;
        case 'Junction'
            
            if(size(Component(i).inJunc, 2) == 1)
                for j=1:size(Component(i).outJunc, 2)
                    f_x(cnt, Component(i).outJunc(j) + Num_junc) = 1;
                    f_x(cnt, Component(i).inJunc + Num_junc) = -1;
                    cnt = cnt+1;
                end
            else
                [ f0 ] = f_Junction(Condition, Junc, Component(i));
                
                for j=1:size(Component(i).inJunc, 2)
                    
                    if(Junc(Component(i).inJunc(j)).m_flow_rate == 0)
                        f_x(cnt, Component(i).inJunc(j) + Num_junc) = 0;
                        f_x(cnt, Component(i).inJunc(j)) = 0;
                    else
                        
                        dT = Junc(Component(i).inJunc(j)).T * Condition.delt;
                        
                        Junc(Component(i).inJunc(j)).T = Junc(Component(i).inJunc(j)).T + dT;
                        [ f01 ] = f_Junction(Condition, Junc, Component(i));
                        Junc(Component(i).inJunc(j)).T = Junc(Component(i).inJunc(j)).T - dT;
                        
                        f_x(cnt, Component(i).inJunc(j) + Num_junc) = (f01 - f0)/dT;
                        
                        dP = Junc(Component(i).inJunc(j)).P * Condition.delt;
                        
                        Junc(Component(i).inJunc(j)).P = Junc(Component(i).inJunc(j)).P + dP;
                        [ f01 ] = f_Junction(Condition, Junc, Component(i));
                        Junc(Component(i).inJunc(j)).P = Junc(Component(i).inJunc(j)).P - dP;
                        
                        f_x(cnt, Component(i).inJunc(j)) = (f01 - f0)/dP;
                        
                    end
                end
                
                f_x(cnt, Component(i).outJunc + Num_junc) = 1;
                
                dP = Junc(Component(i).outJunc).P * Condition.delt;
                
                Junc(Component(i).outJunc).P = Junc(Component(i).outJunc).P + dP;
                [ f01 ] = f_Junction(Condition, Junc, Component(i));
                Junc(Component(i).outJunc).P = Junc(Component(i).outJunc).P - dP;
                
                f_x(cnt, Component(i).outJunc) = (f01 - f0)/dP;
                
                cnt = cnt+1;
            end
    end
end


end

