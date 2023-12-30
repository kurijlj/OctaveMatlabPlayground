function y = Logistic_Signal(x, l, k, x_zero, nvar)
    %% -------------------------------------------------------------------------
    %%
    %% Function: Logistic_Signal(x, l, k, x_zero,)
    %%
    %% -------------------------------------------------------------------------
    %
    %% Use:
    %       - y = Logistic_Signal(x, l, k, x_zero, nvar)
    %
    %% Description:
    %       For the given abscissa x, and the parameters l, k, and x_zero, this
    %       function returns the value of a Logistic function at a given
    %       point x, or at a set of points x, with a Gaussian noise of
    %       variance nvar.
    %
    %% Function parameters:
    %       - x:      point(s) at which the logistic function is evaluated.
    %       - l:      maximum value
    %       - k:      steepness
    %       - x_zero: x value of the sigmoid's midpoint
    %       - nvar:   variance of the Gaussian noise.
    %
    %% Examples:
    %       - y = Logisitc_Signal(0, 1, sqrt(2), 0, 0)
    %       - y = Logisitc_Signal([-1, 0, 1], 1, sqrt(2), 1, 0.1)
    %
    %% Copyright (C) 2023 Ljubomir Kurij <ljubomir_kurij@protonmail.com>
    %
    %% -------------------------------------------------------------------------
    fname = 'Logistic_Signal';
    use_case_a = sprintf(' - y = %s(x, l, k, x_zero, nvar)', fname);

    % Check input arguments ----------------------------------------------------

    % Check number of input arguments
    if 5 ~= nargin
        error( ...
              'Invalid call to %s. Correct usage is:\n%s', ...
              fname, ...
              use_case_a ...
             );
    end  % End of if 5 ~= nargin

    % Check the type of the input arguments
    validateattributes( ...
                       x, ...
                       {'numeric'}, ...
                       {'nonempty', 'nonnan', 'finite', 'real', 'vector'}, ...
                       fname, ...
                       'x' ...
                      );
    validateattributes( ...
                       l, ...
                       {'numeric'}, ...
                       {'scalar', 'nonempty', 'real', 'finite', '>', 0}, ...
                       fname, ...
                       'l' ...
                      );
    validateattributes( ...
                       k, ...
                       {'numeric'}, ...
                       {'scalar', 'nonempty', 'real', 'finite'}, ...
                       fname, ...
                       'k' ...
                      );
    validateattributes( ...
                       x_zero, ...
                       {'numeric'}, ...
                       {'scalar', 'nonempty', 'real', 'finite'}, ...
                       fname, ...
                       'x_zero' ...
                      );
    validateattributes( ...
                       nvar, ...
                       {'numeric'}, ...
                       { ...
                        'nonempty', ...
                        'nonnan', ...
                        'finite', ...
                        'real', ...
                        'scalar', ...
                        '>=', 0}, ...
                       fname, ...
                       'nvar' ...
                      );

    % Do the calculation -------------------------------------------------------
    y = Logistic_Function(x, l, k, x_zero);

    % Add Gaussian noise if noise variance is not zero
    if 0 ~= nvar
        y = y + sqrt(nvar) * randn(size(y));
    end  % End of if 0 ~= nvar

end  % End of function 'Gaussian_Signal'

% End of file 'Gaussian_Signal.m'