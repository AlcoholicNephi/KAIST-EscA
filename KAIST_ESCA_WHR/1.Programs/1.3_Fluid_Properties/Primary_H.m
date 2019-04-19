function [H] = Primary_H(T, P)

% H = refpropm('H', 'T', T, 'P', P, 'co2', 'oxygen', 'nitrogen', 'water',[0.050, 0.1309, 0.4583, 0.3608]);

H = refpropm('H', 'T', T, 'P', P, 'nitrogen', 'oxygen', 'argon', 'co2', 'water', [0.737230764, 0.153678646, 0.012478601, 0.050636645, 0.045975344]);

end

