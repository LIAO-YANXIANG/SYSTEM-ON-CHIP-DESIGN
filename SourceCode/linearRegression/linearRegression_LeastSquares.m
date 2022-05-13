function [m, b] = linearRegression_LeastSquares (Sum_x, Sum_y, Sum_xy, Sum_xx)
    
    % stage 1
    buf11 = 16*Sum_xy;
    buf12 = Sum_x*Sum_y;
    buf13 = 16*Sum_xx;
    buf14 = Sum_x*Sum_x;
    
    % stage 2
    buf21 = buf11 - buf12;
    buf22 = buf13 - buf14;
    
    % stage 3 , calculate m
    m = buf21 / buf22 ;
    
    % stage 4
    buf31 = m*Sum_x;

    % stage 5
    buf41 = Sum_y - buf31;

    % stage 6
    b = buf41 / 16; 

end
