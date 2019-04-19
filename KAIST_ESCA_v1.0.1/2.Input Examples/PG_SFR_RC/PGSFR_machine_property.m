% Mechanics Data file

PGSFR_condition;

%%%% Components property %%%%

Mechanics.Turbine(1).P_ratio = 20000/8100;
Mechanics.Turbine(1).indicator = 0; % Outlet condition indicator / -1: Bounded, 0: free, else : indicating. P target junction
Mechanics.Turbine(1).Eff = 0.90;



Mechanics.Compressor(1).Rel_P_ratio = 1.0;
Mechanics.Compressor(1).indicator = -1; % Outlet condition indicator / -1: Bounded, 0: free, else : indicating. P target junction
Mechanics.Compressor(1).Eff = 0.80;

Mechanics.Compressor(2).Rel_P_ratio = 1.0;
Mechanics.Compressor(2).indicator = 10; % Outlet condition indicator / -1: Bounded, 0: free, else : indicating. P target junction
Mechanics.Compressor(2).Eff = 0.80;



Mechanics.Cooler(1).dP = 40; %kPa
% Mechanics.Cooler(1).dP = -0.005; %kPa



Mechanics.Recuperator(1).Eff = 0.95;
Mechanics.Recuperator(1).dP = [30, 60]; % Hot/Cold
% Mechanics.Recuperator(1).dP = [-0.005, -0.005]; % Hot/Cold

Mechanics.Recuperator(2).Eff = 0.95;
Mechanics.Recuperator(2).dP = [50, 20]; % Hot/Cold
% Mechanics.Recuperator(2).dP = [-0.005, -0.005]; % Hot/Cold



Mechanics.IHX(1).dP = 20;
% Mechanics.IHX(1).dP = -0.005;



Mechanics.Valve(1).indicator = 0; % Outlet condition indicator / 0: free, else: indicating, P target junction
Mechanics.Valve(1).dP = 0; % Isentropic Valve

Mechanics.Valve(2).indicator = 4; % Outlet condition indicator / 0: free, else: indicating, P target junction

% 
% %%%% Components property %%%%
% 
% Mechanics.Turbine(1).P_ratio = 20000/8100;
% Mechanics.Turbine(1).Eff = 0.90;
% 
% Mechanics.Compressor(1).Rel_P_ratio = 1.0;
% Mechanics.Compressor(1).Eff = 0.80;
% 
% Mechanics.Compressor(2).Rel_P_ratio = 1.0;
% Mechanics.Compressor(2).Eff = 0.80;
% 
% Mechanics.Cooler(1).dP = 40; %kPa
% Mechanics.Cooler(1).Target_T = Condition.Min_T;
% 
% Mechanics.Recuperator(1).Eff = 0.95;
% Mechanics.Recuperator(1).dP_H = 30; % Hot channel pressure drop (kPa)
% Mechanics.Recuperator(1).dP_C = 60; % Cold channel pressure drop (kPa)
% 
% Mechanics.Recuperator(2).Eff = 0.95;
% Mechanics.Recuperator(2).dP_H = 50; % Hot channel pressure drop (kPa)
% Mechanics.Recuperator(2).dP_C = 20; % Cold channel pressure drop (kPa)
% 
% Mechanics.IHX(1).dP = 20;
% 
% 
