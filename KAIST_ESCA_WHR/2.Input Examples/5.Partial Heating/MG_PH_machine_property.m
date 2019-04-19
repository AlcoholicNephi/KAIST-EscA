% Mechanics Data file

% PH_condition;

%%%% Components property %%%%

Mechanics.Turbine(1).P_ratio = 20000/8000;
Mechanics.Turbine(1).indicator = 0;
Mechanics.Turbine(1).Eff = 0.80;

Mechanics.Compressor(1).Rel_P_ratio = 1;
Mechanics.Compressor(1).indicator = -1;
Mechanics.Compressor(1).Eff = 0.70;

Mechanics.Cooler(1).dP = -0.01; %kPa

Mechanics.Recuperator(1).Eff = 0.91;
Mechanics.Recuperator(1).dP(1)= -0.015; % Hot channel pressure drop (kPa)
Mechanics.Recuperator(1).dP(2) = -0.015; % Hot channel pressure drop (kPa)

Mechanics.WHR(1).Eff = 0.75;
Mechanics.WHR(1).dP(1)= -0.015; % Hot channel pressure drop (kPa)
Mechanics.WHR(1).dP(2) = -0.01; % Hot channel pressure drop (kPa)

Mechanics.WHR(2).Eff = 0.75;
Mechanics.WHR(2).dP(1)= -0.015; % Hot channel pressure drop (kPa)
Mechanics.WHR(2).dP(2) = -0.01; % Hot channel pressure drop (kPa)




