

%%%% Component information %%%

Component(1).type = 'WHR';
Component(1).ID = 'WHR';
Component(1).index = 1;
Component(1).inJunc = [10, 15];
Component(1).outJunc = [1, 16];
Component(1).split = [-1, -2]; % not splited

Component(2).type = 'Turbine';
Component(2).ID = 'HP Turbine';
Component(2).index = 1;
Component(2).inJunc = 1;
Component(2).outJunc = 2;
Component(2).split = -1; % not splited

Component(3).type = 'Recuperator';
Component(3).ID = 'HT Recuperator';
Component(3).index = 1;
Component(3).inJunc = [2, 9]; % 약속 : Hot / Cold 순으로 작성
Component(3).outJunc = [3, 10];
Component(3).split = [-1, -1]; % splited

Component(4).type = 'Recuperator';
Component(4).ID = 'LT Recuperator';
Component(4).index = 2;
Component(4).inJunc = [3, 14];
Component(4).outJunc = [4, 8];
Component(4).split = [-1, 1]; % not splited

Component(5).type = 'Junction';
Component(5).ID = 'Junction 1';
Component(5).inJunc = 4;
Component(5).outJunc = [5, 11];
Component(5).split = [-1, 1, 2]; % in, out1, out2

Component(6).type = 'Cooler';
Component(6).ID = 'inter Cooler';
Component(6).inJunc = 5;
Component(6).outJunc = 6;
Component(6).index = 1;
Component(6).split = 1; % not splited

Component(7).type = 'Compressor';
Component(7).ID = 'Main compressor';
Component(7).P_target = -1; % Max P 까지를 나타내는 indicator
Component(7).inJunc = 6;
Component(7).outJunc = 7;
Component(7).index = 1;
Component(7).split = 1; % not splited

Component(8).type = 'Junction';
Component(8).ID = 'Junction 2';
Component(8).inJunc = [8, 12];
Component(8).outJunc = 9;
Component(8).split = [1, 2, -1]; % in1, in2, out
Component(8).check = 1;

Component(9).type = 'Compressor';
Component(9).ID = 'Sub Compressor';
Component(9).P_target = 8; % 8번 junction 까지
Component(9).inJunc = 11;
Component(9).outJunc = 12;
Component(9).index = 2;
Component(9).split = 2; % not splited


Component(10).type = 'Cooler';
Component(10).ID = 'inter Cooler';
Component(10).inJunc = 7;
Component(10).outJunc = 13;
Component(10).index = 2;
Component(10).split = 1; % not splited

Component(11).type = 'Compressor';
Component(11).ID = 'Sub Compressor';
Component(11).inJunc = 13;
Component(11).outJunc = 14;
Component(11).index = 3;
Component(11).split = 1; % not splited
