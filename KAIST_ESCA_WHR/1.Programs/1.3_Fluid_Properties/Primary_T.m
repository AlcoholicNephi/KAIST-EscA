function [T] = Primary_T(H, P)

% T = refpropm('T', 'H', H, 'P', P, 'co2', 'oxygen', 'nitrogen', 'water',[0.144827387, 0.049567033, 0.722845909, 0.082759671]);

% T = refpropm('T', 'H', H, 'P', P, 'co2', 'oxygen', 'nitrogen', 'water',[0.050, 0.1309, 0.4583, 0.3608]);

T = refpropm('T', 'H', H, 'P', P, 'nitrogen', 'oxygen', 'argon', 'co2', 'water', [0.737230764, 0.153678646, 0.012478601, 0.050636645, 0.045975344]);

% Setup.whrhx_source_fluid(1).conc = 0.737230764;
% Setup.whrhx_source_fluid(2).conc = 0.153678646;
% Setup.whrhx_source_fluid(3).conc = 0.012478601;
% Setup.whrhx_source_fluid(4).conc = 0.050636645;
% Setup.whrhx_source_fluid(5).conc = 0.045975344;

end

