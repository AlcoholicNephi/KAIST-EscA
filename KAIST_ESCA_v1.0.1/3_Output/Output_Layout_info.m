function [] = Output_Layout_info( Component, Junc)

disp(' ')
disp('///////////////////////////////////// Layout Info //////////////////////////////////////////')
disp(' ')
disp('/////////////////////////////////// Components info ////////////////////////////////////////')
disp(' ')
str = sprintf('%30s %25s %25s', 'Component name', 'Inlet channel ID', 'Outlet channel ID');
disp(str)
for i=1:size(Component, 2)
    if(strcmp(Component(i).type, 'Junction') || strcmp(Component(i).type, 'Linked_IHX_Don') || strcmp(Component(i).type, 'Linked_IHX_Rec'))
        str_injunc = '';
        str_outjunc = '';
        
        for j=1:size(Component(i).inJunc, 2)
            str_injunc = [str_injunc, ' ', num2str(Component(i).inJunc(j))];
        end
        
        for j=1:size(Component(i).outJunc, 2)
            str_outjunc = [str_outjunc, ' ', num2str(Component(i).outJunc(j))];
        end
        
        str = sprintf('%30s %25s %25s', Component(i).ID, str_injunc, str_outjunc);
        disp(str)
    else
        
        if(size(Component(i).inJunc, 2) == 1)
            str = sprintf('%30s %25d %25d', Component(i).ID, Component(i).inJunc, Component(i).outJunc);
            disp(str)
        else
            if(strcmp(Component(i).type, 'Recuperator'))
                str = sprintf('%24s (Hot) %25d %25d', Component(i).ID, Component(i).inJunc(1), Component(i).outJunc(1));
                disp(str)
                str = sprintf('%23s (Cold) %25d %25d', Component(i).ID, Component(i).inJunc(2), Component(i).outJunc(2));
                disp(str)
            end
        end
    end
end

disp(' ')
disp('///////////////////////////////////// Channel info /////////////////////////////////////////')
disp(' ')

str = sprintf('%15s %25s %25s %25s', 'Channel ID', 'Channel P drop(kPa)', 'inlet component name', 'outlet component name');
disp(str)
disp(' ')

for i=1:size(Junc, 2)
    str = sprintf('%15d %25g %25s %25s', i, Junc(i).dP, Component(Junc(i).in_comp).ID, Component(Junc(i).out_comp).ID);
    disp(str)
end

disp(' ')
disp('////////////////////////////////////////////////////////////////////////////////////////////')

end