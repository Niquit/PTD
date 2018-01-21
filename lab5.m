clear all

csv1=csvread('/Users/niquit/WIZUT/PTD/lab5/lab5.1.csv');
csv2=csvread('/Users/niquit/WIZUT/PTD/lab5/lab5.2.csv');
csv3=csvread('/Users/niquit/WIZUT/PTD/lab5/lab5.3.csv');
csv4=csvread('/Users/niquit/WIZUT/PTD/lab5/lab5.4.csv');
csv5=csvread('/Users/niquit/WIZUT/PTD/lab5/lab5.5.csv');
csv6=csvread('/Users/niquit/WIZUT/PTD/lab5/lab5.6.csv');
csv7=csvread('/Users/niquit/WIZUT/PTD/lab5/lab5.7.csv');
csv8=csvread('/Users/niquit/WIZUT/PTD/lab5/lab5.8.csv');

hold on

subplot(411)
plot(csv2,csv1)
title("Sygnał nośny")
xlabel("Okres");
ylabel("Amplituda");
subplot(412)
plot(csv2,csv3)
title("Sygnał 0/1")
xlabel("Okres");
ylabel("Amplituda");
subplot(425)
plot(csv2,csv4)
title("QPSK")
xlabel("Okres");
ylabel("Amplituda");
subplot(426)
plot(csv2,csv7)
title("QAM")
xlabel("Okres");
ylabel("Amplituda");
subplot(427)
plot(csv6,csv5)
title("Widmo QPSK")
xlabel("Częstotliwość");
ylabel("Amplituda");
subplot(428)
plot(csv6,csv8)
title("Widmo QAM")
xlabel("Częstotliwość");
ylabel("Amplituda");