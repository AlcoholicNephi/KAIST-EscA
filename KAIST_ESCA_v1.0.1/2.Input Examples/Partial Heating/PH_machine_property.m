% Mechanics Data file

PH_condition;

%%%% Components property %%%%

Mechanics.Turbine(1).P_ratio = 20000/8000;
Mechanics.Turbine(1).indicator = 0;
Mechanics.Turbine(1).Eff = 0.90;

Mechanics.Compressor(1).Rel_P_ratio = 1;
Mechanics.Compressor(1).indicator = -1;
Mechanics.Compressor(1).Eff = 0.84;

%Mechanics.Cooler(1).dP = 300; %kPa
Mechanics.Cooler(1).dP = 80; %kPa

Mechanics.Recuperator(1).Eff = 0.97;
Mechanics.Recuperator(1).dP(1)= 110; % Hot channel pressure drop (kPa)
Mechanics.Recuperator(1).dP(2) = 110; % Hot channel pressure drop (kPa)

Mechanics.IHX(1).dP = 110;

Mechanics.IHX(2).dP = 110;


%%%% HX Off-design Geometry %%%

%%% IHX1
Mechanics.IHX(1).Np = 280000; % Number of Primary channels
Mechanics.IHX(1).Dp = 10 / 1000; % Diameter of Primary channels, m
Mechanics.IHX(1).Lp = 0.7; % Channel length of Primary channels, m

Mechanics.IHX(1).Ns = 560000; % Number of Secondary channels
Mechanics.IHX(1).Ds = 2 / 1000; % Diameter of Secondary channels, m
Mechanics.IHX(1).Ls = 0.7; % Channel length of Secondary channels, m

Mechanics.IHX(1).wth = 0.5 / 1000; % Wall thickness (m)
Mechanics.IHX(1).k = 15; % Wall thermal conduxtivity W/mK
Mechanics.IHX(1).type = 'PCHE'; % Wall thermal conduxtivity W/mK
Mechanics.IHX(1).Mesh_num = 20;
Mechanics.IHX(1).model = 'KAIST'; % KAIST, Cartsens, Dittus-boelter (DB).

%%% IHX2
Mechanics.IHX(2).Np = 1000000; % Number of Primary channels
Mechanics.IHX(2).Dp = 10 / 1000; % Diameter of Primary channels, m
Mechanics.IHX(2).Lp = 0.5; % Channel length of Primary channels, m

Mechanics.IHX(2).Ns = 1000000; % Number of Secondary channels
Mechanics.IHX(2).Ds = 2 / 1000; % Diameter of Secondary channels, m
Mechanics.IHX(2).Ls = 0.5; % Channel length of Secondary channels, m

Mechanics.IHX(2).wth = 0.5 / 1000; % Wall thickness (m)
Mechanics.IHX(2).k = 15; % Wall thermal conduxtivity W/mK
Mechanics.IHX(2).type = 'PCHE'; % Wall thermal conduxtivity W/mK
Mechanics.IHX(2).Mesh_num = 20;
Mechanics.IHX(2).model = 'KAIST'; % KAIST, Cartsens, Dittus-boelter (DB).

%%% Recup

Mechanics.Recuperator(1).Np = 2500000; % Number of Primary channels
Mechanics.Recuperator(1).Dp = 2 / 1000; % Diameter of Primary channels, m
Mechanics.Recuperator(1).Lp = 0.5; % Channel length of Primary channels, m

Mechanics.Recuperator(1).Ns = 2500000; % Number of Secondary channels
Mechanics.Recuperator(1).Ds = 2 / 1000; % Diameter of Secondary channels, m
Mechanics.Recuperator(1).Ls = 0.5; % Channel length of Secondary channels, m

Mechanics.Recuperator(1).wth = 0.5 / 1000; % Wall thickness (m)
Mechanics.Recuperator(1).k = 15; % Wall thermal conduxtivity W/mK
Mechanics.Recuperator(1).type = 'PCHE'; % Wall thermal conduxtivity W/mK
Mechanics.Recuperator(1).Mesh_num = 50;
Mechanics.Recuperator(1).model = 'KAIST'; % KAIST, Cartsens, Dittus-boelter (DB).




%%% Cooler - > 나중에 바꿀것
Mechanics.Cooler(1).Np = 800000; % Number of Primary channels
Mechanics.Cooler(1).Dp = 2 / 1000; % Diameter of Primary channels, m
Mechanics.Cooler(1).Lp = 1; % Channel length of Primary channels, m

Mechanics.Cooler(1).Ns = 800000; % Number of Secondary channels
Mechanics.Cooler(1).Ds = 2 / 1000; % Diameter of Secondary channels, m
Mechanics.Cooler(1).Ls = 1; % Channel length of Secondary channels, m

Mechanics.Cooler(1).wth = 0.5 / 1000; % Wall thickness (m)
Mechanics.Cooler(1).k = 15; % Wall thermal conduxtivity W/mK
Mechanics.Cooler(1).type = 'PCHE'; % Wall thermal conduxtivity W/mK
Mechanics.Cooler(1).Mesh_num = 50;
Mechanics.Cooler(1).model = 'KAIST'; % KAIST, Cartsens, Dittus-boelter (DB).