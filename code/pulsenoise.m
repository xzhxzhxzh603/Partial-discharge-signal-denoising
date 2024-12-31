%生成impulse PD信号
A=xlsread('pulsePD.xlsx');%wxcel导入数据
t=A(3:2000,1);%时间
orignal_pd_y=A(3:2000,2);%信号

% 4阶巴特沃斯低通滤波器
Fs = 1500; % 假设采样频率为10000Hz（根据实际情况调整）
Fc = 110; % 低通滤波器的截止频率（根据实际情况调整）
[b, a] = butter(4, Fc / (Fs / 2), 'low'); % 设计4阶巴特沃斯低通滤波器
filtered_signal_1 = filtfilt(b, a, orignal_pd_y);



% 移动平均滤波
window_size = 200; % 窗口大小，可以根据需要调整 可以修改 20 30 50 
moving_avg_filter = ones(1, window_size) / window_size;
filtered_signal_2 = conv(orignal_pd_y, moving_avg_filter, 'same');



% 设计FIR低通滤波器
Fs = 10000; % 假设采样频率为10000Hz（根据实际情况调整）
Fc = 200; % 低通滤波器的截止频率（根据实际情况调整）
N = 100; % 滤波器的阶数（可以根据需要调整）
[b, a] = fir1(N, Fc / (Fs / 2), 'low'); % 设计FIR低通滤波器
filtered_signal_3 = filtfilt(b, 1, orignal_pd_y); % 使用零相位滤波来避免相位失真



% 应用简单平均滤波
filter_window = 5; % 滤波器窗口大小（必须是奇数）
filtered_signal_4 = conv(orignal_pd_y, ones(1, filter_window) / filter_window, 'same');



% 小波变换去噪
% 选择小波基和分解级数
waveletName = 'db4'; % 小波基
level = 5; % 分解级数
% 进行小波分解
[coeffs, lengths] = wavedec(orignal_pd_y, level, waveletName);
% 阈值处理
sigma = median(abs(coeffs)) / 0.6745; % 估计噪声标准差
threshold = sigma * sqrt(2 * log(length(orignal_pd_y))); % 阈值
% 软阈值处理
shrinkage = wthresh(coeffs, 's', threshold);
% 重构信号
filtered_signal_5 = waverec(shrinkage, lengths, waveletName);



% 小波变换去噪
% 选择小波基和分解级数
waveletName = 'db4'; % 小波基
level = 5; % 分解级数
% 进行小波分解
[coeffs, lengths] = wavedec(orignal_pd_y, level, waveletName);
% 阈值处理
sigma = median(abs(coeffs)) / 0.6745; % 估计噪声标准差
threshold = sigma * sqrt(2 * log(length(orignal_pd_y))); % 阈值
% 硬阈值处理
shrinkage = wthresh(coeffs, 'h', threshold);
% 重构信号
filtered_signal_6 = waverec(shrinkage, lengths, waveletName);

%原始信号 
Fn=6e7/2; 
orignal_t=(0:2047)/60e6;
orignal_y=pd_pulse(orignal_t,600/60e6,'2',1/1e-6,1/0.1e-6,1e6);
subplot(7,1,1)
plot(orignal_t,orignal_y)
title('Orignal PD signal');
subplot(7,1,2)
plot(t,filtered_signal_2)
title('Moving average filter');
subplot(7,1,3)
plot(t,filtered_signal_3)
title('FIR low-pass filter');
subplot(7,1,4)
plot(t,filtered_signal_6)
ylabel('Amplitude(V)');
title('Wavelet transform hard threshold');
subplot(7,1,5)
plot(t,filtered_signal_5)
title('Wavelet transform soft threshold');
subplot(7,1,6)
plot(t,filtered_signal_4)
title('Simple average filtering');
subplot(7,1,7)
plot(t,filtered_signal_1)
title('Butterworth low-pass filter');
xlabel('Time(s)');
