function [y,s1,s2,s3,s4] = DIF_FFT(Vec,T) %#codegen 
% FFTDIT  Radix-2 Decimation-In-Time FFT (floating-point structural model)
%
%   y = fftDIT(x)
%
%   INPUT:
%       x  - input vector, length N (N must be a power of 2),
%            in NATURAL order (no pre-reordering needed by the caller)
%
%   OUTPUT:
%       y  - N-point DFT of x, in natural (non-bit-reversed) order
%
%   This function internally bit-reverses the input before running the
%   butterfly stages (standard DIT requirement: input must be visited
%   in bit-reversed order for the in-place butterfly recursion to
%   produce natural-order output).

    

    N = length(Vec);
    s0 = cast(Vec, 'like', T.s0);

    %% -------------------------
    % Stage 1
    % butterfly size = 16
    %% -------------------------
    s1 = cast(s0, 'like', T.s1);
    
    for block = 1:16:N
        
        for j = 0:7
            
            top = block + j;
            bot = top + 8;

            W = cast(exp(-1j*2*pi*(0:7)/16), 'like', T.w);

            a = cast(s0(top), 'like', T.s0);
            b = cast(s0(bot), 'like', T.s0);
        
            sum_val = cast(a + b, 'like', T.s1); 
            diff_val = cast(a - b, 'like', T.s1);
            
            s1(top)   = cast(sum_val, 'like', T.s1);
            s1(bot) = cast(diff_val * W(j+1), 'like', T.s1);
        
        end

    end
    
    %% -------------------------
    % Stage 2
    % butterfly size = 8
    %% -------------------------
    s2 = cast(s1, 'like', T.s2);
    
    W = cast(exp(-1j*2*pi*(0:3)/8), 'like', T.w);
    
    for block = 1:8:N
    
        for j = 0:3
    
            top = block + j;
            bot = top + 4;
    
            a = cast(s1(top), 'like', T.s1);
            b = cast(s1(bot), 'like', T.s1);
    
            sum_val = cast(a + b, 'like', T.s2); 
            diff_val = cast(a - b, 'like', T.s2);
            
            s2(top) = cast(sum_val, 'like', T.s2);
            s2(bot) = cast(diff_val * W(j+1), 'like', T.s2);
    
        end
    end
    
    %% -------------------------
    % Stage 3
    % butterfly size = 4
    %% -------------------------
    s3 = cast(s2, 'like', T.s3);
    
    W = cast(exp(-1j*2*pi*(0:1)/4), 'like', T.w);
    
    for block = 1:4:N
    
        for j = 0:1
    
            top = block + j;
            bot = top + 2;
    
            a = cast(s2(top), 'like', T.s2);
            b = cast(s2(bot), 'like', T.s2);
    
            sum_val = cast(a + b, 'like', T.s3); 
            diff_val = cast(a - b, 'like', T.s3);
            
            s3(top) = cast(sum_val, 'like', T.s3);
            s3(bot) = cast(diff_val * W(j+1), 'like', T.s3);
    
        end
    end
    
    %% -------------------------
    % Stage 4
    % butterfly size = 2
    %% -------------------------
    s4 = cast(s3, 'like', T.s4);
    
    W = cast(1, 'like', T.w);
    
    for block = 1:2:N
    
        top = block;
        bot = top + 1;
    
        a = cast(s3(top), 'like', T.s3);
        b = cast(s3(bot), 'like', T.s3);
    
        s4(top) = cast(a + W*b, 'like', T.s4);
        s4(bot) = cast(a - W*b, 'like', T.s4);
    
    end


    % the re-ordering part
    indecieds = 0:length(s4)-1;
    indx_bin = dec2bin(indecieds);

    %define xr
    xr = cast(s4, 'like', T.s4);
    
    for i = 1: length(s4)
        temp = indx_bin(i,:);
        xr(i) = cast(s4(bin2dec(temp(end:-1:1))+1), 'like', T.s4);
    end

    % Output
    y = cast(xr, 'like', T.y);end