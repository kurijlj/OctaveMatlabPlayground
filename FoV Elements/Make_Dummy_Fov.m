function fov = Make_Dummy_Fov(w, h)
    % --------------------------------------------------------------------------
    %
    % Function: Make_Dummy_Fov(w, h)
    %
    % --------------------------------------------------------------------------
    %
    % Use:
    %       - fov = Make_Dummy_Fov(w, h)
    %
    % Description:
    %       This function creates a dummy fov (Field of View) with the given
    %       dimensions. It genearates a fov with the given dimensions and with
    %       the checkerboard pattern.
    %
    % Function parameters:
    %       - w, h: dimensions (width and height) of the fov (in pixels)
    %
    % Return:
    %       - fov: dummy fov matrix
    %
    % Examples:
    %       >> fov = Make_Dummy_Fov(100, 100);
    %       >> imshow(fov);
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

    fname = 'Make_Dummy_Fov';
    use_case = sprintf( ...
                       ' -- fov = %s(w, h)', ...
                       fname ...
                      );

    % Check input parameters ---------------------------------------------------

    % Check number of input parameters
    if 2 ~= nargin
        error( ...
              'Invalid call to %s. Correct usage is:\n%s', ...
              fname, ...
              use_case ...
             );

    end  % End of if 2 ~= nargin

    % Check type of input parameters
    i = 1;
    while 2 >= i
        pname = {'W', 'H'};
        validateattributes( ...
                           {w, h}{i}, ...
                           {'numeric'}, ...
                           { ...
                            'scalar', ...
                            'integer', ...
                            '>=', 5 ...
                           }, ...
                           fname, ...
                           pname{i} ...
                          );

        i += 1;

    end  % End of parameter type check
    clear('i', 'pname');

    % Do the computation -------------------------------------------------------

    % Create a dummy fov
    fov = zeros(h, w);

    % Fill the fov with the checkerboard pattern
    if 0 == mod(h, 2)
        fov(1:2:h, 1:2:w) = 1;
        fov(2:2:h, 2:2:w) = 1;

    else
        fov(1:2:h, 2:2:w) = 1;
        fov(2:2:h, 1:2:w) = 1;

    end  % End of if 0 == mod(h, 2)

end  % End of function Make_Dummy_Fov

% End of file Make_Dummy_Fov.m
