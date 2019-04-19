function Output_Result_info(Condition, Junc, Component, massflowrate, network)

% Condition.Plot = 'On';                                             % Cycle plot 'On'
% Condition.Fluid = 'CO2';                                            % Cycle fluid - Fluids on NIST property program are all available
% Condition.Layout = 'Recompressing_Brayton';                         % Cycle layout selection 'Simple_Brayton'
% Condition.Q_in = 326E6;                                               % Input Q (W)
% Condition.Max_T =661+273.15;                                       % Cycle maximum temperature (K)
% Condition.Max_P = 22.5E3;                                             % Cycle maximum pressure (kPa)
% Condition.Min_T = 35+273.15;                                        % Cycle rejection temperature (K)
% Condition.Generator_Eff =0.98;                                      % Generator Efficiency
% Condition.Mechanical_Losses = 0;                                    % Based on Dostal's Work (%)
% Condition.Parasitic_Losses =  0;                                    % Based on Dostal's Work (%)
% Condition.SWyard_Losses = 0;                                      % Based on Dostal's Work (%)
% Condition.Error_bound = 1E-06;

Q_in = 0;

disp(' ')
disp('//////////////////////////////////// Result summary /////////////////////////////////////////')
disp(' ')
str=sprintf('%50s %30s', 'Mass flow rate (kg/sec)', num2str(massflowrate));
disp(str)
disp(' ')
str=sprintf('%50s %30s', 'IHX name', 'Inlet Heat(MW)');
disp(str)
for i=1:size(Component, 2)
    if(strcmp(Component(i).type, 'IHX'))
        Q = Junc(Component(i).inJunc).m_flow_rate * abs(refpropm('H', 'T', Junc(Component(i).inJunc).T, 'P', Junc(Component(i).inJunc).P, Condition.Fluid) - ...
            refpropm('H', 'T', Junc(Component(i).outJunc).T, 'P', Junc(Component(i).outJunc).P, Condition.Fluid));
        str=sprintf('%50s %30s', Component(i).ID, num2str(Q / 1E6));
        Q_in = Q_in + Q;
        disp(str)
    end
end
disp(' ')
str=sprintf('%50s %30s', 'Efficiency (%)', num2str(network/Q_in * 100));
disp(str)
str=sprintf('%50s %30s', 'Net work (MW)', num2str(network / 1E6));
disp(str)
disp(' ')
% disp('//////////////////////////////////// Condition info /////////////////////////////////////////')
% disp(' ')
% 
% str=sprintf('%50s %30s', 'Working fluid', Condition.Fluid);
% disp(str)
% str=sprintf('%50s %30s', 'Heatsource target temperature(K)', num2str(Condition.Max_T));
% disp(str)
% str=sprintf('%50s %30s', 'Cooler target temperature(K)', num2str(Condition.Min_T));
% disp(str)
% str=sprintf('%50s %30s', 'Maximum compressor target pressure(kPa)', num2str(Condition.Max_P));
% disp(str)
% str=sprintf('%50s %30s', 'Error Bound condition', num2str(Condition.Error_bound));
% disp(str)

disp(' ')
disp('//////////////////////////////////// Channel info /////////////////////////////////////////')
disp(' ')

str=sprintf('%15s %17s %17s %17s %17s', 'Channel ID', 'Channel T(oC)', 'Channel P(MPa)', 'Channel H(kJ/kg)', 'Channel S(kJ/kg-K)');
disp(str)
disp(' ')

for i=1:size(Junc, 2)
    H = refpropm('H', 'T', Junc(i).T, 'P', Junc(i).P, Condition.Fluid)/1000;
    S = refpropm('S', 'T', Junc(i).T, 'P', Junc(i).P, Condition.Fluid)/1000;
    str=sprintf('%15g %17g %17g %17g %17g', i, Junc(i).T - 273.15, Junc(i).P/1000, H, S);
    disp(str)
end

disp(' ')
disp('////////////////////////////////////////////////////////////////////////////////////////////')