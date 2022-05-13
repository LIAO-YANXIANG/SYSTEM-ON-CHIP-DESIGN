clc
close all
clear all

% n=𝑛𝑢𝑚𝑏𝑒𝑟 𝑜𝑓 𝑡ℎ𝑒 𝑣𝑎𝑙𝑢𝑒𝑠  ==> 16
% x1_list = ;
% y1_list = ;
% x1_list = [1 2 3 4  5  6  7  8  9 10 11 12 13 14 20 21;...
%            50 100 80 44  57  53  40  44  97 20 66 70 80 40 30 11;...
%            280 231 77 31  87  64  40  50  60 74 14 2 90 120 75 394;...
%            88 11 50 47  74  17  300  400  304 240 70 50 80 40 70 11;...
%            355 365 377 378 381 349 310 333 399 370 335 337 385 395 391 348];
% 
% 
% y1_list = [1 3 6 9 11 13 16 17 23 21 22 23 25 27 29 31; ...
%            88 11 50 47  74  17  300  400  304 240 70 50 80 40 70 11;...
%            50 100 80 44  57  53  40  44  97 20 66 70 80 40 30 11;...
%            280 231 77 31  87  64  40  50  60 74 14 2 90 120 75 394;...
%            348 391 395 385 337 335 370 339 333 310 349 381 378 377 365 355];

for i=1:3000
    x1_list = randi([300 400], 1, 16);
    y1_list = randi([200 400], 1, 16);
    % ===================================================================================== 
    x11  = x1_list(1);  y11  = y1_list(1); xy11 = x11*y11; xx11 = x11*x11;
    x12  = x1_list(2);  y12  = y1_list(2); xy12 = x12*y12; xx12 = x12*x12;
    x13  = x1_list(3);  y13  = y1_list(3); xy13 = x13*y13; xx13 = x13*x13;
    x14  = x1_list(4);  y14  = y1_list(4); xy14 = x14*y14; xx14 = x14*x14;
    x15  = x1_list(5);  y15  = y1_list(5); xy15 = x15*y15; xx15 = x15*x15;
    x16  = x1_list(6);  y16  = y1_list(6); xy16 = x16*y16; xx16 = x16*x16;
    x17  = x1_list(7);  y17  = y1_list(7); xy17 = x17*y17; xx17 = x17*x17;
    x18  = x1_list(8);  y18  = y1_list(8); xy18 = x18*y18; xx18 = x18*x18;
    x19  = x1_list(9);  y19  = y1_list(9); xy19 = x19*y19; xx19 = x19*x19;
    x110 = x1_list(10); y110 = y1_list(10); xy110 = x110*y110; xx110 = x110*x110;
    x111 = x1_list(11); y111 = y1_list(11); xy111 = x111*y111; xx111 = x111*x111;
    x112 = x1_list(12); y112 = y1_list(12); xy112 = x112*y112; xx112 = x112*x112;
    x113 = x1_list(13); y113 = y1_list(13); xy113 = x113*y113; xx113 = x113*x113;
    x114 = x1_list(14); y114 = y1_list(14); xy114 = x114*y114; xx114 = x114*x114;
    x115 = x1_list(15); y115 = y1_list(15); xy115 = x115*y115; xx115 = x115*x115;
    x116 = x1_list(16); y116 = y1_list(16); xy116 = x116*y116; xx116 = x116*x116;
    
    % ------------------------ Adder tree
    Sum_x1  = AdderTree_16(x11,x12,x13,x14,x15,x16,x17,x18,x19,x110,x111,x112,x13,x14,x15,x16);
    Sum_y1  = AdderTree_16(y11,y12,y13,y14,y15,y16,y17,y18,y19,y110,y111,y112,y13,y14,y15,y16);
    Sum_xy1 = AdderTree_16(xy11,xy12,xy13,xy14,xy15,xy16,xy17,xy18,xy19,xy110,xy111,xy112,xy113,xy114,xy115,xy116);
    Sum_xx1 = AdderTree_16(xx11,xx12,xx13,xx14,xx15,xx16,xx17,xx18,xx19,xx110,xx111,xx112,xx113,xx114,xx115,xx116);
    % ------------------------ linearRegression_LeastSquares_1
    [m1, b1] = linearRegression_LeastSquares(Sum_x1, Sum_y1, Sum_xy1, Sum_xx1);
    
    x1_new_list = [x11,x12,x13,x14,x15,x16,x17,x18,x19,x110,x111,x112,x13,x14,x15,x16];
    y1_new_list = [y11,y12,y13,y14,y15,y16,y17,y18,y19,y110,y111,y112,y13,y14,y15,y16];
    % ===================================================================================== 
end

figure('Name','linearRegression');
hold on; % retains plots in the current axes so that new plots added to the axes do not delete existing plots
%set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

plot(x1_new_list, y1_new_list, 'k+', 'LineWidth', 3, 'MarkerSize', 1);
plot(x1_new_list, m1*x1_new_list+b1, '--g', 'LineWidth', 5);

grid on;
xlabel('X axis', 'FontSize', 10);
ylabel('Y axis', 'FontSize', 10);



