function [ f_xx ] = Build_fxx(Junc, Condition, Component, Mechanics)


Num_junc = size(Junc, 2);


% Build P function system

cnt = 1;

% Boundaries
for i=1:size(Condition.P_bound.ID, 2)
    cnt = cnt+1;
end

% Else

for i=1:size(Component, 2)
    switch(Component(i).type)
        case 'IHX'
            cnt = cnt+1;
        case 'WHR'
            cnt = cnt+2;
        case 'Valve'
            cnt = cnt+1;
        case 'Turbine'
            if(Mechanics.Turbine(Component(i).index).indicator >= 0)
                cnt = cnt+1;
            end
        case 'Compressor'
            if(Mechanics.Compressor(Component(i).index).indicator >= 0)
                cnt = cnt+1;
            end
        case 'Cooler'
            cnt = cnt+1;
        case 'Recuperator'
            cnt = cnt+2;
        case 'Junction'
            if(size(Component(i).inJunc, 2) == 1)
                for j=1:size(Component(i).outJunc, 2)
                    cnt = cnt+1;
                end
            else
                if(Component(i).check == -1)
                    cnt = cnt+2;
                else
                    cnt = cnt+1;
                end
            end
    end
end



% Build T function system


% Boundaries
for i=1:size(Condition.T_bound.ID, 2)
    cnt = cnt+1;
end

% Else

