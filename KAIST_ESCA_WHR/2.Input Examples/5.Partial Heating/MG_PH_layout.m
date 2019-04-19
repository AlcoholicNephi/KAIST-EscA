% PH_condition;

%%%% Junction information %%%%

Num_junc = 13;


%%%% Component information %%%


Component(1).type = 'WHR';
Component(1).ID = 'Main heater';
Component(1).index = 1;
Component(1).inJunc = [10, 11]; % 약속 : Hot / Cold 순으로 작성
Component(1).outJunc = [1, 12]; % 약속 : Cycle에 연결된 channel이 먼저오도록
Component(1).split = [-1, -2]; % -2: Primary side

Component(2).type = 'Turbine';
Component(2).ID = 'HP Turbine';
Component(2).index = 1;
Component(2).inJunc = 1;
Component(2).outJunc = 2;
Component(2).split = -1;

Component(3).type = 'Recuperator';
Component(3).ID = 'Recuperator';
Component(3).index = 1;
Component(3).inJunc = [2, 7]; % 약속 : Hot / Cold 순으로 작성
Component(3).outJunc = [3, 8];
Component(3).split = [-1, 2];

Component(4).type = 'Cooler';
Component(4).ID = 'Cooling device';
Component(4).index = 1;
Component(4).inJunc = 3;
Component(4).outJunc = 4;
Component(4).split = -1;

Component(5).type = 'Compressor';
Component(5).ID = 'Main compressor';
Component(5).inJunc = 4;
Component(5).outJunc = 5;
Component(5).index = 1;
Component(5).split = -1;

Component(6).type = 'WHR';
Component(6).ID = 'Sub heater';
Component(6).index = 2;
Component(6).inJunc = [6, 12];
Component(6).outJunc = [9, 13];
Component(6).split = [1, -2];

Component(7).type = 'Junction';
Component(7).ID = 'Split Junction';
Component(7).inJunc = 5;
Component(7).outJunc = [6, 7];
Component(7).split = [-1, 1, 2];

Component(8).type = 'Junction';
Component(8).ID = 'Merge Junction';
Component(8).inJunc = [8, 9];
Component(8).outJunc = 10;
Component(8).split = [2, 1, -1];
Component(8).check = 0;
