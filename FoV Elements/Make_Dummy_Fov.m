function fov = Make_Dummy_Fov(w, h)
    %% -------------------------------------------------------------------------
    %%
    %% Function: Make_Dummy_Fov(w, h)
    %%
    %% -------------------------------------------------------------------------
    %
    %% Use:
    %       - fov = Make_Dummy_Fov(w, h)
    %
    %% Description:
    %       This function creates a dummy fov (Field of View) with the given
    %       dimensions. It genearates a fov with the given dimensions and with
    %       the checkerboard pattern.
    %
    %% Function parameters:
    %       - w, h: dimensions (width and height) of the fov (in pixels)
    %
    %% Return:
    %       - fov: dummy fov matrix
    %
    %% Examples:
    %       >> fov = Make_Dummy_Fov(100, 100);
    %       >> imshow(fov);
    %
    %% (C) Copyright 2023 Ljubomir Kurij
    %
    %% -------------------------------------------------------------------------
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
