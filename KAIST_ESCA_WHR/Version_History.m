
%%% V1 %%%
% ���·� ���Ϳ�� ��ṵ̀� �ڵ带 �ۼ��߽��ϴ� ^^ ���� ����
% Recompression / Partial Heating / Pre cooling / BC3 �Ǵ°� Ȯ��
% IHX�κ��� T/��ü Q1���� bounded.
% g �� ���� minor update
% Solver minor update (�ʿ������ ���� �ù�)
% 
% GUI �����ʹ�
% ���ָñ氢�ΰ�
%
% Minor update: V1.1 (20170714)
% Triple Reheat Input �߰� -> Double Reheat �� ���� (1 main heat + 2 reheat)
%
% Minor update: V1.2 (20170801)
% Update �ֱ⸦ ���� ���� �󸶳� ���� ���ϴ��� �� �� �ֱ�...
% Valve �߰� - Isenthalpic Valve / Bypass Valve 
% PG-SFR Recompression cycle �߰� : Throttling valve�� Bypass valve �־
% Working Fluid �ѹ� ���ƾ���� �ҰŰ����� �׷� Input deck�� �� ���ƾ�����Ѵ�. ������
% Condition.Fluid���� ���� ��ü �־ �ϰ��ִµ�, �����ٲٷ��� �̰����� �־���ҵ�
% ��� �̰� ���߿�. ������ ���𶫿� �ϱ� �ؾ��ҵ�.
%
% IHX ���� �ذ� �ʿ�. Waste heat recovery �ƴϸ� IHX input�� waste heat���� �޴� ���� �����Ű���
%
% Minor update: V1.2.1 (20170802)
% HX dP update. +���� ������ ��������, -���� ������ dP ��
% ex: Mechanics.Cooler(1).dP = 100; -> Cooler���� 100 kPa P drop
%     Mechanics.Cooler(1).dP = -0.05; -> Cooler���� �Ա��з�*0.05 ��ŭ P drop
%
% Major update : KAIST-ESCA V1.0 170818
%
% �̸��ٲ� (KAIST - ESCA)
% Evaluator for Supercritiacl CO2 power cycle based on Adjoint method
% ŷ¯ī�� ȭ����
% ������ġ ���� ��� - getTm ��� �߰�
%
% Minor Update : KAIST-ESCA V1.0.1 170830
% 
% RC Cycle TSD Configuration �߰�
%
% Minor Upcate : KAIST-ESCA V1.0.2 170831 (Bug fix)
%
% Merge energy balance �����ִ� �κ� ����
% Quasi-steady state module ������
% 
% Major Update : KAIST-ESCA (+Q), V1.1 170914
%
% Quasi ��� ù�߰�
% Quasi ���� ����ȯ��� ��� �з°��ϸ� ����ϵ���.
%
% Major Update : KAIST-ESCA (+Q), V1.2 171030
%
% WHR Steady solver �߰� (�α�����)
%
% Minor Update : KAIST-ESCA (+Q), V1.2.1 171107
%
% �α� Input deck �߰�
% Error shooting �ʿ� -> solver�� ���� �������� �� ���� ������ �� ���� � Equation�� ������� ����
% ������ �����ϴ� ������ �ٲ����.
%
