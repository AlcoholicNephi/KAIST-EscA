close all
clear
% clc

addpath(genpath('D:\Dropbox\MATLAB\Now_Working\Steady\KAIST_ESCA_v1.0'))

% Generalized CCD - 20170619 ~
% Single IHX cases
% Cooler / TIT : T bounded
% Main compressor : P bounded

SR_condition
SR_layout
SR_machine_property

% System Boundary Condition
Condition.delt = 1e-6;

Condition.T_bound.ID = [4, 1];
Condition.T_bound.value = [32 + 273.15, 600 + 273.15];
Condition.P_bound.ID = 5;
Condition.P_bound.value = 25000;

Pri.fluid = 'CO2'; % Primary Channel fluid
Pri.boundT = 900; % K
Pri.boundP = 22500; % kPa
Pri.m = 1; % mass flow rate, kg/sec

Sec.fluid = 'CO2'; % Secondary Channel fluid
Sec.boundT = 320; % K
Sec.boundP = 22500; % kPa
Sec.m = 1; % mass flow rate, kg/sec


% Constraints for optimization

HX.Dp = 2.0/1000;
% HX.Np = 200000;
HX.Ds = 2.0/1000;
% HX.Ns = 200000;
m_channel = 1/1000;

HX.pitch = 0.5 / 1000; % Pitch / boundary to boundary distance (m)
HX.wth = 0.5 / 1000; % Wall thickness (m)
HX.k = 15; % Wall thermal conduxtivity W/mK
HX.mesh = 100;

figure(3)

for i=1:21
    
    Mechanics.Turbine(1).P_ratio = 1.5 + (4-1.5)/21 * (i-1);
    
    Tm = getTm(25000/Mechanics.Turbine(1).P_ratio, 25000, 1);
%     Tm = getTm_from_map(25000/Mechanics.Turbine(1).P_ratio, 25000, 1);
%     for k=1:10
        [Junc, info] = Steady_Solver(Condition, Component, Mechanics);
%         Mechanics.Recuperator(1).Eff = 0.95 * getEff_ideal(Junc(5).T, Junc(5).P, Junc(2).T, Junc(2).P, Tm, 1);
%     end
    
    Sys_min_P2(i) = Junc(4).P;
    x_vec(i) = Mechanics.Turbine(1).P_ratio;
    Eff_advanced_Eff(i) = info.Eff;

    Hot_in(i) = Junc(2).T;
    Cold_in(i) = Junc(5).T;
    Tm_profile(i) = Tm;
    
    hold on
    plot(Sys_min_P2, Hot_in)
    plot(Sys_min_P2, Cold_in)
    plot(Sys_min_P2, Tm_profile)
    hold off
    drawnow
    
    HX.Np = Junc(2).m_flow_rate/m_channel;
    HX.Ns = Junc(5).m_flow_rate/m_channel;
    
    Pri.fluid = 'CO2'; % Primary Channel fluid
    Pri.boundT = Junc(2).T; % K
    Pri.boundP = Junc(2).P; % kPa
    Pri.m = Junc(2).m_flow_rate; % mass flow rate, kg/sec
    
    Sec.fluid = 'CO2'; % Secondary Channel fluid
    Sec.boundT = Junc(5).T; % K
    Sec.boundP = Junc(5).P; % kPa
    Sec.m = Junc(5).m_flow_rate; % mass flow rate, kg/sec
    
    dQ = Junc(2).m_flow_rate * (refpropm('H', 'T', Junc(2).T, 'P', Junc(2).P, 'CO2') - refpropm('H', 'T', Junc(3).T, 'P', Junc(3).P, 'CO2'));
    
    [A, U, UA] = simple_HX_sizer(Pri, Sec, HX, dQ);

    Area(i) = sum(A);
    UA_sum(i) = sum(UA);
    
end




figure(1)
hold on
plot(x_vec, Eff_advanced_Eff*100, 'k', 'linewidth', 1.2)
% plot(Sys_min_P, Eff_traditional_Eff*100, 'k--', 'linewidth', 1.2)

% legend('Corrected Effectiveness Definition', 'Traditional Effectiveness Defitnition', 'location', 'southwest')
xlabel('System Minimum Pressure (kPa)')
ylabel('Cycle Thermal Efficiency (%)')
grid on

figure(2)

hold on
plot(x_vec, Hot_in - 273.15, 'r', 'linewidth', 1.2)
plot(x_vec, Cold_in - 273.15, 'b', 'linewidth', 1.2)
plot(x_vec, Tm_profile - 273.15, 'k', 'linewidth', 1.2)
legend('Recuperator Hot Side Inlet', 'Recuperator Cold Side Inlet', 'Tm')
xlabel('System Minimum Pressure (kPa)')
ylabel('Temperature (oC)')
grid on

