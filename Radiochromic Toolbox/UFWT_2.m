function [ac, vc, hc, dc, info] = UFWT_2(f, w, fi, scaling)
    % --------------------------------------------------------------------------
    %
    % Function: UFWT_2(f, w, fi, scaling)
    %
    % --------------------------------------------------------------------------
    %
    % Use:
    %       -- [ac, vc, hc, dc, info] = UFWT_2(f, w, fi)
    %       -- [ac, vc, hc, dc, info] = UFWT_2(f, w, fi, scaling)
    %
    % Description:
    %       Compute the 2D undecimated wavelet transform of a 2D image f using
    %       the wavelet w and the number of filterbank iterations fi.
    %
    % Function parameters:
    %       -- f: 2D image
    %       -- w: wavelet filterbank
    %       -- fi: number of filterbank iterations
    %       -- scaling: filter scaling flag (default: 'sqrt')
    %
    %       Note: For more information on the input parameters, please refer to
    %       the documentation of the ufwt function of the ltfat package.
    %
    % Return:
    %       -- ac: residual approximation coefficients stored in L x W matrix.
    %       -- vc: vertical detail coefficients stored in
    %             fi x (filtNo - 1) x L x W matrix.
    %       -- hc: horizontal detail coefficients stored in
    %             fi x (filtNo - 1) x L x W matrix.
    %       -- dc: diagonal detail coefficients stored in
    %             fi x (filtNo - 1) x (filtNo - 1) x L x W matrix.
    %       -- info: Transform parameters structure.
    %
    % Required packages:
    %       -- ltfat (http://ltfat.org)
    %
    % Example:
    %       -- [ac, vc, hc, dc, info] = UFWT_2(f, w, fi)
    %       -- [ac, vc, hc, dc, info] = UFWT_2(f, w, fi, 'sqrt')
    %
    % Copyright (C) 2005-2022 Peter L. Soendergaard <peter@sonderport.dk>
    % and others.
    % Modifications Copyright (C) 2023 Ljubomir Kurij
    % <ljubomir_kurij@protonmail.com>.
    % This file is part of LTFAT version 2.5.0
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

    fname = 'UFWT_2';
    use_case_a = sprintf(' -- [ac, vc, hc, dc, info] = %s(f, w, fi)', fname);
    use_case_b = sprintf( ...
                         cstrcat( ...
                                 ' -- [ac, vc, hc, dc, info] = ', ...
                                 '%s(f, w, fi, scaling)' ...
                                ), ...
                         fname ...
                        );

    % Add the ltfat package to the path ----------------------------------------
    pkg load ltfat;

    % Check input parameters ---------------------------------------------------

    % Check number of input parameters
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
                       f, ...
                       {'float'}, ...
                       { ...
                        '2d', ...
                        'finite', ...
                        'nonempty', ...
                        'nonnan' ...
                       }, ...
                       fname, ...
                       'f' ...
                      );

    % Validate value(s) supplied for the wavelet filterbank definition
    try
        w = fwtinit(w);

    catch err
        error('%s: %s', fname, err.message);

    end  % End of try-catch block

    % This could be removed with some effort. The question is, are there such
    % wavelet filters? If your filterbank has different subsampling factors
    % after first two filters, please send a feature request.
    assert( ...
           w.a(1) == w.a(2), ...
           cstrcat( ...
                   'First two elements of a vector w.a are not equal. ', ...
                   'Such wavelet filterbank is not suported.' ...
                  ) ...
          );

    % For holding the time-reversed, complex conjugate impulse responses.
    filtNo = length(w.h);

    % Validate value supplied for the number of filterbank iterations
    validateattributes( ...
                       fi, ...
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
                       'fi' ...
                      );

    % Set default value for the filter scaling if not supplied
    if 3 == nargin
        scaling = 'sqrt';

    end  % End of if 3 == nargin

    % Validate value supplied for the filter scaling
    validatestring( ...
                   scaling, ...
                   {'noscale', 'scale', 'sqrt'}, ...
                   fname, ...
                   'scaling' ...
                  );

    %  Verify length of the input signal ---------------------------------------
    if 2 > size(f, 1) || 2 > size(f, 2)
        error( ...
              sprintf( ...
                      cstrcat( ...
                              '%s: Input signal seems not to be a matrix', ...
                              'of at least 2x2 size.' ...
                             ), ...
                      fname ...
                     ) ...
             );

    end  % End of if 2 > size(f, 1) || 2 > size(f, 2)

    % Run computation ----------------------------------------------------------

    % Optionally scale the filters
    h = comp_filterbankscale(w.h(:), w.a(:), scaling);

    % Change format to a matrix
    hMat = cell2mat(cellfun(@(hEl) hEl.h(:), h(:)', 'UniformOutput', 0));

    % Delays
    hOffset = cellfun(@(hEl) hEl.offset, h(:));

    % Allocate output and mid result
    [L, W] = size(f);
    ac = f;
    b = zeros(filtNo, W, filtNo, L, assert_classname(f, hMat));
    vc = zeros(fi, filtNo - 1, L, W, assert_classname(f, hMat));
    hc = zeros(fi, filtNo - 1, L, W, assert_classname(f, hMat));
    dc = zeros(fi, filtNo - 1, filtNo - 1, L, W, assert_classname(f, hMat));

    runPtr = fi;
    jj = 1;
    while fi >= jj
        % Zero index position of the upsampled filters.
        offset = w.a(1)^(jj - 1) .* (hOffset);

        % Run filterbank
        % First run on columns
        ac = comp_atrousfilterbank_td(ac, hMat, w.a(1)^(jj - 1), offset);
        % Run on rows
        kk = 1;
        while filtNo >= kk
            b(kk, :, :, :) = ...
                comp_atrousfilterbank_td( ...
                                         squeeze(ac(:, kk, :))', ...
                                         hMat, ...
                                         w.a(1)^(jj - 1), ...
                                         offset ...
                                        );

            ++kk;

        end  % End of while filtNo >= kk

        % Bokkeeping
        kk = 1;
        while filtNo >= kk
            ll = 1;
            while filtNo >= ll
                if 1 == kk
                    if 1 == ll
                        ac = squeeze(b(1, :, 1, :))';

                    else
                        hc(runPtr, ll - 1, :, :) ...
                            = squeeze(b(1, :, ll, :))';

                    end  % End of if 1 == ll

                else
                    if 1 == ll
                        vc(runPtr, kk - 1, :, :) ...
                            = squeeze(b(kk, :, 1, :))';

                    else
                        dc(runPtr, kk - 1, ll - 1, :, :) ...
                            = squeeze(b(kk, :, ll, :))';

                    end  % End of if 1 == ll

                end  % End of if 1 == kk

                ++ll;

            end  % End of while filtNo >= ll

            ++kk;

        end  % End of while filtNo >= kk

        --runPtr;
        ++jj;

    end  % End of while fi >= jj

    % Optionally : Fill info struct --------------------------------------------
    if nargout > 4
        info.fname = 'ufwt2';
        info.wt = w;
        info.J = fi;
        info.scaling = scaling;

    end  % End of if nargout > 1

end  % End of function UFWT_2

% End of file UFWT_2.m
