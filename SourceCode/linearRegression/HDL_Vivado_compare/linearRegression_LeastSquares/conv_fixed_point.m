function tsum = conv_fixed_point(data_in, total_word, fraction)
    bin_data = dec2bin(abs(data_in),total_word);
    bin_data_array = mod(bin_data/ 2^0, 2);
    integer_word = total_word - fraction;
    integer_word_list = zeros(1,total_word);
    fraction_list = zeros(1,fraction);
    if bin_data_array(1) == 1
        for k = 0:integer_word-2 
            integer_word_list(1,k+1) = double((1-bin_data_array(integer_word-k)))*double((2^k));
        end   
        for k = 1:fraction
            fraction_list(1,k+1) = double((1-bin_data_array(integer_word+k)))*double((2^-k));
        end
        integer_sum = sum(integer_word_list);
        decimal_sum = sum(fraction_list);
        tsum = - double((integer_sum+decimal_sum));
    else
        for k = 0:integer_word-2
            integer_word_list(1,k+1) = double((bin_data_array(integer_word-k)))*double(((2^k)));
        end   
    
        for k = 1:fraction
            fraction_list(1,k+1) = double(bin_data_array(integer_word+k))*double((2^-k));
        end
        integer_sum = sum(integer_word_list);
        decimal_sum = sum(fraction_list);
        tsum = double(integer_sum+decimal_sum);
    end 
end