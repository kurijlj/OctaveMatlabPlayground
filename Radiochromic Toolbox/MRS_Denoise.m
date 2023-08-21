function [dpd, info] = MRS_Denoise(pd, wt, fbi, scaling='sqrt')
    % -------------------------------------------------------------------------
    %
    % Function 'ufwt2':
    %
    % Use:
    %       -- [dpd, info] = MRS_Denoise(pd, wt, fbi)
    %       -- [dpd, info] = MRS_Denoise(pd, wt, fbi, scaling)
    %
    % Description:
    %       TODO: Add function descritpion here.
    %
    % Copyright (C) 2023 Ljubomir Kurij <ljubomir_kurij@protonmail.com>.
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
    % -------------------------------------------------------------------------

    fname = 'MRS_Denoise';
    use_case_a = sprintf(' -- [dpd, info] = %s(pd, wt, fbi)', fname);
    use_case_b = sprintf(' -- [dpd, info] = %s(pd, wt, fbi, scaling)', fname);

    %  Add required packages to the path ---------------------------------------
    pkg load image;
    pkg load ltfat;

    %  Check input parameters --------------------------------------------------

    % Check the number of input parameters
    if 3 ~= nargin && 4 ~= nargin
        % Invalid call to function
        error( ...
              'Invalid call to %s. Correct usage is:\n%s\n%s', ...
              fname, ...
              use_case_a, ...
              use_case_b ...
             );

    end  % End of if 3 ~= nargin && 4 ~= nargin

    % Validate input signal format
    validateattributes( ...
                       pd, ...
                       {'float'}, ...
                       { ...
                        '2d', ...
                        'finite', ...
                        'nonempty', ...
                        'nonnan' ...
                       }, ...
                       fname, ...
                       'pd' ...
                      );

    % Validate value(s) supplied for the wavelet filterbank definition
    try
        wt = fwtinit(wt);

    catch err
        error( ...
              '%s: %s', ...
              fname, ...
              err.message ...
             );

    end  % End of try-catch block

    % This could be removed with some effort. The question is, are there such
    % wavelet filters? If your filterbank has different subsampling factors
    % after first two filters, please send a feature request.
    assert(
           wt.a(1) == wt.a(2),
           cstrcat(
                   'First two elements of a vector ''wt.a'' are not equal. ',
                   'Such wavelet filterbank is not suported.'
                  )
          );

    % For holding the time-reversed, complex conjugate impulse responses.
    filt_no = length(wt.h);

    % Validate value supplied for the number of filterbank iterations
    validateattributes( ...
                      fbi, ...
                      {'numeric'}, ...
                      { ...
                          'scalar', ...
                          'finite', ...
                          'nonempty', ...
                          'nonnan', ...
                          'integer', ...
                          'positive', ...
                          '>=', 1 ...
                          }, ...
                      fname, ...
                      'fbi' ...
                      );

    % Validate value supplied for the filter scaling
    validatestring( ...
                   scaling, ...
                   {'noscale', 'scale', 'sqrt'}, ...
                   fname, ...
                   'scaling' ...
                  );

    %  Verify length of the input signal ---------------------------------------
    if(2 > size(pd, 1) || 2 > size(pd, 2))
        error(
              '%s: Input signal seems not to be a matrix of at least 2x2 size.',
              fname
             );

    endif;

    %  Run computation ---------------------------------------------------------

    % Optionally scale the filters
    h = comp_filterbankscale(wt.h(:), wt.a(:), scaling);

    %Change format to a matrix
    h_mat = cell2mat(cellfun(@(hEl) hEl.h(:), h(:)', 'UniformOutput', 0));

    % Delays
    h_offset = cellfun(@(hEl) hEl.offset, h(:));

    % Allocate output and mid result
    [H, W] = size(pd);
    w = zeros(H, W, fbi + 1);
    w(:, :, 1) = pd;
    dpd = zeros(H, W);

    run_ptr = fbi + 1;
    jj = 1;
    while(fbi >= jj)
        % Zero index position of the upsampled filters.
        offset = wt.a(1)^(jj - 1) .* (h_offset);

        % Run filterbank
        % First run on columns
        c = comp_atrousfilterbank_td(
                                     w(:, :, 1),
                                     h_mat,
                                     wt.a(1)^(jj - 1),
                                     offset
                                    );

        % Run on rows
        c = comp_atrousfilterbank_td(
                                     squeeze(c(:, 1, :))',
                                     h_mat,
                                     wt.a(1)^(jj - 1),
                                     offset
                                    );

        w(:, :, run_ptr) = w(:, :, 1) - squeeze(c(:, 1, :))';
        w(:, :, 1) = squeeze(c(:, 1, :))';

        % Calculate significant coefficients
        noise_w = w(:, :, run_ptr);
        grad_w = imgradient(mat2gray(noise_w));
        mask_w = grad_w > mean2(grad_w) + std2(grad_w);
        mask_w = imdilate(mask_w, strel('disk', 3, 0));
        mask_w = mat2gray(imfilter(mask_w, fspecial('gaussian', 2, 10)));
        mask_w = mask_w > 0.5;
        % mask_w = grad_w < mean2(grad_w) + std2(grad_w);
        % noise_mean = mean2(noise_w(mask_w));
        % noise_std = std2(noise_w(mask_w));
        % printf('Noise mean: %f, noise std: %f\n', noise_mean, noise_std);
        % noise_w(mask_w) = noise_mean;
        % w(:, :, run_ptr) = noise_w;
        w(:, :, run_ptr) = noise_w .* mask_w;

        --run_ptr;
        ++jj;

    endwhile;

    jj = 1;
    while(size(w, 3) >= jj)
        dpd = dpd + w(:, :, jj);

        ++jj;

    endwhile;

    %  Optionally : Fill info struct -------------------------------------------
    if(nargout > 1)
        info.fname = 'MRS_Denoise';
        info.wt = wt;
        info.J = fbi;
        info.scaling = scaling;

    endif;

endfunction;
