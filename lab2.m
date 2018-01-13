clear all

csv1=csvread('/Users/niquit/WIZUT/PTD/lab2/lab2.1.csv');
csv2=csvread('/Users/niquit/WIZUT/PTD/lab2/lab2.2.csv');
csv3=csvread('/Users/niquit/WIZUT/PTD/lab2/lab2.3.csv');
csv4=csvread('/Users/niquit/WIZUT/PTD/lab2/lab2.4.csv');

hold on

subplot(211)
plot(csv2,csv1);
title("Ton prosty");
xlabel("Okres");
ylabel("Amplituda");

subplot(212)
plot(csv4,csv3);
title("DFT");
xlabel("Częstotliwość");
ylabel("Amplituda");