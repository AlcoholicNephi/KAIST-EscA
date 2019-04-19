close all
clear
% clc

addpath(genpath('D:\Dropbox\MATLAB\Now_Working\KAIST-ESCA\KAIST_ESCA_WHR'))

% Generalized CCD - 20170619 ~
% Single IHX cases
% Cooler / TIT : T bounded
% Main compressor : P bounded

MG_SR_condition
MG_SR_layout
MG_SR_machine_property

% System Boundary Condition
Condition.delt = 1e-4;
Condition.relaxation = 3;
Condition.Error_bound = 1e-7;

Condition.Pri_m = 16.28;
Condition.T_bound.ID = [4, 7];
Condition.T_bound.value = [32 + 273.15, 500 + 273.15];
Condition.P_bound.ID = [5, 7];
Condition.P_bound.value = [13850, 103];
Condition.Problem = 'Work';

Mechanics.Turbine(1).P_ratio = 2;

iParameters.name = {'Condition.m_flow_rate', 'Mechanics.Turbine(1).P_ratio'};
iParameters.value = [30, 13850/7400];
iParameters.max = [80, 3.0];
iParameters.min = [12, 1.2];

mu_0 = 0.1; % damping factor


[Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)

% [P, Junc, info] = Cycle_Optimizer_WHR(Condition, Component, Mechanics, iParameters, mu_0);
  

Condition.m_flow_rate = 24.1881;
Mechanics.Turbine(1).P_ratio = 1.7204;

[Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)


T_ref = 1.7204;
m_ref = 24.1881;

for i=1:11
   Condition.m_flow_rate = m_ref - m_ref * 0.1 + m_ref * 0.2 / 10 * (i-1);
   [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
   x1(i) = Condition.m_flow_rate;
   y1(i) = info.Net_work;
   
   plot(x1, y1)
   drawnow
end

Condition.m_flow_rate = 24.1881;
Mechanics.Turbine(1).P_ratio = 1.7204;

T_ref = 1.7204;
m_ref = 24.1881;
figure(2)
for i=1:11
   Mechanics.Turbine(1).P_ratio = T_ref - T_ref * 0.1 + T_ref * 0.2 / 10 * (i-1);
   [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
   x2(i) = Mechanics.Turbine(1).P_ratio;
   y2(i) = info.Net_work;
   
   plot(x2, y2)
   drawnow
end



figure(1)
subplot(1, 2, 1)
hold on
x11 = [x1(6), x1(6)];
y11 = [715, 730];
plot(x11, y11, 'r--', 'linewidth', 1.2)
plot(x1, y1/1e3, 'k', 'linewidth', 1.2)
legend('Optimum')

title('Design Parameter #1')
xlabel('System Mass Flow Rate (kg/s)')
ylabel('Cycle Thermal Work (kW)')
ylim([719, 727])
grid on


subplot(1, 2, 2)
hold on
x11 = [x2(6), x2(6)];
y11 = [500, 740];
plot(x11, y11, 'r--', 'linewidth', 1.2)
plot(x2, y2/1e3, 'k', 'linewidth', 1.2)
legend('Optimum')
title('Design Parameter #2')
xlabel('Compressor Pressure Ratio')
ylabel('Cycle Thermal Work (kW)')
ylim([560, 740])
grid on

