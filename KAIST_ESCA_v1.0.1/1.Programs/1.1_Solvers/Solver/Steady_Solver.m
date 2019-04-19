function [Junc, info] = Steady_Solver(Condition, Component, Mechanics)

% IHX with Q_in boundary / Steady Solver by SSM (20170619)

for i=1:size(Condition.split_link_value, 2)
    Condition.split(Condition.split_link(2*i)) = Condition.split_link_value(i) - Condition.split(Condition.split_link(i*2 - 1));
end

for i=1:size(Component, 2)
    for j=1:size(Component(i).inJunc, 2)
        Junc(Component(i).inJunc(j)).out_comp = i;
    end
    for j=1:size(Component(i).outJunc, 2)
        Junc(Component(i).outJunc(j)).in_comp = i;
    end
end

% Set mass flow rate %

for i=1:size(Component, 2)
    if(strcmp(Component(i).type, 'Junction'))
        cnt=1;
        for j=1:size(Component(i).inJunc, 2)
            if(Component(i).split(cnt) == -1)
                Junc(Component(i).inJunc(j)).m = 1;
            else
                Junc(Component(i).inJunc(j)).m = Condition.split(Component(i).split(cnt));
            end
            cnt = cnt+1;
        end
        for j=1:size(Component(i).outJunc, 2)
            if(Component(i).split(cnt) == -1)
                Junc(Component(i).outJunc(j)).m = 1;
            else
                Junc(Component(i).outJunc(j)).m = Condition.split(Component(i).split(cnt));
            end
            cnt = cnt+1;
        end
    else
        for j=1:size(Component(i).inJunc, 2)
            if(Component(i).split(j) == -1)
                Junc(Component(i).inJunc(j)).m = 1;
                Junc(Component(i).outJunc(j)).m = 1;
            else
                Junc(Component(i).inJunc(j)).m = Condition.split(Component(i).split(j));
                Junc(Component(i).outJunc(j)).m = Condition.split(Component(i).split(j));
            end
        end
    end
end

% T P Initiallization %

for i=1:size(Junc, 2)
    Junc(i).T = -1;
    Junc(i).P = -1;
    Junc(i).m_flow_rate = Junc(i).m;
end

% Set System Boundaries %

for i=1:size(Condition.T_bound.ID, 2)
    Junc(Condition.T_bound.ID(i)).T = Condition.T_bound.value(i);
end
avgT = sum(Condition.T_bound.value)/size(Condition.T_bound.ID, 2);

for i=1:size(Condition.P_bound.ID, 2)
    Junc(Condition.P_bound.ID(i)).P = Condition.P_bound.value(i);
end

% P solver %

