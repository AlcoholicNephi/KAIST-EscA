function [T] = Primary_T(H, P)

% T = refpropm('T', 'H', H, 'P', P, 'co2', 'oxygen', 'nitrogen', 'water',[0.144827387, 0.049567033, 0.722845909, 0.082759671]);

% T = refpropm('T', 'H', H, 'P', P, 'co2', 'oxygen', 'nitrogen', 'water',[0.050, 0.1309, 0.4583, 0.3608]);

T = refpropm('T', 'H', H, 'P', P, 'Air.mix');

end

