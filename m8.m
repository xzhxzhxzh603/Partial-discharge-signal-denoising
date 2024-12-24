% 白噪声去噪 小波变换去噪 软阈值处理
clear all;
clc;

% 原始信号参数
Fn = 6e7/2; % 采样频率
orignal_t = (0:2047)/60e6; % 时间向量
orignal_y = pd_pulse(orignal_t, 600/60e6, '2', 1/1e-6, 1/0.1e-6, 1e6); % 原始信号

% 添加白噪声
noise_level = 0.2; % 噪声水平
noise = noise_level * randn(size(orignal_y)); % 生成白噪声
noisy_signal = orignal_y + noise; % 添加噪声后的信号

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
filtered_signal = waverec(shrinkage, lengths, waveletName);

% 绘制结果
figure;

subplot(4,1,1);
plot(orignal_t, orignal_y);
title('原始信号');
xlabel('时间 (s)');
ylabel('幅值');
grid on;

subplot(4,1,2);
plot(orignal_t, noise);
title('噪声信号');
xlabel('时间 (s)');
ylabel('幅值');
ylim([-max(abs(noise)) max(abs(noise))]); % 设置y轴范围以更好地显示噪声
grid on;

subplot(4,1,3);
plot(orignal_t, noisy_signal);
title('原始信号 + 噪声信号');
xlabel('时间 (s)');
ylabel('幅值');
grid on;

subplot(4,1,4);
plot(orignal_t, filtered_signal);
title('中值滤波后的信号');
xlabel('时间 (s)');
ylabel('幅值');
grid on;

% 计算滤波性能指标
% 计算去噪后信噪比 (SNR)
original_signal_power = mean(orignal_y.^2);
noise_after_filtering_power = mean((filtered_signal - orignal_y).^2);
snr_db = 10 * log10(original_signal_power / noise_after_filtering_power);
disp(['Signal Noise Radio (SNR): ', num2str(snr_db), ' dB']);
% 计算MSE
mse_value = mean((orignal_y - noisy_signal).^2);
disp(['Mean Squared Error (MSE): ', num2str(mse_value)]);
% 计算NMSE
original_signal_power = mean(orignal_y.^2);
nmse_value = mse_value / original_signal_power;
disp(['Normalized Mean Squared Error (NMSE): ', num2str(nmse_value)]);