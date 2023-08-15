function bw = Roi_2_Bw(fov_w, fov_h, roi_x, roi_y, roi_w, roi_h)
    % --------------------------------------------------------------------------
    %
    % Function: Roi_2_Bw(fov_w, fov_h, roi_x, roi_y, roi_w, roi_h)
    %
    % --------------------------------------------------------------------------
    %
    % Use:
    %       - bw = Roi_2_Bw(fov_w, fov_h, roi_x, roi_y, roi_w, roi_h)
    %
    % Description:
    %       Convert a Region of Interest (ROI) to a binary image (bw) for the
    %       given Field of View (FoV).
    %
    % Function parameters:
    %       - fov_w, fov_h: dimensions (width and height) of the FoV (in pixels)
    %       - roi_x, roi_y: origin of the ROI (in pixels) relative to the FoV
    %       - roi_w, roi_h: dimensions (width and height) of the ROI (in pixels)
    %
    % Return:
    %       - bw: binary image (logical matrix) of the ROI
    %
    % Examples:
    %       >> mask = Roi_2_Bw(100, 100, 10, 10, 50, 50);
    %       >> imshow(mask);
    %
    % (C) Copyright 2023 Ljubomir Kurij <ljubomir_kurij@protonmail.com>
    % This file is part of FoV Elements version 1.0.0
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

    fname = "Roi_2_Bw";
    use_case_a = sprintf( ...
                         cstrcat( ...
                                 ' -- bw = %s(fov_w, fov_h, roi_y, roi_x, ', ...
                                 'roi_w, roi_h)' ...
                                ), ...
                         fname ...
                        );

    % Check input parameters ---------------------------------------------------

    % Check number of input parameters
    if nargin ~= 6
        error( ...
              'Invalid call to %s. Correct usage is:\n%s', ...
              fname, ...
              use_case_a ...
             );

    end  % End of if nargin ~= 6

    % Check input parameters types
    i = 1;
    while 6 >= i
        pname = {'fov_w', 'fov_h', 'roi_x', 'roi_y', 'roi_w', 'roi_h'};
        validateattributes( ...
                           {fov_w, fov_h, roi_x, roi_y, roi_w, roi_h}{i}, ...
                           {'numeric'}, ...
                           { ...
                            'scalar', ...
                            'integer', ...
                            '>=', 1 ...
                           }, ...
                           fname, ...
                           pname{i}, ...
                           i ...
                          );

        i += 1;

    end  % End of parameter type check
    clear('i', 'pname');

    % Do the computation -------------------------------------------------------

    % Ste FoV origin (for convenience)
    fov_x = 1;
    fov_y = 1;

    % Clip ROI to FoV
    bw = zeros(fov_h, fov_w);
    x0 = max(fov_x, roi_x);
    x1 = min(fov_x + fov_w - 1, roi_x + roi_w - 1);
    y0 = max(fov_y, roi_y);
    y1 = min(fov_y + fov_h - 1, roi_y + roi_h - 1);

    bw(y0:y1, x0:x1) = 1;

end  % End of function Roi_2_Bw

% End of file Roi_2_Bw.m
