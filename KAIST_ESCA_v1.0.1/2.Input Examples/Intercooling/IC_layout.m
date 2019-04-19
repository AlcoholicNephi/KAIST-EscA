IC_condition;


%%%% Component information %%%

Component(1).type = 'IHX';
Component(1).ID = 'IHX';
Component(1).index = 1;
Component(1).inJunc = 8;
Component(1).outJunc = 1;
Component(1).split = -1; % not splited

Component(2).type = 'Turbine';
Component(2).ID = 'Turbine';
Component(2).index = 1;
Component(2).inJunc = 1;
Component(2).outJunc = 2;
Component(2).split = -1; % not splited

Component(3).type = 'Recuperator';
Component(3).ID = 'Recuperator';
Component(3).index = 1;
Component(3).inJunc = [2, 7]; % 약속 : Hot / Cold 순으로 작성
Component(3).outJunc = [3, 8];
Component(3).split = [-1, -1]; % splited


Component(4).type = 'Cooler';
Component(4).ID = 'inter Cooler';
Component(4).inJunc = 3;
Component(4).outJunc = 4;
Component(4).index = 1;
Component(4).split = -1; % not splited

Component(5).type = 'Compressor';
Component(5).ID = 'Main compressor';
Component(5).P_target = -1;
Component(5).inJunc = 4;
Component(5).outJunc = 5;
Component(5).index = 1;
Component(5).split = -1; % not splited


Component(6).type = 'Cooler';
Component(6).ID = 'inter Cooler';
Component(6).inJunc = 5;
Component(6).outJunc = 6;
Component(6).index = 1;
Component(6).split = -1; % not splited

Component(7).type = 'Compressor';
Component(7).ID = 'Main compressor';
Component(7).P_target = -1;
Component(7).inJunc = 6;
Component(7).outJunc = 7;
Component(7).index = 1;
Component(7).split = -1; % not splited

