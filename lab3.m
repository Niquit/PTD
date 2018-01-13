clear all

csv1=csvread('/Users/niquit/WIZUT/PTD/lab3/lab3.1.csv');
csv2=csvread('/Users/niquit/WIZUT/PTD/lab3/lab3.2.csv');
csv3=csvread('/Users/niquit/WIZUT/PTD/lab3/lab3.3.csv');
csv4=csvread('/Users/niquit/WIZUT/PTD/lab3/lab3.4.csv');
csv5=csvread('/Users/niquit/WIZUT/PTD/lab3/lab3.5.csv');
csv6=csvread('/Users/niquit/WIZUT/PTD/lab3/lab3.6.csv');
csv7=csvread('/Users/niquit/WIZUT/PTD/lab3/lab3.7.csv');
csv8=csvread('/Users/niquit/WIZUT/PTD/lab3/lab3.8.csv');

hold on

subplot(411)
plot(csv2,csv1)
title("Sygnał nośny")
xlabel("Okres");
ylabel("Amplituda");
subplot(412)
plot(csv2,csv3)
title("Sygnał informacyjny")
xlabel("Okres");
ylabel("Amplituda");
subplot(425)
plot(csv2,csv4)
title("AM")
xlabel("Okres");
ylabel("Amplituda");
subplot(426)
plot(csv2,csv7)
title("PM")
xlabel("Okres");
ylabel("Amplituda");
subplot(427)
plot(csv6,csv5)
title("Widmo AM")
xlabel("Częstotliwość");
ylabel("Amplituda");
subplot(428)
plot(csv6,csv8)
title("Widmo PM")
xlabel("Częstotliwość");
ylabel("Amplituda");