while(1)
    
    TF = 1;
    
    for i=1:size(Component, 2)
        switch(Component(i).type)
            case 'IHX'
                if(Junc(Component(i).inJunc).P ~= -1)
                    if(Mechanics.IHX(Component(i).index).dP > 0)
                        Junc(Component(i).outJunc).P = Junc(Component(i).inJunc).P - Mechanics.IHX(Component(i).index).dP;
                    else
                        Junc(Component(i).outJunc).P = Junc(Component(i).inJunc).P * (1 + Mechanics.IHX(Component(i).index).dP);
                    end
                elseif(Junc(Component(i).outJunc).P ~= -1)
                    if(Mechanics.IHX(Component(i).index).dP > 0)
                        Junc(Component(i).inJunc).P = Junc(Component(i).outJunc).P + Mechanics.IHX(Component(i).index).dP;
                    else
                        Junc(Component(i).inJunc).P = Junc(Component(i).outJunc).P / (1 + Mechanics.IHX(Component(i).index).dP);
                    end
                end
            %%%
            case 'Valve'
                if(Mechanics.Valve(Component(i).index).indicator == 0)
                    if(Junc(Component(i).inJunc).P ~= -1)
                        if(Mechanics.Valve(Component(i).index).dP > 0)
                            Junc(Component(i).outJunc).P = Junc(Component(i).inJunc).P - Mechanics.Valve(Component(i).index).dP;
                        else
                            Junc(Component(i).outJunc).P = Junc(Component(i).inJunc).P * (1 + Mechanics.Valve(Component(i).index).dP);
                        end
                    elseif(Junc(Component(i).outJunc).P ~= -1)
                        if(Mechanics.Valve(Component(i).index).dP > 0)
                            Junc(Component(i).inJunc).P = Junc(Component(i).outJunc).P + Mechanics.Valve(Component(i).index).dP;
                        else
                            Junc(Component(i).inJunc).P = Junc(Component(i).outJunc).P / (1 + Mechanics.Valve(Component(i).index).dP);
                        end
                    end
                else
                    if(Junc(Mechanics.Valve(Component(i).index).indicator).P ~=-1)
                        Junc(Component(i).outJunc).P = Junc(Mechanics.Valve(Component(i).index).indicator).P;
                    end
                end
            %%%
            case 'Recuperator'
                for j=1:2
                    if(Junc(Component(i).inJunc(j)).P ~= -1)
                        if(Mechanics.Recuperator(Component(i).index).dP(j) > 0)
                            Junc(Component(i).outJunc(j)).P = Junc(Component(i).inJunc(j)).P - Mechanics.Recuperator(Component(i).index).dP(j);
                        else
                            Junc(Component(i).outJunc(j)).P = Junc(Component(i).inJunc(j)).P * (1 + Mechanics.Recuperator(Component(i).index).dP(j));
                        end
                    elseif(Junc(Component(i).outJunc(j)).P ~= -1)
                        if(Mechanics.Recuperator(Component(i).index).dP(j) > 0)
                            Junc(Component(i).inJunc(j)).P = Junc(Component(i).outJunc(j)).P + Mechanics.Recuperator(Component(i).index).dP(j);
                        else
                            Junc(Component(i).inJunc(j)).P = Junc(Component(i).outJunc(j)).P / (1 + Mechanics.Recuperator(Component(i).index).dP(j));
                        end
                    end
                end
            case 'Cooler'
                if(Junc(Component(i).inJunc).P ~= -1)
                    if(Mechanics.Cooler(Component(i).index).dP > 0)
                        Junc(Component(i).outJunc).P = Junc(Component(i).inJunc).P - Mechanics.Cooler(Component(i).index).dP;
                    else
                        Junc(Component(i).outJunc).P = Junc(Component(i).inJunc).P * (1 + Mechanics.Cooler(Component(i).index).dP);
                    end
                elseif(Junc(Component(i).outJunc).P ~= -1)
                    if(Mechanics.Cooler(Component(i).index).dP > 0)
                        Junc(Component(i).inJunc).P = Junc(Component(i).outJunc).P + Mechanics.Cooler(Component(i).index).dP;
                    else
                        Junc(Component(i).inJunc).P = Junc(Component(i).outJunc).P / (1 + Mechanics.Cooler(Component(i).index).dP);
                    end
                end
            case 'Turbine'
                if(Mechanics.Turbine(Component(i).index).indicator == 0)
                    if(Junc(Component(i).inJunc).P ~= -1)
                        Junc(Component(i).outJunc).P = Junc(Component(i).inJunc).P / Mechanics.Turbine(Component(i).index).P_ratio;
                    elseif(Junc(Component(i).outJunc).P ~= -1)
                        Junc(Component(i).inJunc).P = Junc(Component(i).outJunc).P * Mechanics.Turbine(Component(i).index).P_ratio;
                    end
                elseif(Mechanics.Turbine(Component(i).index).indicator > 0)
                    if(Junc(Mechanics.Turbine(Component(i).index).indicator).P ~=-1)
                        Junc(Component(i).outJunc).P = Junc(Mechanics.Turbine(Component(i).index).indicator).P;
                    end
                end
            case 'Compressor'
                if(Mechanics.Compressor(Component(i).index).indicator == 0)
                    if(Junc(Component(i).inJunc).P ~= -1)
                        Junc(Component(i).outJunc).P = Junc(Component(i).inJunc).P * Mechanics.Compressor(Component(i).index).P_ratio;
                    elseif(Junc(Component(i).outJunc).P ~= -1)
                        Junc(Component(i).inJunc).P = Junc(Component(i).outJunc).P / Mechanics.Compressor(Component(i).index).P_ratio;
                    end
                elseif(Mechanics.Compressor(Component(i).index).indicator > 0)
                    if(Junc(Mechanics.Compressor(Component(i).index).indicator).P ~=-1)
                        Junc(Component(i).outJunc).P = Junc(Mechanics.Compressor(Component(i).index).indicator).P;
                    end
                end
            case 'Junction'
                sign = -1;
                for j=1:size(Component(i).inJunc, 2)
                    if(Junc(Component(i).inJunc(j)).P ~=-1)
                        sign = j;
                        break;
                    end
                end
                for j=1:size(Component(i).outJunc, 2)
                    if(Junc(Component(i).outJunc(j)).P ~=-1)
                        sign = 100 + j;
                        break;
                    end
                end
                if(sign > 0)
                    if(sign > 100)
                        value = Junc(Component(i).outJunc(sign - 100)).P;
                    else
                        value = Junc(Component(i).inJunc(sign)).P;
                    end
                    for j=1:size(Component(i).inJunc, 2)
                        Junc(Component(i).inJunc(j)).P = value;
                    end
                    for j=1:size(Component(i).outJunc, 2)
                        Junc(Component(i).outJunc(j)).P = value;
                    end
                end
        end
    end
    
    for i=1:size(Junc, 2)
        if(Junc(i).P == -1)
            TF = -1;
            break;
        end
    end
    if(TF == 1)
        break;
    end
    
end

% Set Tm
for i=1:size(Component, 2)
    if(strcmp(Component(i).type, 'Recuperator'))
        Tm(Component(i).index) = getTm(Junc(Component(i).inJunc(1)).P, Junc(Component(i).inJunc(2)).P, Junc(Component(i).inJunc(2)).m/Junc(Component(i).inJunc(1)).m);
