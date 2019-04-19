close all
clear
% clc

% addpath(genpath('D:\Dropbox\MATLAB\Now_Working\Steady\KAIST_ACOD_release_v1\KAIST_CCD_Seongmin'))

% Generalized CCD - 20170619 ~
% Single IHX cases
% Cooler / TIT : T bounded
% Main compressor : P bounded

IC_condition
IC_layout
IC_machine_property

% System Boundary Condition
Condition.delt = 1e-6;

Condition.T_bound.ID = [4, 6, 1];
Condition.T_bound.value = [32 + 273.15, 32 + 273.15, 600 + 273.15];
Condition.P_bound.ID = [5, 7];
Condition.P_bound.value = [12000, 25000];



for i=1:41
    
    Mechanics.Turbine(1).P_ratio = 1.5 + (4-2)/41 * (i-1);
    [Junc, info] = Steady_Solver(Condition, Component, Mechanics);
    
    Condition.P_bound.value(1) = 25000 / sqrt(Mechanics.Turbine(1).P_ratio);
    
%     Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)
    
    Sys_min_P(i) = Junc(4).P;
    Eff_traditional_Eff(i) = info.Eff;
    
    plot(Sys_min_P, Eff_traditional_Eff)
    
end

for i=1:41
    
    Mechanics.Turbine(1).P_ratio = 1.5 + (4-2)/41 * (i-1);
    Condition.P_bound.value(1) = 25000 / sqrt(Mechanics.Turbine(1).P_ratio);
    
    Tm = getTm(25000/Mechanics.Turbine(1).P_ratio, 25000, 1);
    
    for k=1:10
        [Junc, info] = Steady_Solver(Condition, Component, Mechanics);
        Mechanics.Recuperator(1).Eff = 0.95 * getEff_ideal(Junc(5).T, Junc(5).P, Junc(2).T, Junc(2).P, Tm, 1);
    end
    
    Sys_min_P2(i) = Junc(4).P;
    Eff_advanced_Eff(i) = info.Eff;

    
    plot(Sys_min_P2, Eff_advanced_Eff)
    drawnow
    
end

figure(1)
hold on
plot(Sys_min_P2, Eff_advanced_Eff*100, 'k', 'linewidth', 1.2)
plot(Sys_min_P, Eff_traditional_Eff*100, 'k--', 'linewidth', 1.2)

legend('Corrected Effectiveness Definition', 'Traditional Effectiveness Defitnition', 'location', 'southwest')
xlabel('System Minimum Pressure (kPa)')
ylabel('Cycle Thermal Efficiency (%)')
grid on






