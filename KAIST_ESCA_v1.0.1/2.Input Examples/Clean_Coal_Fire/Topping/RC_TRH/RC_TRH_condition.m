%%% Condition data file
% Recompression Brayton Cycle / Three Reheat

% Condition.Plot = 'On';                                               % Cycle plot 'On' 
Condition.Fluid = 'CO2';                                             % Cycle fluid - Fluids on NIST property program are all available
Condition.Layout = 'Recompressing_Brayton_2';                          % Cycle layout selection 'Simple_Brayton'

Condition.Error_bound = 1E-07;                                       % Error bound (%)
Condition.Q_in = 207.2204*1E6;                                          % Q_in, W
Condition.split = [0.67, 0.33];
Condition.split_link = [1, 2];                          % Linked split indicator
Condition.split_link_value = [1];

% System Boundary Condition

Condition.T_bound.ID = [16, 5, 7, 9];
Condition.T_bound.value = [32 + 273.16, 600 + 273.16, 600 + 273.16, 600 + 273.16];
Condition.P_bound.ID = 1;
Condition.P_bound.value = 20000;

%%% Optimization

Condition.delt = 1e-6;
Condition.relaxation = 10;

%%%
Condition.Mechanical_Losses = 0;                                     % Based on Dostal's Work (%)
Condition.Parasitic_Losses =  0;                                     % Based on Dostal's Work (%)
Condition.SWyard_Losses = 0;                                         % Based on Dostal's Work (%)
Condition.View_Iter = 'OFF';
Condition.Generator_Eff =0.98;                                       % Generator Efficiency