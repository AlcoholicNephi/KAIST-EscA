function [g] = get_g(Condition, Junc, Component)
% WHR update / 20171030

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
            elseif(Component(i).split(j) == -2)
                Junc(Component(i).inJunc(j)).m = -2;
                Junc(Component(i).outJunc(j)).m = -2;
            else
                Junc(Component(i).inJunc(j)).m = Condition.split(Component(i).split(j));
                Junc(Component(i).outJunc(j)).m = Condition.split(Component(i).split(j));
            end
        end
    end
end

% T P Initiallization %

for i=1:size(Junc, 2)
    if(Junc(i).m == -2)
        Junc(i).m_flow_rate = Condition.Pri_m;
    else
        Junc(i).m_flow_rate = Junc(i).m * Condition.m_flow_rate;
    end
end


C_index = 0;
T_index = 0;
IHX_index = 0;
WHR_index = 0;

IHX = 0;
WHR = 0;

for i=1:size(Component, 2)
    switch(Component(i).type)
        case 'Compressor'
            C_index = C_index + 1;
            WorkC(C_index) = Junc(Component(i).inJunc).m_flow_rate * abs(refpropm('H', 'T', Junc(Component(i).inJunc).T, 'P', Junc(Component(i).inJunc).P, Condition.Fluid) - ...
                refpropm('H', 'T', Junc(Component(i).outJunc).T, 'P', Junc(Component(i).outJunc).P, Condition.Fluid));
        case 'Turbine'
            T_index = T_index + 1;
            WorkT(T_index) = Junc(Component(i).inJunc).m_flow_rate * abs(refpropm('H', 'T', Junc(Component(i).inJunc).T, 'P', Junc(Component(i).inJunc).P, Condition.Fluid) - ...
                refpropm('H', 'T', Junc(Component(i).outJunc).T, 'P', Junc(Component(i).outJunc).P, Condition.Fluid));
        case 'IHX'
            IHX_index = IHX_index + 1;
            IHX(IHX_index) = Junc(Component(i).inJunc).m_flow_rate * abs(refpropm('H', 'T', Junc(Component(i).inJunc).T, 'P', Junc(Component(i).inJunc).P, Condition.Fluid) - ...
                refpropm('H', 'T', Junc(Component(i).outJunc).T, 'P', Junc(Component(i).outJunc).P, Condition.Fluid));
        case 'WHR'
            WHR_index = WHR_index + 1;
            WHR(WHR_index) = Junc(Component(i).inJunc(1)).m_flow_rate * abs(refpropm('H', 'T', Junc(Component(i).inJunc(1)).T, 'P', Junc(Component(i).inJunc(1)).P, Condition.Fluid) - ...
                refpropm('H', 'T', Junc(Component(i).outJunc(1)).T, 'P', Junc(Component(i).outJunc(1)).P, Condition.Fluid));
    end
end

switch Condition.Problem
    case 'Eff'
        g = (sum(WorkT) - sum(WorkC)) / (sum(IHX) + sum(WHR)); %%% Eff
    case 'Work'
        g = (sum(WorkT) - sum(WorkC)); %%% Work



end

