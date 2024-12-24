% 白噪声去噪 FIR低通滤波器

%原始信号
clc
Fn=6e7/2;
orignal_t=(0:2047)/60e6;
orignal_y=pd_pulse(orignal_t,600/60e6,'2',1/1e-6,1/0.1e-6,1e6);

% 添加白噪声
noise_level = 0.2; % 可以根据需要调整噪声水平
noise = noise_level * randn(size(orignal_y));
noisy_signal = orignal_y + noise;

% 设计FIR低通滤波器
Fs = 10000; % 假设采样频率为10000Hz（根据实际情况调整）
Fc = 500; % 低通滤波器的截止频率（根据实际情况调整）
N = 100; % 滤波器的阶数（可以根据需要调整）
[b, a] = fir1(N, Fc / (Fs / 2), 'low'); % 设计FIR低通滤波器

% 应用滤波器
filtered_signal = filtfilt(b, 1, noisy_signal); % 使用零相位滤波来避免相位失真

% 绘制图形
figure;
subplot(4,1,1);
plot(orignal_t, orignal_y);
title('原始信号');
xlabel('时间 (s)');
ylabel('幅度');

subplot(4,1,2);
plot(orignal_t, noise);
title('噪声信号');
xlabel('时间 (s)');
ylabel('幅度');
ylim([-max(abs(noise)) max(abs(noise))]); % 设置y轴范围以更好地显示噪声

subplot(4,1,3);
plot(orignal_t, noisy_signal);
title('原始信号 + 噪声信号');
xlabel('时间 (s)');
ylabel('幅度');

subplot(4,1,4);
plot(orignal_t, filtered_signal);
title('滤波后的信号');
xlabel('时间 (s)');
ylabel('幅度');


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
% % 滤波前后信号的相关性
% correlation = corr(orignal_y, filtered_signal);
% fprintf('滤波前后信号的相关性: %f\n', correlation);