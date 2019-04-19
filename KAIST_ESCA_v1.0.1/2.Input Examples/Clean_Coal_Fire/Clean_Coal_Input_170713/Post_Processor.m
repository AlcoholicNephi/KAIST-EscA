clear all
close all

T1 = [63.9 
185.8 
175.5 
507.1 
600.0 
559.9 
600.0 
560.3 
600.0 
557.6 
194.9 
68.9 
68.9 
% 68.9 
% 157.8 
32.0  
63.9];

P1 = [200.0 
199.2 
199.2 
198.4 
198.0 
146.7 
146.3 
108.3 
107.9 
77.9 
77.1 
76.3 
76.3 
% 76.3 
% 199.2 
76.1 
200];

for i=1:15
    S1(i) = refpropm('S', 'T', T1(i)+273.15, 'P', P1(i) * 100, 'CO2') / 1000;
    H1(i) = refpropm('H', 'T', T1(i)+273.15, 'P', P1(i) * 100, 'CO2');
end


T2 = [41.4 
126.3 
135.2 
333.6 
500.0 
386.6 
147.3 
44.2 
44.2 
% 44.2 
% 140.3 
24.0 
41.4
];
P2 = [200.0 
199.2 
199.2 
198.4 
197.2 
75.4 
74.6 
73.8 
73.8 
% 73.8 
% 199.2 
73.6 
200];
for i=1:11
    S2(i) = refpropm('S', 'T', T2(i)+273.15, 'P', P2(i) * 100, 'CO2') / 1000;
    H2(i) = refpropm('H', 'T', T2(i)+273.15, 'P', P2(i) * 100, 'CO2');
end








mole_info = [73.6*28, 5.2*36, 7.4*18, 12*48];
mole_info = mole_info/sum(mole_info);
H3(1) = refpropm('H', 'T', 273.15+1836.2, 'P', 105, 'nitrogen', 'oxygen', 'water', 'co2', mole_info);

T3(1) = 1836.2;


H3(2) = H3(1) -  111.7561 *1e6 * 3600 /435268 ;
H3(3) = H3(2) - 47.9181 *1e6 * 3600 /435268 ;
H3(4) = H3(3) - 47.0458 *1e6 * 3600 /435268 ;

for i=2:4
    T3(i) = refpropm('T', 'H', H3(i), 'P', 105, 'nitrogen', 'oxygen', 'water', 'co2', mole_info) - 273.15;
end

T3(5) = 381;

T3 = [T3(1), T3(1), T3(2), T3(2), T3(3), T3(3), T3(4), T3(5)];
S3 = [S1(10), S1(9), S1(8), S1(7), S1(6), S1(5), S1(4), S2(4)];


hold on
plot(S3, T3, 'k', 'linewidth', 1.2)
plot(S1, T1, 'r', 'linewidth', 1.2)


plot(S2, T2, 'b', 'linewidth', 1.2)
%  xlim([3.0, 4.3])

grid on
xlabel('Entropy (kJ/kgK)')
ylabel('Temperature (oC)')


legend('Flue Gas', 'Topping Cycle', 'Bottoming Cycle', 'location', 'northwest')