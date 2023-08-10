%% -----------------------------------------------------------------------------
%%
%% Script: Test_Fov_Elements.m
%%
%% -----------------------------------------------------------------------------
%
%% Use:
%       - Test_Fov_Elements
%
%% Description:
%       Test script for the FoV elements routines.
%
%% Examples:
%       >> Test_Fov_Elements
%
%% (C) Copyright 2023 Ljubomir Kurij
%
%% -----------------------------------------------------------------------------

% Test Roi_2_Bw ----------------------------------------------------------------
W = 20;
H = 20;
FOV = Make_Dummy_Fov(W, H);
roi           = [5, 5, 10, 10];
roi(end + 1, :) = [5, 5, 20, 20];
roi(end + 1, :) = [5, 5, 30, 30];
roi(end + 1, :) = [10, 10, 10, 10];
roi(end + 1, :) = [10, 10, 20, 20];
roi(end + 1, :) = [10, 10, 30, 30];
roi(end + 1, :) = [15, 15, 10, 10];
roi(end + 1, :) = [15, 15, 20, 20];
roi(end + 1, :) = [15, 15, 30, 30];
roi(end + 1, :) = [20, 20, 10, 10];
roi(end + 1, :) = [20, 20, 20, 20];
roi(end + 1, :) = [20, 20, 30, 30];

i = 1;
while size(roi, 1) >= i
    mask = zeros(size(FOV));
    mask( ...
         roi(i, 2):min(roi(i, 2) + roi(i, 4) - 1, H), ...
         roi(i, 1):min(roi(i, 1) + roi(i, 3) - 1, W) ...
        ) = 1;
    TBW = FOV .* mask;
    BW  = FOV .* Roi_2_Bw(W, H, roi(i, 1), roi(i, 2), roi(i, 3), roi(i, 4));
    assert(TBW == BW, sprintf("Test %d failed", i));

    i += 1;

end  % End of while (size(roi, 1) >= i)

printf("Test Roi_2_Bw .. PASSED\n");
