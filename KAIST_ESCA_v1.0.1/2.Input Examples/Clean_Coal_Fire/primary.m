
mole_info = [73.6*28, 5.2*36, 7.4*18, 12*48];
mole_info = mole_info/sum(mole_info);
H1 = refpropm('H', 'T', 273.15+1836.2, 'P', 105, 'nitrogen', 'oxygen', 'water', 'co2', mole_info);

dQ1 = 47.0578*1e6;
dQ2 = 47.9303*1e6;
dQ3 = 111.7319*1e6;
dQ4 = 18.93*1E6;
m = 435268/3600;

% H2 = H1 - dQ1/m;

H2 = H1 - dQ1/m;
H3 = H2 - dQ2/m;
H4 = H3 - dQ3/m;
H5 = H4 - dQ4/m;



T2 = refpropm('T', 'H', H2, 'P', 105, 'nitrogen', 'oxygen', 'water', 'co2', mole_info) - 273.15
T3 = refpropm('T', 'H', H3, 'P', 105, 'nitrogen', 'oxygen', 'water', 'co2', mole_info) - 273.15
T4 = refpropm('T', 'H', H4, 'P', 105, 'nitrogen', 'oxygen', 'water', 'co2', mole_info) - 273.15
T5 = refpropm('T', 'H', H5, 'P', 105, 'nitrogen', 'oxygen', 'water', 'co2', mole_info) - 273.15