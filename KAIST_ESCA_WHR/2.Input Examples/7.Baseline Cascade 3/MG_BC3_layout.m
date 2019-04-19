
%%%% Component information %%%


Component(1).type = 'WHR';
Component(1).ID = 'Main heater';
Component(1).index = 1;
Component(1).inJunc = [18, 19];
Component(1).outJunc = [1, 20]; % 약속 : Cycle에 연결된 channel이 먼저오도록
Component(1).split = [3, -2];

Component(2).type = 'WHR';
Component(2).ID = 'Sub heater';
Component(2).index = 2;
Component(2).inJunc = [16, 20];
Component(2).outJunc = [11, 21]; % 약속 : Cycle에 연결된 channel이 먼저오도록
Component(2).split = [1, -2];

Component(3).type = 'Turbine';
Component(3).ID = 'HT';
Component(3).index = 1;
Component(3).inJunc = 1;
Component(3).outJunc = 2;
Component(3).split = 3;

Component(4).type = 'Turbine';
Component(4).ID = 'LT';
Component(4).index = 2;
Component(4).inJunc = 13;
Component(4).outJunc = 14;
Component(4).split = 4;

Component(5).type = 'Recuperator';
Component(5).ID = 'HTR';
Component(5).index = 1;
Component(5).inJunc = [2, 17]; % 약속 : Hot / Cold 순으로 작성
Component(5).outJunc = [3, 13];
Component(5).split = [3, 4];

Component(6).type = 'Recuperator';
Component(6).ID = 'LTR';
Component(6).index = 2;
Component(6).inJunc = [4, 15]; % 약속 : Hot / Cold 순으로 작성
Component(6).outJunc = [5, 10];
Component(6).split = [-1, 2];

Component(7).type = 'Compressor';
Component(7).ID = 'C2';
Component(7).inJunc = 8;
Component(7).outJunc = 9;
Component(7).index = 2;
Component(7).split = -1;

Component(8).type = 'Cooler';
Component(8).ID = 'IC';
Component(8).index = 2;
Component(8).inJunc = 7;
Component(8).outJunc = 8;
Component(8).split = -1;

Component(9).type = 'Compressor';
Component(9).ID = 'C1';
Component(9).inJunc = 6;
Component(9).outJunc = 7;
Component(9).index = 1;
Component(9).split = -1;

Component(10).type = 'Cooler';
Component(10).ID = 'PC';
Component(10).index = 1;
Component(10).inJunc = 5;
Component(10).outJunc = 6;
Component(10).split = -1;

Component(11).type = 'Junction';
Component(11).ID = 'Split Junction 1';
Component(11).inJunc = 9;
Component(11).outJunc = [16, 15];
Component(11).split = [-1, 1, 2];

Component(12).type = 'Junction';
Component(12).ID = 'Merge Junction 1';
Component(12).inJunc = [10, 11];
Component(12).outJunc = 12;
Component(12).split = [2, 1, -1];
Component(12).check = 0;


Component(13).type = 'Junction';
Component(13).ID = 'Split Junction 2';
Component(13).inJunc = 12;
Component(13).outJunc = [17, 18];
Component(13).split = [-1, 4, 3];


Component(14).type = 'Junction';
Component(14).ID = 'Merge Junction 2';
Component(14).inJunc = [14, 3];
Component(14).outJunc = 4;
Component(14).split = [4, 3, -1];
Component(14).check = 0;



