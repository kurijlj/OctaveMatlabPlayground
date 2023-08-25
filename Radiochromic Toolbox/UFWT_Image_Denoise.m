function dpd = UFWT_Image_Denoise(varargin)
    % --------------------------------------------------------------------------
    %
    % Function: UFWT_Image_Denoise(varargin)
    %
    % --------------------------------------------------------------------------
    %
    % Use:
    %       -- dpd = UFWT_Image_Denoise(pd)
    %       -- dpd = UFWT_Image_Denoise(..., "PROPERTY", VALUE, ...)
    %
    % Description:
    %       Denoise the image using the undecimated wavelet transform.
    %
    % Mandatory Function Parameters:
    %       -- pd: 3D array containing the image to denoise.
    %
    % Optional Function Parameters:
    %       -- 'Threshold': string, def. 'hard'
    %                       Thresholding method used for the decomposition of
    %                       noise and signal.
    %       -- 'Wavelet':   string, def. 'spline1:1'
    %                       Wavelet used for the decomposition.
    %       -- 'Level':     integer, def. 3
    %                       Number of decomposition levels.
    %
    % Return:
    %       -- dpd: 3D array containing the denoised image.
    %
    % Example:
    %       >> dpd = UFWT_Image_Denoise(pd)
    %       >> dpd = UFWT_Image_Denoise(pd, 'Threshold', 'soft', ...
    %              'Wavelet', 'spline2:1', 'Level', 4)
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

    fname = 'UFWT_Image_Denoise';
    use_case_a = sprintf(' -- dpd = %s(pd)', fname);
    rse_case_b = sprintf(' -- dpd = %s(..., "PROPERTY", VALUE, ...)', fname);

    % Check the input parameters -----------------------------------------------
    [pos, threshold, wt, level] ...
        = parseparams( ...
                      varargin, ...
                      'Threshold', 'hard', ...
                      'Wavelet', 'spline1:1', ...
                      'Level', 3 ...
                     );

    % Check the number of mandatory parameters ---------------------------------
    if 1 ~= numel(pos)
        error( ...
              'Invalid call to %s. Correct usage is:\n%s\n%s', ...
              fname, ...
              use_case_a, ...
              use_case_b ...
             );

    end  % End of 'if 1 ~= numel(pos)'

    % Validate values supplied for the mandatory parameters --------------------
    validateattributes( ...
                       pos{1}, ...
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

    % Validate values supplied for the optional parameters ---------------------

    % Validate value supplied for the 'Threshold' parameter
    threshold = validatestring( ...
                               threshold, ...
                               {'hard', 'soft'}, ...
                               fname, ...
                               'Threshold' ...
                              );

    % Validate value supplied for the 'level' parameter
    validateattributes( ...
                       level, ...
                       {'numeric'}, ...
                       { ...
                        'scalar', ...
                        'integer', ...
                        'nonnegative', ...
                        'finite', ...
                        'nonnan', ...
                        '>', 0 ...
                       }, ...
                       fname, ...
                       'level' ...
                      );

    % Add the ltfat package to the path ----------------------------------------
    pkg load ltfat;

    % Validate value(s) supplied for the wavelet filterbank definition
    try
        wt = fwtinit(wt);

    catch err
        error('%s: %s', fname, err.message);

    end  % End of try-catch block

    % Do the computation -------------------------------------------------------

    pd = double(pos{1});

    % Estimate the noise variance
    [red_ns, green_ns, blue_ns] = UFWT_Image_Noise_Estimate(pd);
    ns = [red_ns, green_ns, blue_ns];
    clear('red_ns', 'green_ns', 'blue_ns');

    % Allocate memory for the resulting signal estimate
    dpd = zeros(size(pd));

    % Iterate over the color channels
    k = 1;
    while 3 >= k
        [A, H, V, D] = UFWT_2(pd(:, :, k), wt, level);
        if 'hard' == threshold
            V = V .* (V > ns(k) * sqrt(2 * log(numel(V))));
            H = H .* (H > ns(k) * sqrt(2 * log(numel(H))));
            D = D .* (D > ns(k) * sqrt(2 * log(numel(D))));

        else
            V = sign(V) .* max(abs(V) - ns(k) * sqrt(2 * log(numel(V))), 0);
            H = sign(H) .* max(abs(H) - ns(k) * sqrt(2 * log(numel(H))), 0);
            D = sign(D) .* max(abs(D) - ns(k) * sqrt(2 * log(numel(D))), 0);

        end  % End of 'if 'hard' == threshold'

        dpd(:, :, k) = IUFWT_2(A, H, V, D, wt, level);

        ++k;

    end  % End of 'while 3 >= k'

end  % End of function UFWT_Image_Denoise

% End of file UFWT_Image_Denoise.m