for i=1:size(Component, 2)
    switch(Component(i).type)
        case 'Turbine'
            
            [ f_x0_T ] = Turbine_fx(Junc, Condition, Component(i), Mechanics);
            
            tl = [Component(i).inJunc, Component(i).outJunc];
            
            for j=1:2
                delT = Junc(tl(j)).T * Condition.delt;
                delP = Junc(tl(j)).P * Condition.delt;
                
                Junc(tl(j)).T = Junc(tl(j)).T + delT;
                
                [ f_xdT_T ] = Turbine_fx(Junc, Condition, Component(i), Mechanics);
                
                Junc(tl(j)).T = Junc(tl(j)).T - delT;
                
                Junc(tl(j)).P = Junc(tl(j)).P + delP;
                
                [ f_xdP_T ] = Turbine_fx(Junc, Condition, Component(i), Mechanics);
                
                Junc(tl(j)).P = Junc(tl(j)).P - delP;
                
                %%%%%
                
                f_xx(cnt, :, tl(j)+Num_junc) = (f_xdT_T - f_x0_T)/delT;
                f_xx(cnt, :, tl(j)) = (f_xdP_T - f_x0_T)/delP;
            end
            
            cnt = cnt+1;
            
        case 'Valve'
            
            [ f_x0_V ] = Valve_fx(Junc, Condition, Component(i), Mechanics);
            
            tl = [Component(i).inJunc, Component(i).outJunc];
            
            for j=1:2
                delT = Junc(tl(j)).T * Condition.delt;
                delP = Junc(tl(j)).P * Condition.delt;
                
                Junc(tl(j)).T = Junc(tl(j)).T + delT;
                
                [ f_xdT_V ] = Valve_fx(Junc, Condition, Component(i), Mechanics);
                
                Junc(tl(j)).T = Junc(tl(j)).T - delT;
                
                Junc(tl(j)).P = Junc(tl(j)).P + delP;
                
                [ f_xdP_V ] = Valve_fx(Junc, Condition, Component(i), Mechanics);
                
                Junc(tl(j)).P = Junc(tl(j)).P - delP;
                
                %%%%%
                
                f_xx(cnt, :, tl(j)+Num_junc) = (f_xdT_V - f_x0_V)/delT;
                f_xx(cnt, :, tl(j)) = (f_xdP_V - f_x0_V)/delP;
            end
            
            cnt = cnt+1;
            
        case 'Compressor'
            
            [ f_x0_C ] = Compressor_fx(Junc, Condition, Component(i), Mechanics);
            
            tl = [Component(i).inJunc, Component(i).outJunc];
            
            for j=1:2
                delT = Junc(tl(j)).T * Condition.delt;
                delP = Junc(tl(j)).P * Condition.delt;
                
                Junc(tl(j)).T = Junc(tl(j)).T + delT;
                
                [ f_xdT_C ] = Compressor_fx(Junc, Condition, Component(i), Mechanics);
                
                Junc(tl(j)).T = Junc(tl(j)).T - delT;
                
                Junc(tl(j)).P = Junc(tl(j)).P + delP;
                
                [ f_xdP_C ] = Compressor_fx(Junc, Condition, Component(i), Mechanics);
                
                Junc(tl(j)).P = Junc(tl(j)).P - delP;
                
                %%%%%
                
                f_xx(cnt, :, tl(j)+Num_junc) = (f_xdT_C - f_x0_C)/delT;
                f_xx(cnt, :, tl(j)) = (f_xdP_C - f_x0_C)/delP;
            end
            
            cnt = cnt+1;
            
        case 'Recuperator'
            
            
            tl = [Component(i).inJunc(1), Component(i).inJunc(2), Component(i).outJunc(1), Component(i).outJunc(2)];
            
            [ f_x0_RC ] = Recuperator_fx(Junc, Condition, Component(i), Mechanics);
            
            for j=1:4
                
                dT = Junc(tl(j)).T * Condition.delt;
                dP = Junc(tl(j)).P * Condition.delt;
                
                Junc(tl(j)).T = Junc(tl(j)).T + dT;
                
                [ f_xdT_RC ] = Recuperator_fx(Junc, Condition, Component(i), Mechanics);
                
                Junc(tl(j)).T = Junc(tl(j)).T - dT;
                
                Junc(tl(j)).P = Junc(tl(j)).P + dP;
                
                [ f_xdP_RC ] = Recuperator_fx(Junc, Condition, Component(i), Mechanics);
                
                Junc(tl(j)).P = Junc(tl(j)).P - dP;
                
                f_xx(cnt, :, tl(j)) = (f_xdP_RC(1, :) - f_x0_RC(1, :))/dP;
                f_xx(cnt+1, :,  tl(j)) = (f_xdP_RC(2, :) - f_x0_RC(2, :))/dP;
                
                f_xx(cnt, :, tl(j) + Num_junc) = (f_xdT_RC(1, :) - f_x0_RC(1, :))/dT;
                f_xx(cnt+1, :,  tl(j) + Num_junc) = (f_xdT_RC(2, :) - f_x0_RC(2, :))/dT;
                
            end
            cnt = cnt+2;
            
        case 'WHR'
            
            
            tl = [Component(i).inJunc(1), Component(i).inJunc(2), Component(i).outJunc(1), Component(i).outJunc(2)];
            
            [ f_x0_WHR ] = WHR_fx(Junc, Condition, Component(i), Mechanics);
            
            for j=1:4
                
                dT = Junc(tl(j)).T * Condition.delt;
                dP = Junc(tl(j)).P * Condition.delt;
                
                Junc(tl(j)).T = Junc(tl(j)).T + dT;
                
                [ f_xdT_WHR ] = WHR_fx(Junc, Condition, Component(i), Mechanics);
                
                Junc(tl(j)).T = Junc(tl(j)).T - dT;
                
                Junc(tl(j)).P = Junc(tl(j)).P + dP;
                
                [ f_xdP_WHR ] = WHR_fx(Junc, Condition, Component(i), Mechanics);
                
                Junc(tl(j)).P = Junc(tl(j)).P - dP;
                
                f_xx(cnt, :, tl(j)) = (f_xdP_WHR(1, :) - f_x0_WHR(1, :))/dP;
                f_xx(cnt+1, :,  tl(j)) = (f_xdP_WHR(2, :) - f_x0_WHR(2, :))/dP;
                
                f_xx(cnt, :, tl(j) + Num_junc) = (f_xdT_WHR(1, :) - f_x0_WHR(1, :))/dT;
                f_xx(cnt+1, :,  tl(j) + Num_junc) = (f_xdT_WHR(2, :) - f_x0_WHR(2, :))/dT;
                
            end
            cnt = cnt+2;
            
        case 'Junction'
            if(size(Component(i).inJunc, 2) == 1)
                for j=1:size(Component(i).outJunc, 2)
                    cnt = cnt+1;
                end
            else
                
                [f_x0_J] = Junction_fx(Junc, Condition, Component(i));
                
                tl = [Component(i).inJunc(1), Component(i).inJunc(2), Component(i).outJunc];
                
                for j=1:3
                    
                    if(Junc(tl(j)).m_flow_rate == 0)
                        
                        f_xx(cnt, :, tl(j) + Num_junc) = 0;
                        f_xx(cnt, :, tl(j)) = 0;
                        
                    else
                        delT = Junc(tl(j)).T * Condition.delt;
                        delP = Junc(tl(j)).P * Condition.delt;
                        
                        Junc(tl(j)).T = Junc(tl(j)).T + delT;
                        
                        [f_xdT_J] = Junction_fx(Junc, Condition, Component(i));
                        
                        Junc(tl(j)).T = Junc(tl(j)).T - delT;
                        
                        Junc(tl(j)).P = Junc(tl(j)).P + delP;
                        
                        [f_xdP_J] = Junction_fx(Junc, Condition, Component(i));
                        
                        Junc(tl(j)).P = Junc(tl(j)).P - delP;
                        
                        %%%%
                        
                        f_xx(cnt, :, tl(j)+Num_junc) = (f_xdT_J - f_x0_J)/delT;
                        f_xx(cnt, :, tl(j)) = (f_xdP_J - f_x0_J)/delP;
                    end
                end
                
                cnt = cnt+1;
            end
    end
end

end

