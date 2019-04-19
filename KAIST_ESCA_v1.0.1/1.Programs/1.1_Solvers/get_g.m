function [g] = get_g(Condition, Junc, Component)

for i=1:size(Condition.split_link_value, 2)
    Condition.split(Condition.split_link(2*i)) = Condition.split_link_value(i) - Condition.split(Condition.split_link(i*2 - 1));
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

C_index = 0;
T_index = 0;
IHX_index = 0;

for i=1:size(Component, 2)
    switch(Component(i).type)
        case 'Compressor'
            C_index = C_index + 1;
            WorkC(C_index) = Junc(Component(i).inJunc).m * abs(refpropm('H', 'T', Junc(Component(i).inJunc).T, 'P', Junc(Component(i).inJunc).P, Condition.Fluid) - ...
                refpropm('H', 'T', Junc(Component(i).outJunc).T, 'P', Junc(Component(i).outJunc).P, Condition.Fluid));
        case 'Turbine'
            T_index = T_index + 1;
            WorkT(T_index) = Junc(Component(i).inJunc).m * abs(refpropm('H', 'T', Junc(Component(i).inJunc).T, 'P', Junc(Component(i).inJunc).P, Condition.Fluid) - ...
                refpropm('H', 'T', Junc(Component(i).outJunc).T, 'P', Junc(Component(i).outJunc).P, Condition.Fluid));
        case 'IHX'
            IHX_index = IHX_index + 1;
            IHX(IHX_index) = Junc(Component(i).inJunc).m * abs(refpropm('H', 'T', Junc(Component(i).inJunc).T, 'P', Junc(Component(i).inJunc).P, Condition.Fluid) - ...
                refpropm('H', 'T', Junc(Component(i).outJunc).T, 'P', Junc(Component(i).outJunc).P, Condition.Fluid));
    end
end

g = (sum(WorkT) - sum(WorkC)) / sum(IHX);


end

