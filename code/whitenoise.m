%原始信号
clc
Fn=6e7/2;
orignal_t=(0:2047)/60e6;
orignal_y=pd_pulse(orignal_t,600/60e6,'2',1/1e-6,1/0.1e-6,1e6);

% 添加白噪声
noise_level = 0.2; % 可以根据需要调整噪声水平
noise = noise_level * randn(size(orignal_y));
noisy_signal = orignal_y + noise;

% 应用中值滤波器（注意：中值滤波器通常用于去除脉冲噪声，对高斯噪声效果有限）
filter_length = 5; % 滤波器窗口长度（必须是奇数）
filtered_signal_1 = medfilt1(noisy_signal, filter_length);

% 4阶巴特沃斯低通滤波器
Fs = 10000; % 假设采样频率为10000Hz（根据实际情况调整）
Fc = 500; % 低通滤波器的截止频率（根据实际情况调整）
[b, a] = butter(4, Fc / (Fs / 2), 'low'); % 设计4阶巴特沃斯低通滤波器
filtered_signal_2 = filtfilt(b, a, noisy_signal);

% 移动平均滤波
window_size = 30; % 窗口大小，可以根据需要调整 可以修改 20 30 50 
moving_avg_filter = ones(1, window_size) / window_size;
filtered_signal_3 = conv(noisy_signal, moving_avg_filter, 'same');

% 设计FIR低通滤波器
Fs = 10000; % 假设采样频率为10000Hz（根据实际情况调整）
Fc = 500; % 低通滤波器的截止频率（根据实际情况调整）
N = 100; % 滤波器的阶数（可以根据需要调整）
[b, a] = fir1(N, Fc / (Fs / 2), 'low'); % 设计FIR低通滤波器
filtered_signal_4 = filtfilt(b, 1, noisy_signal); % 使用零相位滤波来避免相位失真

% 应用简单平均滤波
filter_window = 5; % 滤波器窗口大小（必须是奇数）
filtered_signal_5 = conv(noisy_signal, ones(1, filter_window) / filter_window, 'same');

% 小波变换去噪
% 选择小波基和分解级数
waveletName = 'db4'; % 小波基
level = 5; % 分解级数
% 进行小波分解
[coeffs, lengths] = wavedec(noisy_signal, level, waveletName);
% 阈值处理
sigma = median(abs(coeffs)) / 0.6745; % 估计噪声标准差
threshold = sigma * sqrt(2 * log(length(noisy_signal))); % 阈值
% 硬阈值处理
shrinkage = wthresh(coeffs, 'h', threshold);
% 重构信号
filtered_signal_7 = waverec(shrinkage, lengths, waveletName);

% 小波变换去噪
% 选择小波基和分解级数
waveletName = 'db4'; % 小波基
level = 5; % 分解级数
% 进行小波分解
[coeffs, lengths] = wavedec(noisy_signal, level, waveletName);
% 阈值处理
sigma = median(abs(coeffs)) / 0.6745; % 估计噪声标准差
threshold = sigma * sqrt(2 * log(length(noisy_signal))); % 阈值
% 软阈值处理
shrinkage = wthresh(coeffs, 's', threshold);
% 重构信号
filtered_signal_8 = waverec(shrinkage, lengths, waveletName);

% 小波变换去噪
% 选择小波基和分解级数
waveletName = 'db4'; % 小波基
level = 5; % 分解级数
% 进行小波分解
[coeffs, lengths] = wavedec(orignal_y, level, waveletName);
% 阈值处理
sigma = median(abs(coeffs)) / 0.6745; % 估计噪声标准差
threshold = sigma * sqrt(2 * log(length(orignal_y))); % 阈值
% 软阈值处理
shrinkage = wthresh(coeffs, 's', threshold);
% 重构信号
filtered_signal = waverec(shrinkage, lengths, waveletName);

% 绘图1
figure;
subplot(3,1,1);
plot(orignal_t, orignal_y);
title('Orignal PD signal');
%xlabel('time(s)');
ylabel('Amplitude(V)');
grid on;

subplot(3,1,2);
plot(orignal_t, noise);
title('White noise');
%xlabel('time(s)');
ylabel('Amplitude(V)');
ylim([-max(abs(noise)) max(abs(noise))]); % 设置y轴范围以更好地显示噪声
grid on;

subplot(3,1,3);
plot(orignal_t, noisy_signal);
title('Noisy PD signals');
xlabel('time (s)');
ylabel('Amplitude(V)');
grid on;

%绘图2
figure;

subplot(8,1,1);
plot(orignal_t, orignal_y);
title('Orignal PD signal');
% %xlabel('time (s)');
% ylabel('Amplitude(V)');
grid on;

subplot(8,1,2);
plot(orignal_t, filtered_signal_1);%中值滤波器MF
title('Median filter');
%xlabel('time (s)');
% ylabel('Amplitude(V)');
grid on;

subplot(8,1,3);
plot(orignal_t, filtered_signal_5);%简单平均滤波SAF
title('Simple average filtering');
%xlabel('time (s)');
% ylabel('Amplitude(V)');

subplot(8,1,4);
plot(orignal_t, filtered_signal_3);%移动平均滤波MAF
title('Moving average filter');
%xlabel('time (s)');
% ylabel('Amplitude(V)');

subplot(8,1,5);
plot(orignal_t, filtered_signal_2);%4阶巴特沃斯低通滤波器BLF
title('Butterworth low-pass filter');
%xlabel('time (s)');
% ylabel('Amplitude(V)');

subplot(8,1,6);
plot(orignal_t, filtered_signal_4);%FIR低通滤波器FIRLP
title('FIR low-pass filter');
%xlabel('time (s)');
% ylabel('Amplitude(V)');

subplot(8,1,7);
plot(orignal_t, filtered_signal_8);%小波变换去噪2 WT2
title('Wavelet transform soft threshold');
%xlabel('time (s)');
% ylabel('Amplitude(V)');

subplot(8,1,8);
plot(orignal_t, filtered_signal_7);%小波变换去噪1 WT1
title('Wavelet transform hard threshold');
xlabel('time (s)');
ylabel('Amplitude(V)');

figure;
subplot(2,1,2);
% 在同一个图中绘制多个函数，使用不同的颜色
plot(orignal_t,orignal_y,'b',orignal_t,filtered_signal_2,'y',orignal_t,filtered_signal_4,'r',orignal_t, filtered_signal_7, 'c',orignal_t, filtered_signal_8, 'k'); % 'r', 'g', 'b' 分别代表红色、绿色和蓝色
legend('PD signal',' BLF','FIRLP',  'WT1', 'WT2'); % 添加图例
title('Comparison between different methods 1');
xlabel('time (s)');
ylabel('Amplitude(V)');
subplot(2,1,1);
% 在同一个图中绘制多个函数，使用不同的颜色
plot(orignal_t,orignal_y,'b',orignal_t, filtered_signal_1, 'y', orignal_t, filtered_signal_3, 'r',orignal_t, filtered_signal_5, 'c'); % 'r', 'g', 'b' 分别代表红色、绿色和蓝色
legend('PD signal', 'MF ','MAF', 'SAF'); % 添加图例
title('Comparison between different methods 2');
xlabel('time (s)');
ylabel('Amplitude(V)');


