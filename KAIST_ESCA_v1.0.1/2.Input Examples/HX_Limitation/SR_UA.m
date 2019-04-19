function [Junc, Cycle, info] = SR_UA(Condition, Mechanics, m_flow_rate, UA)
%SR 이 함수의 요약 설명 위치
%   자세한 설명 위치
for i=1:6
    Junc(i).m = 1;
    Junc(i).dP = 0;
end

%%% set P & boundary



% for kk=1:100
%     Mechanics.Turbine(1).P_ratio = 1.5 + 1.8 /100*kk;
%     x(kk) = 1.5 + 1.8 /100*kk;

% Compressor
Junc(5).P = Condition.Max_P;
Junc(6).P = Junc(5).P - Mechanics.Recuperator(1).dP_C;
Junc(1).P = Junc(6).P - Mechanics.IHX(1).dP;
Junc(2).P = Junc(1).P / Mechanics.Turbine(1).P_ratio;
Junc(3).P = Junc(2).P - Mechanics.Recuperator(1).dP_H;
Junc(4).P = Junc(3).P - Mechanics.Cooler(1).dP;


for i=1:6
    Junc(i).m_flow_rate = Junc(i).m * m_flow_rate;
end


%%% Temperature

% Boundary
Junc(4).T = Condition.Min_T;
Junc(1).T = Condition.Max_T;

% Turbine
[Junc(2).T, P_out, WorkT] = Comp_Turbine(Junc(1), Condition, Mechanics.Turbine(1));

% Compressor

inJunc.T = Junc(4).T;
inJunc.P = Junc(4).P;
inJunc.dP = 0;
inJunc.m_flow_rate = m_flow_rate;

[Junc(5).T, Junc(5).P, WorkC] = Comp_Compressor(inJunc, Condition.Max_P, Condition, Mechanics.Compressor(1));

% % [Junc(3).T, P_H_out, Junc(6).T, P_C_out, UA] = Comp_Recuperator(Junc(2), Junc(5), Condition, Mechanics.Recuperator(1));

% %%%%%%%%%%%%%%%%%%%%%%%%%

Pri_T(1) = Junc(2).T;
Sec_T(1) = Junc(5).T;
% Pri.boundP = Junc(2).P

for i=1:100
    
end

% %%%%%%%%%%%%%%%%%%%%%%%%%

Q_in = m_flow_rate * (refpropm('H', 'T', Junc(1).T, 'P', Junc(1).P, Condition.Fluid) - refpropm('H','T', Junc(6).T, 'P', Junc(6).P, Condition.Fluid));
%
% y(kk) = (-WorkT - WorkC)/Q_in;
% plot(x, y)
% drawnow
%
% end
%
% xlabel('Turbine Pressure Ratio')
% ylabel('Efficiency')

for i=1:6
    Junc(i).S = refpropm('S', 'T', Junc(i).T, 'P', Junc(i).P, Condition.Fluid);
    Junc(i).H = refpropm('H', 'T', Junc(i).T, 'P', Junc(i).P, Condition.Fluid);
    Cycle.T(i) = Junc(i).T;
    Cycle.S(i) = Junc(i).S;
end

Cycle.T(7) = Junc(1).T;
Cycle.S(7) = Junc(1).S;

% plot(Cycle.S / 1000, Cycle.T - 273.16, 'linewidth', 1.2)
% xlabel('Entropy (kJ/kg-K)')
% ylabel('Temperature (oC)')
% grid on



% disp('/////////////////////')
% WorkT = abs(WorkT);
% WorkComp = sum(WorkC);
% Work = WorkT - WorkComp;
% 
% Eff = Work / Q_in;
% disp(['Eff : ', num2str(Eff)])
% disp(['M flowrate : ', num2str(m_flow_rate)])
% disp(['P ratio : ', num2str(Mechanics.Turbine(1).P_ratio)])
% disp('/////////////////////')
% disp(' ')

info.WorkT = abs(WorkT);
info.WorkC = WorkC;
info.Q_in = Q_in;

info.Cooler_Q = m_flow_rate * (Junc(3).H - Junc(4).H);

end

