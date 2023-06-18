function [outstr] = huffman_coding_transfer2binary(instr,L)
    transfer2binary = [0 10 110 1110 11110 111110 1111110 11111110 111111110 1111111110 11111111110 111111111110 1111111111110 11111111111110 111111111111110 111111111111111
    0 2 6 14 30 62 126 254 510 1022 2046 4094 8190 16382 32766 32767];

    outstr = zeros(L ,L*2);
    for i = 1 : L
        for j = 1 : L*2
            for k = 1 : 16
                if instr(i,j) == transfer2binary(1,k)
                    outstr(i,j) = transfer2binary(2,k);
                    break;
                end
            end
        end
    end

end