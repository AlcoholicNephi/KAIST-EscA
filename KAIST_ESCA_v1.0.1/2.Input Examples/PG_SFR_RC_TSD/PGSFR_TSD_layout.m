
PGSFR_TSD_condition;


%%%% Component information %%%

Component(1).type = 'IHX';
Component(1).ID = 'IHX';
Component(1).index = 1;
Component(1).inJunc = 17;
Component(1).outJunc = 1;
Component(1).split = 3; % not splited

Component(2).type = 'Valve';
Component(2).ID = 'Throttle Valve';
Component(2).index = 1;
Component(2).inJunc = 1;
Component(2).outJunc = 2;
Component(2).split = 3;

Component(3).type = 'Turbine';
Component(3).ID = 'HP Turbine';
Component(3).index = 1;
Component(3).inJunc = 2;
Component(3).outJunc = 18;
Component(3).split = 3; % not splited

Component(14).type = 'Junction';
Component(14).ID = 'Turbine Split';
Component(14).inJunc = 18;
Component(14).outJunc = [19, 20];
Component(14).split = [3, 5, 6];

Component(15).type = 'Junction';
Component(15).ID = 'Turbine Merge';
Component(15).inJunc = [21, 22];
Component(15).outJunc = 3;
Component(15).split = [5, 6, 3];

Component(16).type = 'Turbine';
Component(16).ID = 'MC Driven Turbine';
Component(16).index = 2;
Component(16).inJunc = 19;
Component(16).outJunc = 21;
Component(16).split = 5; % not splited

Component(17).type = 'Turbine';
Component(17).ID = 'RC Driven Turbine';
Component(17).index = 3;
Component(17).inJunc = 20;
Component(17).outJunc = 22;
Component(17).split = 6; % not splited

Component(4).type = 'Recuperator';
Component(4).ID = 'HT Recuperator';
Component(4).index = 1;
Component(4).inJunc = [3, 16]; % 약속 : Hot / Cold 순으로 작성
Component(4).outJunc = [4, 17];
Component(4).split = [3, 3]; % splited

Component(5).type = 'Recuperator';
Component(5).ID = 'LT Recuperator';
Component(5).index = 2;
Component(5).inJunc = [5, 9];
Component(5).outJunc = [6, 10];
Component(5).split = [-1, 1];

Component(6).type = 'Cooler';
Component(6).ID = 'inter Cooler';
Component(6).inJunc = 7;
Component(6).outJunc = 8;
Component(6).index = 1;
Component(6).split = 1; 

Component(7).type = 'Compressor';
Component(7).ID = 'Main compressor';
Component(7).P_target = -1; % Max P 까지를 나타내는 indicator
Component(7).inJunc = 8;
Component(7).outJunc = 9;
Component(7).index = 1;
Component(7).split = 1; 

Component(8).type = 'Compressor';
Component(8).ID = 'Sub Compressor';
Component(8).inJunc = 11;
Component(8).outJunc = 12;
Component(8).index = 2;
Component(8).split = 2; 

Component(9).type = 'Valve';
Component(9).ID = 'Bypass Valve';
Component(9).index = 2;
Component(9).inJunc = 14;
Component(9).outJunc = 15;
Component(9).split = 4;

Component(10).type = 'Junction';
Component(10).ID = 'Split Junction';
Component(10).inJunc = 6;
Component(10).outJunc = [7, 11];
Component(10).split = [-1, 1, 2]; % in, out1, out2

Component(11).type = 'Junction';
Component(11).ID = 'Merge Junction';
Component(11).inJunc = [10, 12];
Component(11).outJunc = 13;
Component(11).split = [1, 2, -1]; % in1, in2, out

Component(12).type = 'Junction';
Component(12).ID = 'Bypass';
Component(12).inJunc = 13;
Component(12).outJunc = [16, 14];
Component(12).split = [-1, 3, 4]; % in, out1, out2

Component(13).type = 'Junction';
Component(13).ID = 'Merge Bypass';
Component(13).inJunc = [4, 15];
Component(13).outJunc = 5;
Component(13).split = [3, 4, -1]; % in1, in2, out




