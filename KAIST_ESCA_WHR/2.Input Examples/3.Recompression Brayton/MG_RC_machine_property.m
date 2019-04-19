% Mechanics Data file

MG_RC_condition;

%%%% Components property %%%%

Mechanics.Turbine(1).P_ratio = 20000/8100;
Mechanics.Turbine(1).indicator = 0; % Outlet condition indicator / -1: Bounded, 0: free, else : indicating. P target junction
Mechanics.Turbine(1).Eff = 0.80;

Mechanics.Compressor(1).Rel_P_ratio = 1.0;
Mechanics.Compressor(1).indicator = -1; % Outlet condition indicator / -1: Bounded, 0: free, else : indicating. P target junction
Mechanics.Compressor(1).Eff = 0.70;

Mechanics.Compressor(2).Rel_P_ratio = 1.0;
Mechanics.Compressor(2).indicator = 8; % Outlet condition indicator / -1: Bounded, 0: free, else : indicating. P target junction
Mechanics.Compressor(2).Eff = 0.70;

Mechanics.Cooler(1).dP = -0.01; %kPa

Mechanics.Recuperator(1).Eff = 0.91;
Mechanics.Recuperator(1).dP = [-0.015, -0.015]; % Hot/Cold

Mechanics.Recuperator(2).Eff = 0.91;
Mechanics.Recuperator(2).dP = [-0.015, -0.015]; % Hot/Cold

Mechanics.WHR(1).Eff = 0.75;
Mechanics.WHR(1).dP = [-0.015, -0.01];

