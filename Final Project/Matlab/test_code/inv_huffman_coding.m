function [outstr] = inv_huffman_coding(instr,L)
    huffman_tree = [0 15 1 14 2 13 3 4 12 5 11 6 10 7 9 8;
                      0 10 110 1110 11110 111110 1111110 11111110 111111110 1111111110 11111111110 111111111110 1111111111110 11111111111110 111111111111110 111111111111111];
    outstr = zeros(L ,L*2);
    for i = 1 : L
        for j = 1 : L*2
            for k = 1 : 16
                if instr(i,j) == huffman_tree(2,k)
                    outstr(i,j) = huffman_tree(1,k);
                    break;
                end
            end
        end
    end


end