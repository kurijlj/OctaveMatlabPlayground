function roi = Roi_2_Fov(varargin)
    %% -------------------------------------------------------------------------
    %%
    %% Function: Roi_2_Fov(fov_w, fov_h, roi_x, roi_y, roi_w, roi_h)
    %%
    %% -------------------------------------------------------------------------
    %
    %% Use:
    %       - roi = Roi_2_Fov(fov_w, fov_h, roi_x,
    %       roi_y, roi_w, roi_h)
    %
    %% Description:
    %       This function recalculates the coordinates and dimensions of the
    %       given ROI (Region of Interest) so that given ROI fits inside the
    %       given FoV (Field of View).
    %
    %% Function parameters:
    %       - fov_w, fov_h: dimensions (width and height) of the FoV (in pixels)
    %       - roi_x, roi_y: origin of the ROI (in pixels) relative to the FoV
    %       - roi_w, roi_h: dimensions (width and height) of the ROI (in pixels)
    %
    %% Return:
    %       - roi: a column vector containing the coordinates and dimensions of
    %              the ROI (in pixels) relative to the FoV in the following
    %              order: [roi_x; roi_y; roi_w; roi_h]
    %
    %% Examples:
    %       >> Roi_2_Fov(100, 100, 10, 10, 50, 50)
    %       ans =
    %           10   10   50   50
    %
    %       >> Roi_2_Fov(100, 100, 0, 0, 100, 100)
    %       ans =
    %           0    0   100   100
    %
    %       >> Roi_2_Fov(100, 100, 0, 0, 200, 200)
    %       ans =
    %           0    0   100   100
    %
    %       >> Roi_2_Fov(100, 100, -100, -100, 200, 100)
    %       ans =
    %           0    0   100   100
    %
    %% (C) Copyright 2023 Ljubomir Kurij
    %
    %% -------------------------------------------------------------------------
    fname = 'Roi_2_Fov';
    use_case_a = sprintf( ...
                         cstrcat( ...
                                 ' -- [roi_x, roi_y, roi_w, roi_h] = ', ...
                                 '%s(fov_w, fov_h, roi_y, roi_x, roi_w, ', ...
                                 'roi_h)' ...
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
                           varargin{i}, ...
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

    % Store input parameters listo into local variables
    positional = parseparams(varargin);
    [fov_w, fov_h, roi_x, roi_y, roi_w, roi_h] = positional{:};
    clear('positional');

    % Do the computation -------------------------------------------------------

    % Set FoV origin (for convenience)
    x0 = 1;
    y0 = 1;

    % Allocate ROI vector
    roi = [roi_x; roi_y; roi_w; roi_h];
    % Resize ROI if it extents beyond the FoV
    roi(3) = min(fov_w, roi_w);
    roi(4) = min(fov_h, roi_h);

    % Move ROI if it is outside the FoV
    roi(1) = max(roi_x, x0);
    roi(1) = min(roi_x, x0 + fov_w - roi_w);
    roi(2) = max(roi_y, y0);
    roi(2) = min(roi_y, y0 + fov_h - roi_h);

end  % End of Roi_2_Fov

% End of file Roi_2_Fov.m
