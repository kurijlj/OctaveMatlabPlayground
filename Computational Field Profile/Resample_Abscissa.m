function x_r = Resample_Abscissa(x)
    %% -------------------------------------------------------------------------
    %%
    %% Function: Resample_Abscissa(x)
    %%
    %% -------------------------------------------------------------------------
    %
    %% Description:
    %       Resample the abscissa of a vector x to be equally spaced between
    %       the first and last elements of x.
    %
    %% Use:
    %       x_r = Resample_Abscissa(x)
    %
    %% Function parameters:
    %       x:   Vector to be resampled
    %
    %% Function return:
    %       x_r: Resampled vector
    %
    %% Examples:
    %       x = [1 2 3 4 5 6 7 8 9 10];
    %       x_r = Resample_Abscissa(x);
    %
    %% (C) Copyright 2023 Ljubomir Kurij
    %
    %% -------------------------------------------------------------------------
    fname = 'Resample_Abscissa';
    use_case_a = sprintf('- x_r = %s(x)', fname);

    % Check input arguments ----------------------------------------------------

    % Check number of input arguments
    if nargin ~= 1
        error( ...
              'Invalid call to %s. Correct usage is:\n%s', ...
              fname, ...
              use_case_a ...
             );
    end  % End of if nargin ~= 1

    % Check type of input arguments
    validateattributes( ...
                       x, ...
                       {'numeric'}, ...
                       {'vector'}, ...
                       fname, ...
                       'x' ...
                      );

    % Do the calculation -------------------------------------------------------

    % Calculate the vector of distances between the elements of x
    dx = diff(x);

    % If the vector of distances has more than one unique element, steps of
    % abscissa are not equally spaced and we have to resample the abscissa.
    if numel(unique(dx)) > 1
        % Calculate the new abscissa
        x_r = x(1):min(dx):x(end);

    else
        % If the vector of distances has only one unique element, steps of
        % abscissa are equally spaced and we do not have to resample the
        % abscissa.
        x_r = x;

    end  % End of if numel(unique(dx)) > 1

end  % End of function Resample_Abscissa

% End of file Resample_Abscissa.m
