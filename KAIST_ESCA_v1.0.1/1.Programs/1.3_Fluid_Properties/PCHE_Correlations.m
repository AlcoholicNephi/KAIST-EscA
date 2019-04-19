function [Re, Pr, Nu, f, flag] = PCHE_Correlations(massflowrate, flowarea, D, mu, cp, k, fluid)

Re = massflowrate/flowarea*D/mu;
Pr = mu*cp/k;
Pe = Re*Pr;
flag = 0; % Correlation certaintity flag

% Calculate the Nusselt number from Reynolds No, Prandtl No.
% To obtain the heat transfer coeff.
if strcmp(fluid,'Helium')
    % PCHE Heat transfer model from Kim In Hun, 250<Re<850, Pr=0.66
    Nu = 4.065 + 0.00305*Re;
    f = 16.51/Re+0.01627;
    %f = 15.78/Re+0.004868*Re^(1-0.8416);
    %f = 16/Re;
    if Re>850 
%         disp('Nu Correlation out of range Re>850')
        flag=1;
    elseif Re<250
%         disp('Nu Correlation out of range Re<250')
        flag=2;
    end    
%     % MCHE with zigzag fins from Tri Lam Ngo, 3500<Re<22000, 0.75<Pr<2.2
%     Nu = 0.1696*Re^0.629*Pr^0.317;
%     f = 0.1924*Re^-0.091;
%     if Re>22000 
% %         disp('Nu Correlation out of range Re>22000')
%         flag=1;
%         flag=0;
%     elseif Re<3500
% %         disp('Nu Correlation out of range Re<3500')
%         flag=2;
%     end
    
elseif strcmp(fluid, 'CO2')
    % MCHE with zigzag fins from Tri Lam Ngo, 3500<Re<22000, 0.75<Pr<2.2
    Nu = 0.1696*Re^0.629*Pr^0.317;
    f = 0.1924*Re^-0.091;
    if Re>22000 
%         disp('Nu Correlation out of range Re>22000')
        flag=1;
        flag=0;
    elseif Re<3500
%         disp('Nu Correlation out of range Re<3500')
        flag=2;
    end
elseif strcmp(fluid, 'Water')
    % MCHE with zigzag fins from Tri Lam Ngo, 3500<Re<22000, 0.75<Pr<2.2
    Nu = 0.1696*Re^0.629*Pr^0.317;
    f = 0.1924*Re^-0.091;
    if Re>22000
%         disp('Nu Correlation out of range Re>22000')
        flag=1;
        %flag=0;
    elseif Re<3500
%         disp('Nu Correlation out of range Re<3500')
        flag=2;
    end
elseif strcmp(fluid, 'Nitrogen')
    % MCHE with zigzag fins from Tri Lam Ngo, 3500<Re<22000, 0.75<Pr<2.2
    Nu = 0.1696*Re^0.629*Pr^0.317;
    f = 0.1924*Re^-0.091;
    if Re>22000
%         disp('Nu Correlation out of range Re>22000')
        flag=1;
        %flag=0;
    elseif Re<3500
%         disp('Nu Correlation out of range Re<3500')
        flag=2;
    end
elseif strcmp(fluid, 'Sodium')
    Nu = 7+0.025*Pe^0.8; 
    f = 4*(0.0014+0.125*Re^-0.32);
else
    disp('syntax error!')
end
