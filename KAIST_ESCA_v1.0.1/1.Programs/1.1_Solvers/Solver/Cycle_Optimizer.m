function [P, Junc, info] = Cycle_Optimizer(Condition, Component, Mechanics, iParameters, mu_0)

Parameters = iParameters.name;

Parameters_now = iParameters.value;

Parameters_min = iParameters.min;

Parameters_max = iParameters.max;

% Parameters_criteria = iParameters.criteria;

% Initialization


% old_Parameters = Parameters_now;
% old_g = -1;
% dg = -1;
mu = mu_0;
% oldg00 = -1;

jjj = 0;
jjjj = 0;
kkk = 0;

while(1)
    
    jjj = jjj+1;
    
    for i=1:size(Parameters, 2)
        eval([Parameters{i}, ' = ', num2str(Parameters_now(i)), ';'])
    end
    
    [Junc, info] = Steady_Solver(Condition, Component, Mechanics);
    
    %     Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)
    
    Eff = info.Net_work / Condition.Q_in;
    
    PARA(jjj, :) = Parameters_now;
    EFFF(jjj) = Eff;
    
    g0 = get_g(Condition, Junc, Component);
    
    old_Parameters = Parameters_now;
    old_g = g0;
    
    str = [];
    for i=1:size(Parameters, 2)
        str = [str, num2str(Parameters_now(i)), '     '];
    end
    
    jjjj = jjjj+1;
    
    disp(' ')
    disp('//////////////////////////////////////////////////////////////////////')
    disp(['Try # : ', num2str(jjjj)])
    disp(' ')
    disp(['Design Parameters : ', str])
    
    disp(' ')
    disp(['Cycle Net Work (MW) = ', num2str(info.Net_work / 1e6)]);
    disp(['Cycle Efficiency (%) = ', num2str(info.Net_work / Condition.Q_in)]);
    
    % Set reference
    
    disp('Calculating start...')
    
    kkk = kkk+1;
    P(kkk, :) = [Parameters_now, Eff, 1];
    
    mu = mu/Condition.relaxation;
    %         mu = mu_0;
    
    disp(' ')
    disp('Adjoint Sensitivity / Hessian analysis start...')
    
    [ Jacobian, Hessian ] = Adjoint_Solver(iParameters, Junc, Component, Mechanics, Condition);
    
    
    % Levenberg - Marquardt Method
    
    STEPS = -1 * transpose( (Hessian + mu * diag(diag(Hessian))) \ transpose(Jacobian));
    
    dg = (0.3 * STEPS * transpose(Jacobian));
    
    if(dg<0)
        STEPS = -STEPS;
    end
    
    Parameters_now = Parameters_now + STEPS;
    
    for i=1:size(Parameters, 2)
        if(Parameters_now(i) > Parameters_max(i))
            Parameters_now(i) = Parameters_max(i);
        elseif(Parameters_now(i) < Parameters_min(i))
            Parameters_now(i) = Parameters_min(i);
        end
    end
    
    STEPS = Parameters_now - old_Parameters;
    
    dg = (0.3 * STEPS * transpose(Jacobian));
    
    dg = abs(dg);
    
    
    while(1)
        
        for i=1:size(Parameters, 2)
            eval([Parameters{i}, ' = ', num2str(Parameters_now(i)), ';'])
        end
        
        [Junc, info] = Steady_Solver(Condition, Component, Mechanics);
        
        g0 = get_g(Condition, Junc, Component);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %         str = [];
        %
        %         for i=1:size(Parameters, 2)
        %             str = [str, num2str(Parameters_now(i)), '     '];
        %         end
        %
        %
        %
        %         disp(' ')
        %         disp(['Design Parameters : ', str])
        %         disp(['Cycle Net Work (MW) = ', num2str(info.Net_work / 1e6)]);
        %         disp(['Cycle Efficiency (%) = ', num2str(info.Net_work / Condition.Q_in)]);
        %         disp(['dg = ', num2str(dg)])
        %         disp(['g0 = ', num2str(g0)])
        %         disp(['oldg = ', num2str(old_g)])
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if(g0 > old_g + dg)
            break;
        else
            Parameters_now = old_Parameters;
            
            kkk = kkk+1;
            P(kkk, :) = [Parameters_now, Eff, -1];
            
            mu = mu*2;
            
            disp(' ')
            disp('Re calculation with previous Jacobian/Hessian...')
            
            % Levenberg?Marquardt Method
            
            STEPS = -1 * transpose( (Hessian + mu * diag(diag(Hessian))) \ transpose(Jacobian));
            
            dg = (0.3 * STEPS * transpose(Jacobian));
            
            if(dg<0)
                STEPS = -STEPS;
            end
            
            Parameters_now = Parameters_now + STEPS;
            
            for i=1:size(Parameters, 2)
                if(Parameters_now(i) > Parameters_max(i))
                    Parameters_now(i) = Parameters_max(i);
                elseif(Parameters_now(i) < Parameters_min(i))
                    Parameters_now(i) = Parameters_min(i);
                end
            end
            
            STEPS = Parameters_now - old_Parameters;
            
            dg = (0.3 * STEPS * transpose(Jacobian));
            
            if(dg<0)
                STEPS = -STEPS;
            end
            
            dg = abs(dg);
            
            %         Parameters_now = Parameters_backup + STEPS;
            
            str = [];
            for i=1:size(Parameters, 2)
                str = [str, num2str(STEPS(i)), '     '];
            end
            
            disp(['Calculated Steps : ', str])
            
            disp(['Expected dg : ', num2str(dg), '      mu : ', num2str(mu)])
        end
        if(dg / g0 < Condition.Error_bound)
            if(old_g > g0)
                Parameters_now = old_Parameters;
            end
            break;
        end
    end
    if(dg / g0 < Condition.Error_bound)
        if(old_g > g0)
            Parameters_now = old_Parameters;
        end
        break;
    end
end
str = [];
for i=1:size(Parameters, 2)
    str = [str, num2str(Parameters_now(i)), '     '];
end

disp(' ')
disp('//////////////////////////////////////////////////////////////////////')
disp(' ')
disp(['Design Parameters : ', str])


% Set reference

%     disp('Calculating start...')

for i=1:size(Parameters, 2)
    eval([Parameters{i}, ' = ', num2str(Parameters_now(i)), ';'])
end

[Junc, info] = Steady_Solver(Condition, Component, Mechanics);

Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)

end

