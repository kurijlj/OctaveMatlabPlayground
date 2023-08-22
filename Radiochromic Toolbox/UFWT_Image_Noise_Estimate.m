function [red_ns, green_ns, blue_ns] = UFWT_Image_Noise_Estimate(pd)
    % --------------------------------------------------------------------------
    %
    % Function: UFWT_Image_Noise_Estimate(pd)
    %
    % --------------------------------------------------------------------------
    %
    % Use:
    %       -- [red_ns, green_ns, blue_ns] = UFWT_Image_Noise_Estimate(pd)
    %
    % Description:
    %        Estimate the noise in the red, green and blue channels of an image
    %        using the undecimated forward wavelet transform (UFWT).
    %
    % Function parameters:
    %        -- pd: a 3D array containing the pixel data of an image.
    %
    % Return:
    %        -- red_ns: the estimated noise standard deviation in the red
    %                   color channel of the image.
    %        -- green_ns: the estimated noise standard deviation in the green
    %                     color channel of the image.
    %        -- blue_ns: the estimated noise standard deviation in the blue
    %                    color channel of the image.
    %
    % Example:
    %        -- [red_ns, green_ns, blue_ns] = UFWT_Image_Noise_Estimate(pd)
    %
    % (C) Copyright 2023 Ljubomir Kurij <ljubomir_kurij@protonmail.com>
    % This file is part of Radiochromic Toolbox version 0.1.0
    %
    % This program is free software: you can redistribute it and/or modify
    % it under the terms of the GNU General Public License as published by
    % the Free Software Foundation, either version 3 of the License, or
    % (at your option) any later version.
    %
    % This program is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU General Public License for more details.
    %
    % You should have received a copy of the GNU General Public License
    % along with this program.  If not, see <http://www.gnu.org/licenses/>.
    %
    % --------------------------------------------------------------------------

    fname = 'UFWT_Image_Noise_Estimate';
    use_case_a = sprintf(' -- [red_ns, green_ns, blue_ns] = %s(pd)', fname);

    % Check input parameters ---------------------------------------------------
    if 1 ~= nargin
        error('Invalid call to %s. Correct usage is: \n%s', fname, use_case_a);

    end  % End of if 1 ~= nargin

    % Check if the input parameter is a 3D array -------------------------------
    validateattributes( ...
                       pd, ...
                       {'numeric'}, ...
                       { ...
                        '3d', ...
                        'nonempty', ...
                        'finite', ...
                        'nonnan', ...
                        'positive' ...
                       }, ...
                       fname, ...
                       'pd', ...
                       1 ...
                    );

    % Check the number of supplied output arguments ----------------------------
    if 3 ~= nargout
        error('Invalid call to %s. Correct usage is: \n%s', fname, use_case_a);

    end  % End of if 3 ~= nargout

    % Convert the pixel data to double precision -------------------------------
    pd = double(pd);

    % Do the computation -------------------------------------------------------
    sd = zeros(1, 3);
    i = 1;
    while 4 > i
        [A, V, H, D] = UFWT_2(pd(:, :, i), 'syn:spline161:1', 1);
        sd(i) = median( ...
                       median( ...
                              abs( ...
                                  pd(:, :, i) ...
                                  - A ...
                                  - median(median(pd(:, :, i) - A)) ...
                                 ) ...
                             ) ...
                      ) / 0.6745;

        i = i + 1;

    end  % End of while 4 > i

    [red_ns, green_ns, blue_ns] = deal(sd(1), sd(2), sd(3));

end  % End of function UFWT_Image_Noise_Estimate

% End of file UFWT_Image_Noise_Estimate.m