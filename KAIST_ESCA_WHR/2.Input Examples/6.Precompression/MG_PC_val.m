close all
clear
% clc

addpath(genpath('D:\Dropbox\MATLAB\Now_Working\KAIST-ESCA\KAIST_ESCA_WHR'))

% Generalized CCD - 20170619 ~
% Single IHX cases
% Cooler / TIT : T bounded
% Main compressor : P bounded

MG_PC_condition
MG_PC_layout
MG_PC_machine_property

% System Boundary Condition
Condition.delt = 1e-4;
Condition.relaxation = 3;
Condition.Error_bound = 1e-7;

mu_0 = 3;

Condition.Pri_m = 16.28;
Condition.T_bound.ID = [6, 10];
Condition.T_bound.value = [32 + 273.15, 560 + 273.15];
Condition.P_bound.ID = [7, 10];
Condition.P_bound.value = [13850, 103];
Condition.Problem = 'Work';



Condition.m_flow_rate = 28.163;
Mechanics.Turbine(1).P_ratio = 1.7896;
Mechanics.Compressor(1).P_ratio = 1.0725;


[Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)

% iParameters.name = {'Condition.m_flow_rate', 'Mechanics.Turbine(1).P_ratio', 'Mechanics.Compressor(1).P_ratio'};
% iParameters.value = [30, 13850/7400, 1.1];
% iParameters.max = [80, 3.0, 13850/10000];
% iParameters.min = [12, 1.2, 1.0];

% [P, Junc, info] = Cycle_Optimizer_WHR(Condition, Component, Mechanics, iParameters, mu_0);





subplot(1, 3, 1)

Condition.m_flow_rate = 28.163;
Mechanics.Turbine(1).P_ratio = 1.7896;
Mechanics.Compressor(1).P_ratio = 1.0725;

for i=1:7
    Condition.m_flow_rate = 28.163 * 0.9 + 28.163 * 0.2/6*(i-1);
    x1(i) = Condition.m_flow_rate;
    [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
    y1(i) = info.Net_work;
    
    plot(x1, y1)
    drawnow
end

subplot(1, 3, 2)

Condition.m_flow_rate = 28.163;
Mechanics.Turbine(1).P_ratio = 1.7896;
Mechanics.Compressor(1).P_ratio = 1.0725;

for i=1:7
    Mechanics.Turbine(1).P_ratio = 1.7896 * 0.9 + 1.7896*0.2/6*(i-1);
    x2(i) = Mechanics.Turbine(1).P_ratio;
    [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
    y2(i) = info.Net_work;
    
    plot(x2, y2)
    drawnow
end

subplot(1, 3, 3)

Condition.m_flow_rate = 28.163;
Mechanics.Turbine(1).P_ratio = 1.7896;
Mechanics.Compressor(1).P_ratio = 1.0725;

for i=1:7
    Mechanics.Compressor(1).P_ratio = 1.0725 * 0.9 + 1.0725*0.2/6*(i-1);
    x3(i) = Mechanics.Compressor(1).P_ratio;
    [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
    y3(i) = info.Net_work;
    
    plot(x3, y3)
    drawnow
end


