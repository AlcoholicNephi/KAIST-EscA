function [rho, mu, k, cp]=Thermal_Properties(T, P, fluid)
  
    rho = refpropm('D', 'T', T, 'P', P, fluid); % [kg/(m^3)]
    mu = refpropm('V', 'T', T, 'P', P, fluid); % [kg/(m*s)]
    k = refpropm('L', 'T', T, 'P', P, fluid); % [W/(m*K)]
    cp = refpropm('C', 'T', T, 'P', P, fluid); % [J/(Kg K)]
end