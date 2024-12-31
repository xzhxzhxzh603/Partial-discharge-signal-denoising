% %生成周期性窄带信号代码
% clear all;
% fs = 2048;           % 采样频率 (Hz)
% t = 0:1/fs:1-1/fs;   % 时间向量
% f_signal = 5;        % 正弦信号频率 (Hz)
% A_signal = 1;        % 正弦信号幅值
% f_noise = 10;        % 窄带噪声频率 (Hz)
% A_noise = 0.1;       % 窄带噪声幅值
% noise = A_noise * sin(2 * pi * f_noise * t);
% dataTable = array2table([t' noise'], 'VariableNames', {'时间', '噪声幅值'});
% plot(noise)
% % 导出到 Excel 文件
% writetable(dataTable, 'narrowsignal.xlsx');

% %窄带信号加入PD信号
% clear all;
% clc;
% A=xlsread('orignalnarrow.xlsx');%wxcel导入数据
% t=A(3:2000,1);%时间
% y=A(3:2000,2);%信号
% subplot(3,1,1),plot(t,y);title('原始信号');xlabel('时间t/s');

