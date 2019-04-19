function Output_Plot(Component, Junc)

%%% Preprocessing for CCD-SSM

cnt = 1;

if(isempty(Junc(1).cycle) == 0)
    for i=1:size(Junc(1).cycle, 2)
        Cycle.T(cnt) = Junc(Component(Junc(1).cycle(i)).outJunc).T;
        Cycle.S(cnt) = Junc(Component(Junc(1).cycle(i)).outJunc).S;
        Cycle.Index(cnt) = Junc(1).cycle(i);
        cnt = cnt+1;
    end
    
else    
    for i=1:size(Component, 2)
        if(strcmp(Component(i).type, 'Junction'))
        elseif(strcmp(Component(i).type, 'Recuperator'))
        else
            Cycle.T(cnt) = Junc(Component(i).outJunc).T;
            Cycle.S(cnt) = Junc(Component(i).outJunc).S;
            Cycle.Index(cnt) = i;
            cnt=cnt+1;
        end
    end
    
    Cycle.T(cnt) = Cycle.T(1);
    Cycle.S(cnt) = Cycle.S(1);
    
end



%%% Original code from KAIST-CCD(2015/5 ver.)

set(0,'Units','pixels')
scnsize = get(0,'ScreenSize');
pos = [0.0357*scnsize(3), 0.0933*scnsize(4), 0.8*scnsize(3), 0.785*scnsize(4)];
figure(1)
set(figure(1), 'Position', pos)

subplot(1,1,1)
hold on
plot (Cycle.S./1E3, Cycle.T-273.15)
grid on
xlabel('Entropy (kJ/kg K)', 'FontSize', 20)
ylabel('Temperature (^oC)', 'FontSize', 20)
xlim([min(Cycle.S./1E3)-0.2, max(Cycle.S./1E3)+0.2])
ylim([min(Cycle.T)-50-273.15, max(Cycle.T)+50-273.15])
for ii=1:length(Cycle.T)-1
    text(Cycle.S(ii)/1E3, Cycle.T(ii)-273.15, [' ', Component(Cycle.Index(ii)).ID], 'FontSize', 14)
end

% subplot(1,3,2)
% hold on
% plot (Cycle.T, Cycle.P./1E3)
% grid on
% xlabel('Temperature (K)', 'FontSize', 14)
% ylabel('Pressure (MPa)', 'FontSize', 14)
% xlim([min(Cycle.T)-50, max(Cycle.T)+50])
% ylim([min(Cycle.P)-0.15*(max(Cycle.P)-min(Cycle.P)), max(Cycle.P)+0.15*(max(Cycle.P)-min(Cycle.P))]./1E3)
% for ii=1:length(Cycle.T)-1
%     text(Cycle.T(ii), Cycle.P(ii)/1E3, num2str(ii), 'FontSize', 14)
% end
%
%
% subplot(1,3,3)
% hold on
% plot (Cycle.S./1E3, Cycle.H./1E3)
% grid on
% xlabel('Entropy (kJ/kg K)', 'FontSize', 14)
% ylabel('Enthalpy (kJ/kg)', 'FontSize', 14)
% xlim([min(Cycle.S./1E3)-0.2, max(Cycle.S./1E3)+0.2])
% ylim([min(Cycle.H./1E3)-0.2, max(Cycle.H./1E3)+0.2])
% for ii=1:length(Cycle.H)-1
%     text(Cycle.S(ii)/1E3, Cycle.H(ii)/1E3, num2str(ii), 'FontSize', 14)
% end



end

