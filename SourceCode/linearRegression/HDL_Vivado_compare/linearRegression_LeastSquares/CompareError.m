clc
close all
clear all

T = 3000;
% ------------------------------------------------- MATLAB
fid_Sum_x = fopen('Sum_x.dat');
Sum_x_MATLAB = fscanf(fid_Sum_x,'%x');
Sum_x_MATLAB = Sum_x_MATLAB';
fclose(fid_Sum_x);
fid_Sum_y = fopen('Sum_y.dat');
Sum_y_MATLAB = fscanf(fid_Sum_y,'%x');
Sum_y_MATLAB = Sum_y_MATLAB';
fclose(fid_Sum_y);
fid_Sum_xy = fopen('Sum_xy.dat');
Sum_xy_MATLAB = fscanf(fid_Sum_xy,'%x');
Sum_xy_MATLAB = Sum_xy_MATLAB';
fclose(fid_Sum_xy);
fid_Sum_x2 = fopen('Sum_xx.dat');
Sum_x2_MATLAB = fscanf(fid_Sum_x2,'%x');
Sum_x2_MATLAB = Sum_x2_MATLAB';
fclose(fid_Sum_x2);
for k = 1:T
    din_Sum_x  = conv_fixed_point(Sum_x_MATLAB(1,k), 14, 0);
    din_Sum_y  = conv_fixed_point(Sum_y_MATLAB(1,k), 14, 0);
    din_Sum_xy = conv_fixed_point(Sum_xy_MATLAB(1,k), 23, 0);
    din_Sum_x2 = conv_fixed_point(Sum_x2_MATLAB(1,k), 23, 0);
    [MATLAB_m, MATLAB_b] = linearRegression_LeastSquares(din_Sum_x, din_Sum_y, din_Sum_xy, din_Sum_x2);
    m_MATLAB_buf(1,k) = MATLAB_m;
	b_MATLAB_buf(1,k) = MATLAB_b;
end

% ======================================================== Vivado
m_csv = csvread('m_unsigned.csv');
b_csv = csvread('b_unsigned.csv');
for k = 1:T
    dout_m  = conv_fixed_point(m_csv(1,k), 24, 13);
    dout_b  = conv_fixed_point(b_csv(1,k), 24, 4);
    m_Vivado_buf(1,k) = dout_m;
	b_Vivado_buf(1,k) = dout_b;
end
% ------------------------------------------------- Report the result
ERROR = m_MATLAB_buf - m_Vivado_buf;

figure(1)
plot((1:T), ERROR)
xlim([1 T])
ylim([0 2])
title('MATLAB - Vivado (0)')
ylabel('Error','fontsize',8);
xlabel('Discrete time k','fontsize',8);
set(gca,'fontsize',8)
grid on 

figure(2)
plot((1:T), ERROR)
xlim([1 T])
ylim([0 0.1])
title('MATLAB - Vivado (0.1)')
ylabel('Error','fontsize',8);
xlabel('Discrete time k','fontsize',8);
set(gca,'fontsize',8)
grid on 

figure(3)
plot((1:T), ERROR)
xlim([1 T])
ylim([0 0.01])
title('MATLAB - Vivado (0.01)')
ylabel('Error','fontsize',8);
xlabel('Discrete time k','fontsize',8);
set(gca,'fontsize',8)
grid on 

figure(4)
plot((1:T), ERROR)
xlim([1 T])
ylim([0 0.001])
title('MATLAB - Vivado (0.001)')
ylabel('Error','fontsize',8);
xlabel('Discrete time k','fontsize',8);
set(gca,'fontsize',8)
grid on 