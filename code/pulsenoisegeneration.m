% %生成impulse PD信号
% clear all;
% clc;
% A=xlsread('pulsesignal.xlsx');%wxcel导入数据
% t=A(3:2000,1);%时间
% y=A(3:2000,2);%信号
% subplot(3,1,1),plot(t,y);title('原始信号');xlabel('时间t/s');

%生成impulse PD信号

A1=xlsread('orignalPD.xlsx');%wxcel导入数据
t1=A1(3:2000,1);%时间
y1=A1(3:2000,2);%信号
subplot(3,1,1),plot(t1,y1);
title('Orignal PD signal');
% xlabel('时间t/s');


%生成impulse信号

t = 0:1:100;
w=50;
y=square(0.5*t,w)/10;
%ylim([-6.5 6.5])
grid
% dataTable = array2table([t' y'], 'VariableNames', {'时间', '噪声幅值'});
subplot(3,1,2),plot(t,y);title('Pulse noise');ylabel('Amplitude(V)');

% %生成impulse PD信号

A2=xlsread('pulsePD.xlsx');%wxcel导入数据
t2=A2(3:2000,1);%时间
y2=A2(3:2000,2);%信号
subplot(3,1,3),plot(t2,y2);title('Noisy PD signals');xlabel('Time(s)');

% plot(y)
% % 导出到 Excel 文件
% writetable(dataTable, 'narrow.xls');