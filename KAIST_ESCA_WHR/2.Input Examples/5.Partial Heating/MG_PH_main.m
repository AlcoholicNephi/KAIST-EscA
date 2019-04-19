close all
clear
% clc

addpath(genpath('D:\Dropbox\MATLAB\Now_Working\KAIST-ESCA\KAIST_ESCA_WHR'))

% Generalized CCD - 20170619 ~
% Single IHX cases
% Cooler / TIT : T bounded
% Main compressor : P bounded

MG_PH_condition
MG_PH_layout
MG_PH_machine_property

% System Boundary Condition
Condition.delt = 1e-4;
Condition.relaxation = 3;
Condition.Error_bound = 1e-7;

Condition.T_bound.ID = [4, 11];
Condition.T_bound.value = [32 + 273.15, 500 + 273.15];
Condition.P_bound.ID = [5, 11];
Condition.P_bound.value = [13850, 103];
Condition.Problem = 'Work';

Mechanics.Turbine(1).P_ratio = 13850/7400;

iParameters.name = {'Condition.m_flow_rate', 'Mechanics.Turbine(1).P_ratio', 'Condition.split(1)'};
iParameters.value = [40, 13850/7400, 0.4];
iParameters.max = [60, 3.0, 0.8];
iParameters.min = [12, 1.2, 0.1];

mu_0 = 0.1; % damping factor

Condition.m_flow_rate = 34.3068;
Mechanics.Turbine(1).P_ratio = 1.7338;
Condition.split(1) = 0.26054;

[Junc, info] = Steady_Solver_WHR(Condition, Component, Mechanics);
Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)

 
% [P, Junc, info] = Cycle_Optimizer_WHR(Condition, Component, Mechanics, iParameters, mu_0);
  


