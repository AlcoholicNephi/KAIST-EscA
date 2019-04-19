close all
clear
% clc

addpath(genpath('D:\Dropbox\MATLAB\Now_Working\KAIST-ESCA\KAIST_ESCA_WHR'))

% Generalized CCD - 20170619 ~
% Single IHX cases
% Cooler / TIT : T bounded
% Main compressor : P bounded

MG_BC3_condition
MG_BC3_layout
MG_BC3_machine_property

% System Boundary Condition
Condition.delt = 1e-4;
Condition.relaxation = 3;
Condition.Error_bound = 1e-7;

mu_0 = 0.1;

Condition.Pri_m = 16.28;
Condition.T_bound.ID = [6, 8, 19];
Condition.T_bound.value = [32 + 273.15, 32 + 273.15, 500 + 273.15];
Condition.P_bound.ID = [9, 19];
Condition.P_bound.value = [13850, 103];
Condition.Problem = 'Work';

[Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)

iParameters.name = {'Condition.m_flow_rate', 'Mechanics.Turbine(1).P_ratio', 'Mechanics.Compressor(1).P_ratio', 'Condition.split(1)', 'Condition.split(3)'};
iParameters.value = [32, 13850/7500, 10000/7500, 0.4, 0.5];
iParameters.max = [60, 3.0, 12000/7500, 0.8, 0.8];
iParameters.min = [12, 1.2, 1.00, 0.2, 0.3];






Parameters = iParameters.name;

Parameters_value = iParameters.value;

Parameters_min = iParameters.min;

Parameters_max = iParameters.max;


for j=1:size(Parameters, 2)
    eval([Parameters{j}, ' = Parameters_value(j);'])
end

[Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);


[Jacobian] = Gradient_Solver(iParameters, Junc, Component, Mechanics, Condition);

Direction = Jacobian / norm(Jacobian);

Old_Parameters_value = Parameters_value;
g0 = get_g(Condition, Junc, Component);

STEP_initial = 0.01;

siter = 1;
iter = 2;
BFGS = eye(size(Parameters, 2));  %%%% Initial

while(1)
    
    Parameters_value = Old_Parameters_value + STEP_initial * Direction;

    for j=1:size(Parameters, 2)
        eval([Parameters{j}, ' = Parameters_value(j);'])
    end
    
    [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
    disp(['Small Iteration # : ', num2str(siter), '    Eff : ', num2str(info.Eff * 100), '   Net work : ' , num2str(info.Net_work/1e6)])

    g1 = get_g(Condition, Junc, Component);
    
    if(g1 > g0)
        break;
    else
        STEP_initial = STEP_initial / 2;
    end
    
    siter = siter+1;
end

Condition.Max_STEP = 0.1;

disp('======================================================================================')
disp(['Iteration # : ', num2str(iter), '    Eff : ', num2str(info.Eff * 100), '   Net work : ' , num2str(info.Net_work/1e6)])
str = [];
for i=1:size(Parameters, 2)
    str = [str, num2str(Parameters_value(i)), '     '];
end
disp(['Design Parameters : ', str])
disp('======================================================================================')

% while(1)
for jjj=1:100
    iter = iter+1;
    
    [Jacobian_new] = Gradient_Solver(iParameters, Junc, Component, Mechanics, Condition);
    
    Jacobian_test = Jacobian_new;

    y = transpose(Jacobian_new - Jacobian);
    s = transpose(Parameters_value - Old_Parameters_value);
    
    BFGS_new = BFGS + (y * transpose(y)) / (transpose(y) * s) - (BFGS * s * transpose(s) * BFGS) / (transpose(s) * BFGS * s);
    
    Damping = 0;
    
    
    if(norm(Direction) > 0.1)
        Direction = Direction / norm(Direction) * 0.1;
    end
    
    % Update
    
    Old_Parameters_value = Parameters_value;
    Jacobian = Jacobian_new;
    g0 = g1;
    TF = 1;
    
    siter = 0;
    while(1)
        
        Direction = -1 * (BFGS_new + Damping * diag(diag(BFGS_new))) \ transpose(Jacobian_new);
        
        siter = siter + 1;
        
        
        
        if(norm(Direction) > Condition.Max_STEP)
            Direction = Direction / norm(Direction) * Condition.Max_STEP;
        end
        
        Parameters_value = Old_Parameters_value + transpose(Direction);
        
        %             %%%%
        %             if(Parameters_value(1) > 7200)
        %                 Parameters_value(1) = 7200;
        %             end
        %             %%%%
        
        for j=1:size(Parameters, 2)
            eval([Parameters{j}, ' = Parameters_value(j);'])
        end
        
        
        [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
        disp(['Small Iteration # : ', num2str(siter), '    Eff : ', num2str(info.Eff * 100), '   Net work : ' , num2str(info.Net_work/1e6)])
        %
        %     str = [];
        %     for j=1:size(Parameters, 2)
        %         str = [Parameters(j), ' : ', num2str(Parameters_value(j)), str];
        %     end
        %     disp(str)
        
        g1 = get_g(Condition, Junc, Component);

        if(g1 > g0)
            break;
        else
            if(siter == 1)
                Damping = mu_0;
            else
                Damping = Damping * 2;
            end
        end
        
        [Jacobian_new] = Gradient_Solver(iParameters, Junc, Component, Mechanics, Condition);
        y = transpose(Jacobian_new - Jacobian);
        s = transpose(Parameters_value - Old_Parameters_value);
        
        BFGS_new = BFGS + (y * transpose(y)) / (transpose(y) * s) - (BFGS * s * transpose(s) * BFGS) / (transpose(s) * BFGS * s);
        
        if(siter > 15)
            TF = -1;
            break;
        end
    end
    
    %         if(abs(g1-g0)/g1 < 1e-5)
    %             break;
    %         end
    
    if(norm(Jacobian_new) < 2e-5)
        if(iter>6)
            break;
        end
    end
    
    
    disp('======================================================================================')
    disp(['Iteration # : ', num2str(iter), '    Eff : ', num2str(info.Eff * 100), '   Net work : ' , num2str(info.Net_work/1e6)])
    str = [];
    for i=1:size(Parameters, 2)
        str = [str, num2str(Parameters_value(i)), '     '];
    end
    disp(['Design Parameters : ', str])
    disp('======================================================================================')
    
    BFGS = BFGS_new;
end



% [P, Junc, info] = Cycle_Optimizer_WHR(Condition, Component, Mechanics, iParameters, mu_0);

%
%
% Condition.m_flow_rate = 29.8725;
% Mechanics.Turbine(1).P_ratio = 1.87;
% Mechanics.Compressor(1).P_ratio = 1.1269;
% Condition.split(1) = 0.34993;
% Condition.split(3) = 0.50434;
%
%
% [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
% Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)
%
% for i=1:7
%    Condition.m_flow_rate =  29.8725 - 6 + 2*(i-1);
%    x1(i) = Condition.m_flow_rate;
%
%    [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
%
%    y1(i) = info.Net_work / 1e6;
%
%    plot(x1, y1)
%    drawnow;
% end
%
%
%
%
%
%
