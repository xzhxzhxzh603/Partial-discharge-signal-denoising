clear all;
clc;

% 从 Excel 文件中读取数据
A = xlsread('orignalnarrow.xlsx');
orignal_t1 = A(3:2000, 1); % 时间向量
orignal_y1 = A(3:2000, 2); % 含噪信号

% 4阶巴特沃斯低通滤波器
Fs = 1500; % 假设采样频率为10000Hz（根据实际情况调整）
Fc = 100; % 低通滤波器的截止频率（根据实际情况调整）
[b, a] = butter(4, Fc / (Fs / 2), 'low'); % 设计4阶巴特沃斯低通滤波器
filtered_signal_1_2 = filtfilt(b, a, orignal_y1);

% 移动平均滤波
window_size = 200; % 窗口大小，可以根据需要调整 可以修改 20 30 50 
moving_avg_filter = ones(1, window_size) / window_size;
filtered_signal_2_2 = conv(orignal_y1, moving_avg_filter, 'same');

% 阈值滤波器
threshold = 0.18;
filtered_signal_3_2= orignal_y1 .* (abs(orignal_y1) >= threshold);% 滤除幅值小于阈值的信号部分

%奇异值分解（SVD）
% 将信号矩阵化为二维矩阵以进行SVD
X = orignal_y1';
% 执行奇异值分解
[U, S, V] = svd(X, 'econ');
% 确定阈值
sigma_max = max(diag(S)); % 最大奇异值
sigma_min = min(diag(S)); % 最小奇异值
threshold = sigma_min; % 设置阈值为最小奇异值
% 将小于阈值的奇异值置零
S_thresholded = S;
S_thresholded(S < threshold) = 0.01;
% 重构信号
X_filtered = U * S_thresholded * V';
% 将结果转换回一维向量
filtered_signal_4_2 = X_filtered';

%PD原始信号
Fn=6e7/2;
orignal_t=(0:2047)/60e6;
orignal_y=pd_pulse(orignal_t,600/60e6,'2',1/1e-6,1/0.1e-6,1e6);

%绘图
figure;
subplot(5,1,1);
plot(orignal_t, orignal_y);
title('Orignal PD signal');
%xlabel('time (s)');
ylabel('Amplitude(V)');
grid on;

subplot(5,1,2);
plot(orignal_t1, filtered_signal_2_2);%移动平均滤波MAF
title('Moving average filter');
%xlabel('time (s)');
ylabel('Amplitude(V)');

subplot(5,1,3);
plot(orignal_t1, filtered_signal_1_2);%4阶巴特沃斯低通滤波器 BLF
title('Butterworth low-pass filter');
%xlabel('time (s)');
ylabel('Amplitude(V)');
grid on;

subplot(5,1,4);
plot(orignal_t1, filtered_signal_4_2);%简单阈值滤波器TF
title('Simple threshold filter');
%xlabel('time (s)');
ylabel('Amplitude(V)');

subplot(5,1,5);
plot(orignal_t1, filtered_signal_3_2);%奇异值分解SVD
title('Singular Value Decomposition');
xlabel('time (s)');
ylabel('Amplitude(V)');

figure;
% 在同一个图中绘制多个函数，使用不同的颜色
plot(orignal_t,orignal_y,'b',orignal_t1,filtered_signal_2_2,'r',orignal_t1, filtered_signal_3_2, 'm'); % 'r', 'g', 'b' 分别代表红色、绿色和蓝色
legend('PD signal','MAF',  'SVD'); % 添加图例
title('Comparison between different methods');
xlabel('time (s)');
ylabel('Amplitude(V)');

