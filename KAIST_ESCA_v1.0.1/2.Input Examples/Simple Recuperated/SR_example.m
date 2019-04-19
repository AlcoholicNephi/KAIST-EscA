close all
clear
% clc

addpath(genpath('D:\Dropbox\MATLAB\Now_Working\Steady\KAIST_ACOD_release_v1\KAIST_CCD_Seongmin'))

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


% for i=1:40

[Junc, info] = Steady_Solver(Condition, Component, Mechanics);
Output_Result_info(Condition, Junc, Component, info.m_flow_rate, info.Net_work)

% end

