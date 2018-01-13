clear all

csv1=csvread('/Users/niquit/WIZUT/PTD/lab4/lab4.1.csv');
csv2=csvread('/Users/niquit/WIZUT/PTD/lab4/lab4.2.csv');
csv3=csvread('/Users/niquit/WIZUT/PTD/lab4/lab4.3.csv');
csv4=csvread('/Users/niquit/WIZUT/PTD/lab4/lab4.4.csv');
csv5=csvread('/Users/niquit/WIZUT/PTD/lab4/lab4.5.csv');
csv6=csvread('/Users/niquit/WIZUT/PTD/lab4/lab4.6.csv');
csv7=csvread('/Users/niquit/WIZUT/PTD/lab4/lab4.7.csv');
csv8=csvread('/Users/niquit/WIZUT/PTD/lab4/lab4.8.csv');
csv9=csvread('/Users/niquit/WIZUT/PTD/lab4/lab4.9.csv');
csv10=csvread('/Users/niquit/WIZUT/PTD/lab4/lab4.10.csv');
csv11=csvread('/Users/niquit/WIZUT/PTD/lab4/lab4.11.csv');
csv13=csvread('/Users/niquit/WIZUT/PTD/lab4/lab4.13.csv');

hold on

subplot(511)
plot(csv2,csv1)
title("Sygnał nośny")
xlabel("Okres");
ylabel("Amplituda");
subplot(512)
plot(csv2,csv3)
title("Sygnał 0/1")
xlabel("Okres");
ylabel("Amplituda");
subplot(537)
plot(csv2,csv4)
title("ASK")
xlabel("Okres");
ylabel("Amplituda");
subplot(538)
plot(csv2,csv7)
title("FSK")
xlabel("Okres");
ylabel("Amplituda");
subplot(539)
plot(csv2,csv9)
title("PSK")
xlabel("Okres");
ylabel("Amplituda");
subplot(5,3,10)
plot(csv6,csv5)
title("Widmo ASK")
xlabel("Częstotliwość");
ylabel("Amplituda");
subplot(5,3,11)
plot(csv6,csv8)
title("Widmo FSK")
xlabel("Częstotliwość");
ylabel("Amplituda");
subplot(5,3,12)
plot(csv6,csv10)
title("Widmo PSK")
xlabel("Częstotliwość");
ylabel("Amplituda");
subplot(5,3,13)
plot(csv2,csv11)
title("Demodulacja ASK")
xlabel("Okres");
ylabel("Amplituda");