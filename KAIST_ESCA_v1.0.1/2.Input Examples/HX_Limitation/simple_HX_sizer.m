function [A, U, UA, T_p_profile, T_s_profile] = simple_HX_sizer(Pri, Sec, HX, dQ)


H_p_profile(1) = refpropm('H', 'T', Pri.boundT, 'P', Pri.boundP, 'CO2');
H_s_profile(HX.mesh) = refpropm('H', 'T', Sec.boundT, 'P', Sec.boundP, 'CO2');

for i=2:HX.mesh
    H_p_profile(i) = H_p_profile(i-1) - dQ/HX.mesh/Pri.m;
    H_s_profile(HX.mesh - i + 1) = H_s_profile(HX.mesh - i + 2) + dQ/HX.mesh/Sec.m;
end

for i=1:HX.mesh
    T_p_profile(i) = refpropm('T', 'H', H_p_profile(i), 'P', Pri.boundP, 'CO2');
    T_s_profile(i) = refpropm('T', 'H', H_s_profile(i), 'P', Sec.boundP, 'CO2');
    
    %     x(i) = (i-1)/(HX.mesh - 1);
end

% hold on
% plot(T_p_profile)
% plot(T_s_profile)

Mesh_num = HX.mesh;

Hy_P = 4 * (pi*HX.Dp^2 / 8) / ((pi+1)*HX.Dp); % hydraulic diameter
Hy_S = 4 * (pi*HX.Ds^2 / 8) / ((pi+1)*HX.Ds);

ca_P = (pi*HX.Dp^2/8); %cross sectional area
ca_S = (pi*HX.Ds^2/8);

dmp=Pri.m/HX.Np; % mass flow rate per channel
dms=Sec.m/HX.Ns;


% Ap = (pi/2+1)* HX.Dp * HX.L * HX.Np / (Mesh_num-1); % surface area
% As = (pi/2+1)* HX.Ds * HX.L * HX.Ns / (Mesh_num-1);

Rw = HX.wth/HX.k;

for i=1:Mesh_num-1
    
    T_p_avg = (T_p_profile(i) + T_p_profile(i+1))/2;
    T_s_avg = (T_s_profile(i) + T_s_profile(i+1))/2;
    
    [rhoP, muP, kP, cpP]=Thermal_Properties(T_p_avg, Pri.boundP, Pri.fluid);
    [rhoS, muS, kS, cpS]=Thermal_Properties(T_s_avg, Sec.boundP, Sec.fluid);
    
    [ReP, PrP, NuP, fP, flagP]=PCHE_Correlations(dmp, ca_P, HX.Dp, muP, cpP, kP, Pri.fluid);
    [ReS, PrS, NuS, fS, flagS]=PCHE_Correlations(dms, ca_S, HX.Ds, muS, cpS, kS, Sec.fluid);
    
    hP = NuP * kP/Hy_P;
    hS = NuS * kS/Hy_S;
    
    UA(i) = dQ / abs(T_p_avg - T_s_avg) / HX.mesh;
    U(i) = 1/(1/hP + Rw + 1/hS);
    
    A(i) = UA(i)/U(i);
    
    x(i) = (i-1)/(HX.mesh - 1);
    
end


end