%         disp(['Ph : ', num2str(Junc(Component(i).inJunc(1)).P), ' Pc : ', num2str(Junc(Component(i).inJunc(2)).P), ' m : ', num2str(Junc(Component(i).inJunc(2)).m/Junc(Component(i).inJunc(1)).m), ' Tm : ', num2str(Tm(Component(i).index))])
    end
end

% T initialization %

for i=1:size(Junc, 2)
    if(Junc(i).T == -1)
        Junc(i).T = avgT; % Initialization
    end
end

% T solver %

oldT = zeros(1, size(Junc, 2));
T_profile = zeros(1, size(Junc, 2));

while(1)
    
    for i=1:size(Junc, 2)
        T_profile(i) = Junc(i).T;
    end
    
    T_er = max(abs(T_profile - oldT));
    
    if(T_er < Condition.Error_bound)
        break;
    end
    
    oldT = T_profile;
    
    for i=1:size(Component, 2)
        switch(Component(i).type)
            case 'Turbine'
                [Junc(Component(i).outJunc).T, Junc(Component(i).outJunc).P, WorkT(Component(i).index)] ...
                    = Comp_Turbine(Junc(Component(i).inJunc), Junc(Component(i).outJunc).P, Condition, Mechanics.Turbine(Component(i).index));
            case 'Compressor'
                [Junc(Component(i).outJunc).T, Junc(Component(i).outJunc).P, WorkC(Component(i).index)]  ...
                    = Comp_Compressor(Junc(Component(i).inJunc), Junc(Component(i).outJunc).P, Condition, Mechanics.Compressor(Component(i).index));
            case 'Junction'
                if(size(Component(i).inJunc, 2) == 1)
                    for j=1:size(Component(i).outJunc, 2)
                        Junc(Component(i).outJunc(j)).T = Junc(Component(i).inJunc).T;
                    end
                else
                    H_tot = 0;
                    for j=1:size(Component(i).inJunc, 2)
                        H_tot = H_tot + refpropm('H', 'T', Junc(Component(i).inJunc(j)).T, 'P', Junc(Component(i).inJunc(j)).P, Condition.Fluid) * Junc(Component(i).inJunc(j)).m;
                    end
                    T_out = refpropm('T', 'H', H_tot, 'P', Junc(Component(i).outJunc(1)).P, Condition.Fluid);
                    Junc(Component(i).outJunc).T = T_out;
                end
            case 'Recuperator'
                [Junc(Component(i).outJunc(1)).T, Junc(Component(i).outJunc(1)).P, Junc(Component(i).outJunc(2)).T, Junc(Component(i).outJunc(2)).P] ...
                    = Comp_Recuperator(Junc(Component(i).inJunc(1)), Junc(Component(i).inJunc(2)), Condition, Mechanics.Recuperator(Component(i).index), Tm(Component(i).index));
            %%%
            case 'Valve'
                [Junc(Component(i).outJunc).T, Junc(Component(i).outJunc).P] = Comp_Valve(Junc(Component(i).inJunc), Junc(Component(i).outJunc).P, Condition, Mechanics.Valve(Component(i).index));
            %%%
        end
    end
end

dH = 0;

for i=1:size(Component, 2)
    if(strcmp(Component(i).type, 'IHX'))
        dH1 = refpropm('H', 'T', Junc(Component(i).outJunc).T, 'P', Junc(Component(i).outJunc).P, Condition.Fluid) ...
            - refpropm('H', 'T', Junc(Component(i).inJunc).T, 'P', Junc(Component(i).inJunc).P, Condition.Fluid);
        dH = dH + dH1 * Junc(Component(i).inJunc).m;
    end
end

m_flow_rate = Condition.Q_in / sum(dH);
%
% for i=1:size(Component, 2)
%     if(strcmp(Component(i).type, 'IHX'))
%         dH(Component(i).index) = refpropm('H', 'T', Junc(Component(i).outJunc).T, 'P', Junc(Component(i).outJunc).P, Condition.Fluid) ...
%             - refpropm('H', 'T', Junc(Component(i).inJunc).T, 'P', Junc(Component(i).inJunc).P, Condition.Fluid);
%         dH(Component(i).index) = dH(Component(i).index) * Junc(Component(i).inJunc).m;
%     end
% end
%
% m_flow_rate = Condition.Q_in / sum(dH);


for i=1:size(Junc, 2)
    Junc(i).m_flow_rate = Junc(i).m * m_flow_rate;
end

WorkT = WorkT * m_flow_rate;
WorkC = WorkC * m_flow_rate;

% info.Q_in = dH * m_flow_rate;
info.Net_work = sum(WorkT) - sum(WorkC);
info.Eff = info.Net_work / Condition.Q_in;
info.m_flow_rate = m_flow_rate;
info.WorkT = WorkT;
info.WorkC = WorkC;

end

