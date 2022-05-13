function Sum = AdderTree_16(in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15)
    
    % stage 1
    buf11 =  in0 + in1;
    buf12 =  in2 + in3;
    buf13 =  in4 + in5;
    buf14 =  in6 + in7;
    buf15 =  in8 + in9;
    buf16 =  in10 + in11;
    buf17 =  in12 + in13;
    buf18 =  in14 + in15;

    % stage 2
    buf21 = buf11 + buf12;
    buf22 = buf13 + buf14;
    buf23 = buf15 + buf16;
    buf24 = buf17 + buf18;
    
    % stage3
    buf31 = buf21 + buf22;
    buf32 = buf23 + buf24;

    % stage4
    Sum = buf31 + buf32;

end
