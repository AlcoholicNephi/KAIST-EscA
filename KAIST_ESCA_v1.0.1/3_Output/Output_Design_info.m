function [] = Output_Design_info( Component, Junc)

disp(' ')
disp('///////////////////////////////////// Design Point Info //////////////////////////////////////////')
disp(' ')


str = sprintf('%30s %25s %25s %25s %25s %25s', 'Component name', 'mass flow', 'Inlet T', 'Inlet P', 'Outlet T', 'Outlet P');
disp(str)
for i=1:size(Component, 2)
    switch Component(i).type
        case 'Turbine'
            str = sprintf('%30s %25g %25g %25g %25g %25g', Component(i).ID, Junc(Component(i).inJunc).m_flow_rate, Junc(Component(i).inJunc).T, Junc(Component(i).inJunc).P, Junc(Component(i).outJunc).T, Junc(Component(i).outJunc).P);
            disp(str)
        case 'Compressor'
            str = sprintf('%30s %25g %25g %25g %25g %25g', Component(i).ID, Junc(Component(i).inJunc).m_flow_rate, Junc(Component(i).inJunc).T, Junc(Component(i).inJunc).P, Junc(Component(i).outJunc).T, Junc(Component(i).outJunc).P);
            disp(str)
        case 'IHX'
            str = sprintf('%30s %25g %25g %25g %25g %25g', Component(i).ID, Junc(Component(i).inJunc).m_flow_rate, Junc(Component(i).inJunc).T, Junc(Component(i).inJunc).P, Junc(Component(i).outJunc).T, Junc(Component(i).outJunc).P);
            disp(str)
        case 'Cooler'
            str = sprintf('%30s %25g %25g %25g %25g %25g', Component(i).ID, Junc(Component(i).inJunc).m_flow_rate, Junc(Component(i).inJunc).T, Junc(Component(i).inJunc).P, Junc(Component(i).outJunc).T, Junc(Component(i).outJunc).P);
            disp(str)
        case 'Recuperator'
            str = sprintf('%20s (Primary) %25g %25g %25g %25g %25g', Component(i).ID, Junc(Component(i).inJunc(1)).m_flow_rate, Junc(Component(i).inJunc(1)).T, Junc(Component(i).inJunc(1)).P, Junc(Component(i).outJunc(1)).T, Junc(Component(i).outJunc(1)).P);
            disp(str)
            str = sprintf('%18s (Secondary) %25g %25g %25g %25g %25g', Component(i).ID, Junc(Component(i).inJunc(2)).m_flow_rate, Junc(Component(i).inJunc(2)).T, Junc(Component(i).inJunc(2)).P, Junc(Component(i).outJunc(2)).T, Junc(Component(i).outJunc(2)).P);
            disp(str)
    end
    
    
end
end