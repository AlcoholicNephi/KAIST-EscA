close all
clear
% clc

addpath(genpath('D:\Dropbox\MATLAB\Now_Working\KAIST-ESCA\KAIST_ESCA_v1.0.1'))

% Generalized CCD - 20170619 ~
% Single IHX cases
% Cooler / TIT : T bounded
% Main compressor : P bounded

RC2_condition
RC2_layout
RC2_machine_property

% System Boundary Condition
Condition.delt = 1e-4;

Condition.T_bound.ID = [6, 1];
Condition.T_bound.value = [32 + 273.15, 505 + 273.15];
Condition.P_bound.ID = 7;
Condition.P_bound.value = 15000;

iParameters.name = {'Mechanics.Turbine(1).P_ratio', 'Condition.split(1)'};
iParameters.value = [2.0, 0.5];
iParameters.max = [3.0, 0.8];
iParameters.min = [1.5, 0.4];

mu_0 = 0.1; % damping factor


% [Junc, info] = Steady_Solver(Condition, Component, Mechanics);
% Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)


[P, Junc, info] = Cycle_Optimizer(Condition, Component, Mechanics, iParameters, mu_0);




% Mechanics.Turbine(1).P_ratio = 2.5947;
% Condition.split(1) = 0.62524;
% 
% 
% [Junc, info] = Steady_Solver(Condition, Component, Mechanics);
% Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)

