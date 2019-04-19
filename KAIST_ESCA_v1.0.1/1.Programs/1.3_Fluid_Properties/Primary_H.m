function [H] = Primary_H(T, P)

% H = refpropm('H', 'T', T, 'P', P, 'co2', 'oxygen', 'nitrogen', 'water',[0.050, 0.1309, 0.4583, 0.3608]);

H = refpropm('H', 'T', T, 'P', P, 'Air.mix');

end

