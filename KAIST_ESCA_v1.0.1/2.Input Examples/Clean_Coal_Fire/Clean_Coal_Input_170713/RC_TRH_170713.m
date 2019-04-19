close all
clear
% clc

addpath(genpath('D:\Dropbox\MATLAB\Now_Working\Quasi\KAIST_ACOD_QED_module\2.Input Examples\Clean_Coal_Fire'))

% TRH (Triple Reheat Cycle) for 청정화력 Topping

RC_TRH_condition
RC_TRH_layout
RC_TRH_machine_property

% System Boundary Condition

Condition.Error_bound = 1E-07;                                       % Error bound (%)
Condition.Q_in = 206.72*1E6;                                          % Q_in, W
Condition.split = [0.67, 0.33];
Condition.split_link = [1, 2];                          % Linked split indicator
Condition.split_link_value = [1];

% System Boundary Condition

Condition.T_bound.ID = [16, 5, 7, 9];
Condition.T_bound.value = [32 + 273.15, 600 + 273.15, 600 + 273.15, 600 + 273.15];
Condition.P_bound.ID = 1;
Condition.P_bound.value = 20000;

iParameters.name = {'Mechanics.Turbine(1).P_ratio', 'Mechanics.Turbine(2).P_ratio', 'Mechanics.Turbine(3).P_ratio', 'Condition.split(1)'};
iParameters.value = [1.28, 1.28, 1.28, 0.5];
% iParameters.value = [1.2, 1.2, 1.2, 0.5];
iParameters.max = [1.8, 1.8, 1.8, 0.8];
iParameters.min = [1.05, 1.05, 1.05, 0.4];
% iParameters.criteria = [2, 0.5];

% iParameters.value = [2.2, 0.9, 0.84, 0.84];

mu_0 = 0.1; % damping factor

Mechanics.Turbine(1).P_ratio = 1.3501;
Mechanics.Turbine(2).P_ratio = 1.3509;
Mechanics.Turbine(3).P_ratio = 1.3838;
Condition.split(1) = 0.6425;



[Junc, info] = Steady_Solver(Condition, Component, Mechanics);
Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)
% 
% [P, Junc, info] = Cycle_Optimizer(Condition, Component, Mechanics, iParameters, mu_0);
% Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)

figure(1)
hold on

for i=1:11
    i
    delt = -0.2 + 0.4/10 * (i-1);
    
    x1(i) = 1.3501 + delt;
    x2(i) = 1.3509 + delt;
    x3(i) = 1.3838 + delt;
    x4(i) = 0.6425 + delt;
    x(i) = delt;
    
    Mechanics.Turbine(1).P_ratio = Mechanics.Turbine(1).P_ratio + delt;
    [Junc, info] = Steady_Solver(Condition, Component, Mechanics);
    
    y1(i) = info.Eff;
    Mechanics.Turbine(1).P_ratio = Mechanics.Turbine(1).P_ratio - delt;
    
    Mechanics.Turbine(2).P_ratio = Mechanics.Turbine(2).P_ratio + delt;
    [Junc, info] = Steady_Solver(Condition, Component, Mechanics);
    
    y2(i) = info.Eff;
    Mechanics.Turbine(2).P_ratio = Mechanics.Turbine(2).P_ratio - delt;
    
    Mechanics.Turbine(3).P_ratio = Mechanics.Turbine(3).P_ratio + delt;
    [Junc, info] = Steady_Solver(Condition, Component, Mechanics);
    
    y3(i) = info.Eff;
    Mechanics.Turbine(3).P_ratio = Mechanics.Turbine(3).P_ratio - delt;
    
    Condition.split(1) = Condition.split(1) + delt;
    [Junc, info] = Steady_Solver(Condition, Component, Mechanics);
    
    y4(i) = info.Eff;
    
    Condition.split(1) = Condition.split(1) - delt; 
    
    plot(x, y1 * 100, 'linewidth', 1.2)
    plot(x, y2 * 100, 'linewidth', 1.2)
    plot(x, y3 * 100, 'linewidth', 1.2)
    plot(x, y4 * 100, 'linewidth', 1.2)
    xlabel('Delt from optimum')
    ylabel('Cycle Thermal Efficiency (%)')
    legend('HT P Ratio', 'MT P Ratio', 'LT P Ratio', 'Main Compressor Split')
    
    drawnow
    
end

figure(3)

hold on
    xx = [0,0]
    yy = [44, 51]
    plot(xx, yy, 'r--')
    plot(x, y1 * 100, 'ko', 'linewidth', 1.2)
    plot(x, y2 * 100, 'k.', 'linewidth', 1.2)
    plot(x, y3 * 100, 'k--', 'linewidth', 1.2)
    plot(x, y4 * 100, 'k', 'linewidth', 1.2)
    xlabel('Delt from optimum')
    ylabel('Cycle Thermal Efficiency (%)')

    legend('Optimized Design Point', 'HT P Ratio', 'MT P Ratio', 'LT P Ratio', 'Main Compressor Split')
    grid on
    
    
    
    