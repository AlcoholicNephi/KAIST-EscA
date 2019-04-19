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

% subplot(2, 3, 1)

Condition.m_flow_rate = 31.707;
Mechanics.Turbine(1).P_ratio = 1.9632;
Mechanics.Compressor(1).P_ratio = 1.1708;
Condition.split(1) = 0.32497;
Condition.split(3) = 0.47717;

[Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)
% 
% % Parameters = {'Condition.m_flow_rate', 'Mechanics.Turbine(1).P_ratio', 'Mechanics.Compressor(1).P_ratio', 'Condition.split(1)', 'Condition.split(3)'};
% 
% for i=1:7
%     Condition.m_flow_rate = 31.707 - 31.707*0.1 + 31.707*0.2 / 6 * (i-1);
%     x1(i) = Condition.m_flow_rate;
%     [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
%     y1(i) = info.Net_work;
%     
%     plot(x1, y1)
%     drawnow
% end
% 
% 
% 
% 
% subplot(2, 3, 2)
% 
% Condition.m_flow_rate = 31.707;
% Mechanics.Turbine(1).P_ratio = 1.9632;
% Mechanics.Compressor(1).P_ratio = 1.1708;
% Condition.split(1) = 0.32497;
% Condition.split(3) = 0.47717;
% 
% % [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
% % Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)
% 
% % Parameters = {'Condition.m_flow_rate', 'Mechanics.Turbine(1).P_ratio', 'Mechanics.Compressor(1).P_ratio', 'Condition.split(1)', 'Condition.split(3)'};
% 
% for i=1:7
%     Mechanics.Turbine(1).P_ratio = 1.9632 - 1.9632*0.1 + 1.9632*0.2/6*(i-1);
%     x2(i) = Mechanics.Turbine(1).P_ratio;
%     [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
%     y2(i) = info.Net_work;
%     
%     plot(x2, y2)
%     drawnow
% end
% 
% 
% 
% subplot(2, 3, 3)
% 
% Condition.m_flow_rate = 31.707;
% Mechanics.Turbine(1).P_ratio = 1.9632;
% Mechanics.Compressor(1).P_ratio = 1.1708;
% Condition.split(1) = 0.32497;
% Condition.split(3) = 0.47717;
% 
% % [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
% % Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)
% 
% % Parameters = {'Condition.m_flow_rate', 'Mechanics.Turbine(1).P_ratio', 'Mechanics.Compressor(1).P_ratio', 'Condition.split(1)', 'Condition.split(3)'};
% 
% for i=1:7
%     Mechanics.Compressor(1).P_ratio = 1.1708 - 1.1708*0.1 + 1.1708*0.2/6*(i-1);
%     x3(i) = Mechanics.Compressor(1).P_ratio;
%     [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
%     y3(i) = info.Net_work;
%     
%     plot(x3, y3)
%     drawnow
% end
% 
% 
% 
% 
% 
% subplot(2, 3, 4)
% 
% Condition.m_flow_rate = 31.707;
% Mechanics.Turbine(1).P_ratio = 1.9632;
% Mechanics.Compressor(1).P_ratio = 1.1708;
% Condition.split(1) = 0.32497;
% Condition.split(3) = 0.47717;
% 
% % [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
% % Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)
% 
% % Parameters = {'Condition.m_flow_rate', 'Mechanics.Turbine(1).P_ratio', 'Mechanics.Compressor(1).P_ratio', 'Condition.split(1)', 'Condition.split(3)'};
% 
% for i=1:7
%     Condition.split(1) = 0.32497 * 0.9 + 0.32497*0.2/6*(i-1);
%     x4(i) = Condition.split(1);
%     [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
%     y4(i) = info.Net_work;
%     
%     plot(x4, y4)
%     drawnow
% end
% 
% 
% 
% 
% subplot(2, 3, 5)
% 
% Condition.m_flow_rate = 31.707;
% Mechanics.Turbine(1).P_ratio = 1.9632;
% Mechanics.Compressor(1).P_ratio = 1.1708;
% Condition.split(1) = 0.32497;
% Condition.split(3) = 0.47717;
% 
% % [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
% % Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)
% 
% % Parameters = {'Condition.m_flow_rate', 'Mechanics.Turbine(1).P_ratio', 'Mechanics.Compressor(1).P_ratio', 'Condition.split(1)', 'Condition.split(3)'};
% 
% for i=1:7
%     Condition.split(3) = 0.47717 * 0.9 + 0.47717*0.2 *(i-1)/6;
%     x5(i) = Condition.split(3);
%     [Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
%     y5(i) = info.Net_work;
%     
%     plot(x5, y5)
%     drawnow
% end
% 
% 
% 
% % Parameters = {'Condition.m_flow_rate', 'Mechanics.Turbine(1).P_ratio', 'Mechanics.Compressor(1).P_ratio', 'Condition.split(1)', 'Condition.split(3)'};

figure(1)
subplot(3, 2, 1)
hold on
x11 = [x1(4), x1(4)];
y11 = [y1(1)/1e3 - 5, y1(4)/1e3 + 5];
plot(x11, y11, 'r--', 'linewidth', 1.2)
plot(x1, y1/1e3, 'k', 'linewidth', 1.2)
legend('Optimum')

title('Design Parameter #1')
xlabel('System Mass Flow Rate (kg/s)')
ylabel('Cycle Thermal Work (kW)')
ylim(y11)
grid on

subplot(3, 2, 2)
hold on
x11 = [x2(4), x2(4)];
y11 = [y2(7)/1e3 - 5, y2(4)/1e3 + 5];
plot(x11, y11, 'r--', 'linewidth', 1.2)
plot(x2, y2/1e3, 'k', 'linewidth', 1.2)
legend('Optimum')

title('Design Parameter #2')
xlabel('Turbine Pressure Ratio')
ylabel('Cycle Thermal Work (kW)')
ylim(y11)
grid on


subplot(3, 2, 3)
hold on
x11 = [x3(4), x3(4)];
y11 = [y3(1)/1e3 - 5, y3(4)/1e3 + 5];
plot(x11, y11, 'r--', 'linewidth', 1.2)
plot(x3, y3/1e3, 'k', 'linewidth', 1.2)
legend('Optimum')

title('Design Parameter #3')
xlabel('Compressor #1 Pressure Ratio')
ylabel('Cycle Thermal Work (kW)')
ylim(y11)
grid on

subplot(3, 2, 4)
hold on
x11 = [x5(4), x5(4)];
y11 = [y5(1)/1e3 - 5, y5(4)/1e3 + 5];
plot(x11*100, y11, 'r--', 'linewidth', 1.2)
plot(x5*100, y5/1e3, 'k', 'linewidth', 1.2)
legend('Optimum')

title('Design Parameter #4')
xlabel('IHX #1 Split(%)')
ylabel('Cycle Thermal Work (kW)')
ylim(y11)
grid on

subplot(3, 2, 5)
hold on
x11 = [x4(4), x4(4)];
y11 = [y4(1)/1e3 - 5, y4(4)/1e3 + 5];
plot(x11*100, y11, 'r--', 'linewidth', 1.2)
plot(x4*100, y4/1e3, 'k', 'linewidth', 1.2)
legend('Optimum')

title('Design Parameter #5')
xlabel('IHX #2 Split (%)')
ylabel('Cycle Thermal Work (kW)')
ylim(y11)
grid on

