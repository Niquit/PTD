clear all

csv1=csvread('/Users/niquit/WIZUT/PTD/lab1/lab1.1.csv');
csv2=csvread('/Users/niquit/WIZUT/PTD/lab1/lab1.2.csv');

plot(csv2,csv1);
title("Ton prosty");
xlabel("Okres");
ylabel("Amplituda");