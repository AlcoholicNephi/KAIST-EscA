
%%% V1 %%%
% 동력랩 개귀요미 사시미가 코드를 작성했습니다 ^^ 만세 ㅎㅎ
% Recompression / Partial Heating / Pre cooling / BC3 되는거 확인
% IHX부분이 T/전체 Q1으로 bounded.
% g 에 대해 minor update
% Solver minor update (필요없는짓 했음 시바)
% 
% GUI 만들고싶다
% 외주맡길각인가
%
% Minor update: V1.1 (20170714)
% Triple Reheat Input 추가 -> Double Reheat 이 맞음 (1 main heat + 2 reheat)
%
% Minor update: V1.2 (20170801)
% Update 주기를 보면 내가 얼마나 일을 안하는지 알 수 있군...
% Valve 추가 - Isenthalpic Valve / Bypass Valve 
% PG-SFR Recompression cycle 추가 : Throttling valve랑 Bypass valve 넣어서
% Working Fluid 한번 갈아엎어야 할거같은데 그럼 Input deck도 다 갈아엎어야한다. 지금은
% Condition.Fluid에서 단일 유체 넣어서 하고있는데, 조성바꾸려면 이거저거 넣어야할듯
% 고로 이건 나중에. 어차피 사우디땜에 하긴 해야할듯.
%
% IHX 문제 해결 필요. Waste heat recovery 아니면 IHX input을 waste heat으로 받는 경우는 없을거같음
%
% Minor update: V1.2.1 (20170802)
% HX dP update. +값을 넣으면 참값으로, -값은 비율로 dP 줌
% ex: Mechanics.Cooler(1).dP = 100; -> Cooler에서 100 kPa P drop
%     Mechanics.Cooler(1).dP = -0.05; -> Cooler에서 입구압력*0.05 만큼 P drop
%
% Major update : KAIST-ESCA V1.0 170818
%
% 이름바꿈 (KAIST - ESCA)
% Evaluator for Supercritiacl CO2 power cycle based on Adjoint method
% 킹짱카형 화이팅
% 내부핀치 문제 고려 - getTm 모듈 추가
%
% Minor Update : KAIST-ESCA V1.0.1 170830
% 
% RC Cycle TSD Configuration 추가
%
