function [ds, ref] = Make_Dummy_Scan(varargin)
    % --------------------------------------------------------------------------
    %
    % Function: Make_Dummy_Scan(varargin)
    %
    % --------------------------------------------------------------------------
    %
    %  Use:
    %       -- [ds, ref] = Make_Dummy_Scan()
    %       -- [ds, ref] = Make_Dummy_Scan(L)
    %       -- [ds, ref] = Make_Dummy_Scan(W, H)
    %       -- [ds, ref] = Make_Dummy_Scan(..., "PROPERTY", VALUE, ...)
    %
    % Description:
    %       Generate a dummy scan image with the given size and Gaussian noise.
    %
    % Function parameters:
    %       -- width:        integer, def. 1024
    %                        Width of the dummy scan image to generate. Value
    %                        must be greater than or equal to 128.
    %       -- height:       integer, def. 1024
    %                        Height of the dummy scan image to generate. Value
    %                        must be greater than or equal to 128. If not
    %                        specified the height is set to the same value as
    %                        the width.
    %       -- ScanType:     string, def. 'Signal'
    %                        Define the type of dummy scan to generate. Possible
    %                        values are:
    %                           -- 'ZeroLight': Dummy scan simulating zero light
    %                                           scan of the scanner.
    %                           -- 'Control':   Dummy scan simulating control
    %                                           piece scan (scanner background
    %                                           or unexposed film scan).
    %                           -- 'Signal':    Dummy scan simulating irradiated
    %                                           film scan.
    %       -- NoiseSd:      double, def. 0
    %                        Standard deviation in percents of dynamic range of
    %                        the gaussian noise that is to be added to the dummy
    %                        scan. If set to zero no noise is added to the scan.
    %                        Value must be between 0 and 0.09.
    %       -- DynamicRange: integer, def. 65535
    %                        Dynamic range of the dummy scan image to generate.
    %
    % Return:
    %       -- ds:           2D matrix of doubles representing the
    %                        scanned signal
    %       -- ref:          if passed as an output argument, 2D matrix of
    %                        doubles representing the reference signal (e.g.
    %                        without noise)
    %
    % Required packages:
    %       -- image
    %
    % Examples:
    %       >> ds = Make_Dummy_Scan()
    %          Generate a dummy scan image of size 1024x1024 pixels with no
    %          noise added to it.
    %
    %       >> ds = Make_Dummy_Scan(512)
    %          Generate a dummy scan image of size 512x512 pixels with no
    %          noise added to it.
    %
    %       >> ds = Make_Dummy_Scan(512, 512)
    %          Generate a dummy scan image of size 512x512 pixels with no
    %          noise added to it.
    %
    %       >> ds = Make_Dummy_Scan(512, 512, 'NoiseStdev', 0.05)
    %          Generate a dummy scan image of size 512x512 pixels with 5%
    %          of dynamic range gaussian noise added to it.
    %
    %       >> ds = Make_Dummy_Scan(512, 512, 'NoiseStdev', 0.1, ...
    %                               'DynamicRange', 4096)
    %          Generate a dummy scan image of size 512x512 pixels with 10%
    %          of dynamic range gaussian noise added to it. The dynamic range
    %          of the scan is set to 4096.
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

    fname = 'Make_Dummy_Scan';
    use_case_a = sprintf(' -- ds = %s()', fname);
    use_case_b = sprintf(' -- ds = %s(L)', fname);
    use_case_c = sprintf(' -- ds = %s(W, H)', fname);
    use_case_d = sprintf(' -- ds = %s(..., "PROPERTY", VALUE, ...)', fname);

    % Check input parameters ---------------------------------------------------

    [ ...
     pos, ...
     sctype, ...
     noise_sd, ...
     dyn_rng ...
    ] = parseparams( ...
                    varargin, ...
                    'ScanType', 'Signal', ...
                    'NoiseStdev', 0, ...
                    'DynamicRange', 65535 ...
                   );

    % Check the number of positional arguments
    if 2 < numel(pos)
        % Invalid call to function
        error( ...
              'Invalid call to %s. Correct usage is:\n%s\n%s\n%s\n%s', ...
              fname, ...
              use_case_a, ...
              use_case_b, ...
              use_case_c, ...
              use_case_d ...
             );

    elseif 0 == numel(pos)
        % No image size passed as a positional argument. Fall back to default
        % values.
        W = 1024;
        H = 1024;

    elseif 1 == numel(pos)
        % Only one image size passed as a positional argument. Use it as the
        % width and set the height to the same value.
        W = pos{1};
        H = pos{1};

    else
        % Both width and height passed as positional arguments. Use them.
        W = pos{1};
        H = pos{2};

    end  % End of if 2 < numel(pos)

    % Validate the values passed as the image size
    validateattributes( ...
                       W, ...
                       {'numeric'}, ...
                       { ...
                        'nonempty', ...
                        'scalar', ...
                        'integer', ...
                        'finite', ...
                        'positive', ...
                        '>=', 128 ...
                       }, ...
                       fname, ...
                       'width' ...
                      );
    validateattributes( ...
                       H, ...
                       {'numeric'}, ...
                       { ...
                        'nonempty', ...
                        'scalar', ...
                        'integer', ...
                        'finite', ...
                        'positive', ...
                        '>=', 128 ...
                       }, ...
                       fname, ...
                       'height' ...
                      );

    % Validate the values passed as named parameters ---------------------------

    % Validate value passed as scan type
    sctype = validatestring( ...
                   sctype, ...
                   { ...
                    'ZeroLight', ...
                    'Control', ...
                    'Signal' ...
                   }, ...
                   fname, ...
                   'ScanType' ...
                  );

    % Validate value passed as the noise variance
    validateattributes( ...
                       noise_sd, ...
                       {'float'}, ...
                       { ...
                        'nonempty', ...
                        'scalar', ...
                        'real', ...
                        'finite', ...
                        '<=', 0.09, ...
                        '>=', 0 ...
                       }, ...
                       fname, ...
                       'NoiseStdev' ...
                      );

    % Validate value passed as the dynamic range
    validateattributes( ...
                       dyn_rng, ...
                       {'numeric'}, ...
                       { ...
                        'nonempty', ...
                        'scalar', ...
                        'integer', ...
                        'finite', ...
                        'positive', ...
                        '>=', 1, ...
                        '<=', 65535 ...
                       }, ...
                       fname, ...
                       'DynamicRange' ...
                      );

    % Add the image package to the path ----------------------------------------
    pkg load image;

    % Generate the dummy scan --------------------------------------------------

    % Set predefined pixel values for the zero light and the unexposed
    % radiochromic film scans
    zlm = [0.012314, 0.012268, 0.012253];
    ebm = [0.7187, 0.7218, 0.5997];

    % Calculate the pixel values scaling based on the value passed as the
    % dynamic range and the noise variance
    scaling = dyn_rng;
    if 0 ~= noise_sd
        scaling = scaling - 10 * noise_sd * dyn_rng;

    end  % End of if 0 ~= noise_sd

    % Allocate the memory for the computation result
    ref                = ones(H, W);
    ref(:, :, end + 1) = ones(H, W);
    ref(:, :, end + 1) = ones(H, W);

    if isequal('ZeroLight', sctype)
        ref(:, :, 1) = ref(:, :, 1) .* zlm(1) .* scaling;
        ref(:, :, 2) = ref(:, :, 2) .* zlm(2) .* scaling;
        ref(:, :, 3) = ref(:, :, 3) .* zlm(3) .* scaling;

    elseif(isequal('Control', sctype))
        ref(:, :, 1) = ref(:, :, 1) .* ebm(1) .* scaling;
        ref(:, :, 2) = ref(:, :, 2) .* ebm(2) .* scaling;
        ref(:, :, 3) = ref(:, :, 3) .* ebm(3) .* scaling;

    else
        tmp = mat2gray(imcomplement(phantom(min(W, H))));
        offset = floor((max(W, H) - min(W, H)) / 2);
        if W < H
            ref(offset + 1:offset + W, :, 1) = tmp;
            ref(offset + 1:offset + W, :, 2) = tmp;
            ref(offset + 1:offset + W, :, 3) = tmp;

        elseif W > H
            ref(:, offset + 1:offset + H, 1) = tmp;
            ref(:, offset + 1:offset + H, 2) = tmp;
            ref(:, offset + 1:offset + H, 3) = tmp;

        else
            ref(:, :, 1) = tmp;
            ref(:, :, 2) = tmp;
            ref(:, :, 3) = tmp;

        end  % End of if W < H

        ref(:, :, 1) = ref(:, :, 1) .* (ebm(1) - zlm(1)) .* scaling;
        ref(:, :, 2) = ref(:, :, 2) .* (ebm(2) - zlm(2)) .* scaling;
        ref(:, :, 3) = ref(:, :, 3) .* (ebm(3) - zlm(3)) .* scaling;

    end  % End of if isequal('ZeroLight', sctype)

    % Add noise if requested
    if 0 ~= noise_sd
        ds = imnoise( ...
                     ref, ...
                     'gaussian', ...
                     5 * noise_sd * dyn_rng, ...
                     power(noise_sd * dyn_rng, 2) ...
                    );

    else
        ds = ref;

    end  % End of if 0 ~= noise_sd

    % Output the reference signal if requested
    if nargout > 1
        ref(:, :, 1) ...
            = ref(:, :, 1) ...
            + ones(H, W) .* zlm(1) ...
            + ones(H, W) .* 5 .* noise_sd .* dyn_rng;
        ref(:, :, 2) ...
            = ref(:, :, 2) ...
            + ones(H, W) .* zlm(2) ...
            + ones(H, W) .* 5 .* noise_sd .* dyn_rng;
        ref(:, :, 3) ...
            = ref(:, :, 3) ...
            + ones(H, W) .* zlm(3) ...
            + ones(H, W) .* 5 .* noise_sd .* dyn_rng;

    end  % End of if nargout > 1

endfunction;  % Make_Dummy_Scan
