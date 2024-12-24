% 白噪声去噪 应用简单平均滤波
%原始信号
clc
Fn=6e7/2;
orignal_t=(0:2047)/60e6;
orignal_y=pd_pulse(orignal_t,600/60e6,'2',1/1e-6,1/0.1e-6,1e6);
%plot(t,x);grid;ylabel('幅值v')

% 添加白噪声
noise_level = 0.2; % 可以根据需要调整噪声水平
noise = noise_level * randn(size(orignal_y));
noisy_signal = orignal_y + noise;

% 应用简单平均滤波
filter_window = 5; % 滤波器窗口大小（必须是奇数）
filtered_signal = conv(noisy_signal, ones(1, filter_window) / filter_window, 'same');

% 绘图
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
title('简单平均滤波后的信号');
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