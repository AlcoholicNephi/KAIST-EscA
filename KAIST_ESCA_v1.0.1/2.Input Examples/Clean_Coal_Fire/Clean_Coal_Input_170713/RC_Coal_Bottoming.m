close all
clear
% clc

% addpath(genpath('D:\Dropbox\MATLAB\Now_Working\KAIST_ACOD_release_v1\KAIST_CCD_Seongmin'))

% Generalized CCD - 20170619 ~
% Single IHX cases
% Cooler / TIT : T bounded
% Main compressor : P bounded

CRC_condition
CRC_layout
CRC_machine_property

% System Boundary Condition
Condition.delt = 1e-6;
Condition.Q_in = 18.929*1E6;    

Condition.T_bound.ID = [6, 1];
Condition.T_bound.value = [24 + 273.15, 500 + 273.15];
Condition.P_bound.ID = 7;
Condition.P_bound.value = 20000;

iParameters.name = {'Mechanics.Turbine(1).P_ratio', 'Condition.split(1)'};
iParameters.value = [2.0, 0.5];
iParameters.max = [3.5, 0.8];
iParameters.min = [1.5, 0.4];
% iParameters.criteria = [2, 0.5];

% iParameters.value = [2.2, 0.9, 0.84, 0.84];

% mu_0 = 0.1; % damping factor

% tic()

Mechanics.Turbine(1).P_ratio = 2.6154;
Condition.split(1) = 0.647180;

[Junc, info] = Steady_Solver(Condition, Component, Mechanics);
Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)


for i=1:31
   Mechanics.Turbine(1).P_ratio = 2.6154 - 1 + 2/30 *(i-1); 
   [Junc, info] = Steady_Solver(Condition, Component, Mechanics);
   x(i) = Mechanics.Turbine(1).P_ratio;
   y(i) = info.Eff * 100;
i
end

Mechanics.Turbine(1).P_ratio = 2.6154;
Condition.split(1) = 0.647180;

for i=1:31
   Condition.split(1) = 0.647180 - 0.2 + 0.4/30 * (i-1);
   [Junc, info] = Steady_Solver(Condition, Component, Mechanics);
   x2(i) = Condition.split(1);
   y2(i) = info.Eff * 100;
i
end

subplot(1, 2, 1)

x0ref = [2.6154,2.6154];
y0ref = [34, 46];
hold on
plot(x0ref, y0ref, 'k--')
plot(x, y, 'k', 'linewidth', 1.2)
xlim([1.5, 3.7])
xlabel('Turbine Pressure Ratio')
ylabel('Cycle Thermal Efficiency (%)')
legend('Optimized Design Point')
grid on

subplot(1, 2, 2)

x1ref = [64.7180, 64.7180];
y1ref = [40, 46];
hold on
plot(x1ref, y1ref, 'k--')
plot(x2*100, y2, 'k', 'linewidth', 1.2)
% xlim([1.5, 3.7])
xlabel('Main Compressor Split (%)')
ylabel('Cycle Thermal Efficiency (%)')
legend('Optimized Design Point')
grid on
