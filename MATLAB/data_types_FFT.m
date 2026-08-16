function T = data_types_FFT(dt)
%UNTITLED3 Summary of this function goes here
%   x: input
%   w: twidle factor
%   s1: stage1 "o/p from first stage butterfly"
%   s2: stage2 "o/p from second stage butterfly"
%   s3: stage3 "o/p from third stage butterfly"
%   s4: stage4 "o/p from last stage butterfly"
%   y: output after ordering

    F = fimath( ...
    'RoundingMethod', 'Floor', ...
    'OverflowAction', 'Wrap', ...
    'ProductMode', 'FullPrecision', ...
    'SumMode', 'FullPrecision');

    switch dt

        case 'double'
        
            T.x  = double([]);
            T.w  = double([]);
            T.s0 = double([]);
            T.s1 = double([]);
            T.s2 = double([]);
            T.s3 = double([]);
            T.s4 = double([]);
            T.y  = double([]);
        
        case 'single'

            T.x  = single([]);
            T.w  = single([]);
            T.s0 = single([]);
            T.s1 = single([]);
            T.s2 = single([]);
            T.s3 = single([]);
            T.s4 = single([]);
            T.y  = single([]);

        case 'fxt_pt_16'

            T.x  = fi([], 1, 3+13, 13, 'fimath', F);
            T.w  = fi([], 1, 2+14, 14, 'fimath', F);
            T.s0 = fi([], 1, 3+13, 13, 'fimath', F);
            T.s1 = fi([], 1, 4+12, 12, 'fimath', F);
            T.s2 = fi([], 1, 4+12, 12, 'fimath', F);
            T.s3 = fi([], 1, 4+12, 12, 'fimath', F);
            T.s4 = fi([], 1, 5+11, 11, 'fimath', F);
            T.y  = fi([], 1, 5+11, 11, 'fimath', F);

        case 'fxt_pt_12'

            T.x  = fi([], 1, 4+8, 8, 'fimath', F);
            T.w  = fi([], 1, 2+10, 10, 'fimath', F);
            T.s0 = fi([], 1, 4+8, 8, 'fimath', F);
            T.s1 = fi([], 1, 5+7, 7, 'fimath', F);
            T.s2 = fi([], 1, 5+7, 7, 'fimath', F);
            T.s3 = fi([], 1, 5+7, 7, 'fimath', F);
            T.s4 = fi([], 1, 6+6, 6, 'fimath', F);
            T.y  = fi([], 1, 6+6, 6, 'fimath', F);

    end

       

end