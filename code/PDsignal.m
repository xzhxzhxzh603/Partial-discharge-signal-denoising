%PD原始信号
clc
Fn=6e7/2;
orignal_t=(0:2047)/60e6;
orignal_y=pd_pulse(orignal_t,600/60e6,'2',1/1e-6,1/0.1e-6,1e6);
plot(orignal_t,orignal_y);title('原始信号');xlabel('时间t/s');
dataTable = array2table([orignal_t' orignal_y'], 'VariableNames', {'时间', 'PD信号幅值'});
writetable(dataTable, 'orignalPD.xlsx');