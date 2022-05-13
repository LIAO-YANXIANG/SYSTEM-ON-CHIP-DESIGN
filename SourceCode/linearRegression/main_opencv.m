clc
close all
clear all
%------------------------------------------------------------------------------
% read image
%[img, map] = imread("/GSLAB/FPGA_linearRegression/N04-TestReport/test_image.jpg");
%img_rgb = ind2rgb(img, map);
img_rgb = imread("/GSLAB/FPGA_linearRegression/N04-TestReport/test_image.jpg");
img_gray  = img_rgb(:,:,1)*0.2989+ img_rgb(:,:,2)*0.5870+ img_rgb(:,:,3)*0.1140;
[height,width] = size(img_gray);
height_2 = height/2; width_2  = width/2;

%------------------------------------------------------------------------------
% calculate sobel
sobel = zeros(height, width); 
C = double(img_gray);
for i=1:size(C,1)-2
    for j=1:size(C,2)-2
        %Sobel mask for x-direction:
        Gx=((2*C(i+2,j+1)+C(i+2,j)+C(i+2,j+2))-(2*C(i,j+1)+C(i,j)+C(i,j+2)));
        %Sobel mask for y-direction:
        Gy=((2*C(i+1,j+2)+C(i,j+2)+C(i+2,j+2))-(2*C(i+1,j)+C(i,j)+C(i+2,j)));
        %The gradient of the image
        %B(i,j)=abs(Gx)+abs(Gy);
        sobel(i,j)=sqrt(Gx.^2+Gy.^2);
    end
end

figure('Name','image');
subplot(1,3,1),imshow(img_rgb),title('img_rgb');
subplot(1,3,2),imshow(img_gray),title('img_gray');
subplot(1,3,3),imshow(sobel),title('sobel');
%------------------------------------------------------------------------------
% Divided into four parts ___ 1

% Divided into four parts ___ 2
x2_list = [];
y2_list = [];
for y = 1:height_2-1
	for x = width_2:width-1
        if (sobel(x,y)~=0)
            x2_list = [x2_list; x];
            y2_list = [y2_list; y];
        end
    end
end
x2_list = transpose(x2_list);y2_list = transpose(y2_list);

% Divided into four parts ___ 3
x3_list = [];
y3_list = [];
for y = height_2:height-1
	for x = 1:width_2-1
        if (sobel(x,y)~=0)
            x3_list = [x3_list; x];
            y3_list = [y3_list; y];
        end
    end
end
x3_list = transpose(x3_list);y3_list = transpose(y3_list);


% Divided into four parts ___ 4
x4_list = [];
y4_list = [];
for y = height_2:height-1
	for x = width_2:width-1
        if (sobel(x,y)~=0)
            x4_list = [x4_list; x];
            y4_list = [y4_list; y];
        end
    end
end
x4_list = transpose(x4_list);y4_list = transpose(y4_list);

% ===================================================================================== n = 16
x1_list = [1 2 3 4  5  6  7  8  9 10 11 12 13 14 20 21];
y1_list = [1 3 6 9 11 13 16 17 23 21 22 23 25 27 29 31];
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
[m1, b1] = linearRegression_LeastSquares_1(Sum_x1, Sum_y1, Sum_xy1, Sum_xx1);

x1_new_list = [x11,x12,x13,x14,x15,x16,x17,x18,x19,x110,x111,x112,x13,x14,x15,x16];
y1_new_list = [y11,y12,y13,y14,y15,y16,y17,y18,y19,y110,y111,y112,y13,y14,y15,y16];

% ===================================================================================== 
n = 50;
% for i=1:length(x2_list)
for i=1:n
    rand_Pos = randperm(length(x2_list),1);
    [m2, b2] = linearRegression_LeastSquares_2(x2_list(rand_Pos), y2_list(rand_Pos));
end
%for i=1:length(x3_list)
for i=1:n
    rand_Pos = randperm(length(x3_list),1);
    [m3, b3] = linearRegression_LeastSquares_3(x3_list(rand_Pos), y3_list(rand_Pos));
end
%for i=1:length(x4_list)
for i=1:n
    rand_Pos = randperm(length(x4_list),1);
    [m4, b4] = linearRegression_LeastSquares_4(x4_list(rand_Pos), y4_list(rand_Pos));
end

figure('Name','linearRegression');
hold on; % retains plots in the current axes so that new plots added to the axes do not delete existing plots
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

plot(x1_list, y1_list, 'k+', 'LineWidth', 3, 'MarkerSize', 1);
plot(x1_list, m1*x1_list+b1, '--g', 'LineWidth', 5);

%plot(x2_new_list, y2_new_list, 'k+', 'LineWidth', 3, 'MarkerSize', 1);
%plot(x2_new_list, m2*x2_new_list+b2, '--g', 'LineWidth', 5);

%plot(x3_new_list, y3_new_list, 'k+', 'LineWidth', 3, 'MarkerSize', 1);
%plot(x3_new_list, m3*x3_new_list+b3, '--g', 'LineWidth', 5);


%plot(x4_new_list, y4_new_list, 'k+', 'LineWidth', 3, 'MarkerSize', 1);
%plot(x4_new_list, m4*x4_new_list+b4, '--g', 'LineWidth', 5);

grid on;
xlabel('X axis', 'FontSize', 10);
ylabel('Y axis', 'FontSize', 10);



