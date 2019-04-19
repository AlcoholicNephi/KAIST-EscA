% Mechanics Data file

BC3_condition;

%%%% Components property %%%%

Mechanics.Turbine(1).P_ratio = 20/8;
Mechanics.Turbine(1).Eff = 0.90;

Mechanics.Turbine(2).P_ratio = 20/8;
Mechanics.Turbine(2).Eff = 0.90;

Mechanics.Compressor(1).Rel_P_ratio = 1; % C1
Mechanics.Compressor(1).Eff = 0.84;

Mechanics.Compressor(2).Rel_P_ratio = 1; % C2
Mechanics.Compressor(2).Eff = 0.84;


Mechanics.Cooler(1).dP = 150; %kPa 
Mechanics.Cooler(2).dP = 150; %kPa

Mechanics.Recuperator(1).Eff = 0.95;
Mechanics.Recuperator(1).dP(1) = 150; % Hot channel pressure drop (kPa)
Mechanics.Recuperator(1).dP(2) = 150; % Hot channel pressure drop (kPa)

Mechanics.Recuperator(2).Eff = 0.95;
Mechanics.Recuperator(2).dP(1) = 150; % Hot channel pressure drop (kPa)
Mechanics.Recuperator(2).dP(2) = 150; % Hot channel pressure drop (kPa)

Mechanics.IHX(1).dP = 150;

Mechanics.IHX(2).dP = 150;




