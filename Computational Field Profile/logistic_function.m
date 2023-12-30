function y = Logistic_Function(x, l, k, x_zero)
    %% -------------------------------------------------------------------------
    %%
    %% Function: Logistic_Function(x, l, k, x_zero)
    %%
    %% -------------------------------------------------------------------------
    %
    %% Use:
    %       - y = Logistic_Function(x, l, k, x_zero)
    %
    %% Description:
    %       Compute the logistic function.
    %
    %% Function parameters:
    %       - x:   x values
    %       - l:   maximum value
    %       - k:   steepness
    %       - x_zero: x value of the sigmoid's midpoint
    %
    %% Examples:
    %       - y = Logisitc_Function(0, 1, sqrt(2), 0)
    %       - y = Logisitc_Function([-1, 0, 1], 1, sqrt(2), 1)
    %
    %% (C) Copyright 2023 Ljubomir Kurij <ljubomir_kurij@protonmail.com>
    %
    %% -------------------------------------------------------------------------
    fname = 'Logistic_Function';
    use_case_a = sprintf('- y = %s(x, l, k, x_zero)', fname);

    % Check input arguments ----------------------------------------------------

    % Check the number of input arguments
    if 4 ~= nargin
        error( ...
              'Invalid call to %s. Correct usage is:\n%s', ...
              fname, ...
              use_case_a ...
             );
    end  % End of if 4 ~= nargin

    % Check the type of input arguments
    validateattributes( ...
                       x, ...
                       {'numeric'}, ...
                       {'nonempty', 'real', 'finite'}, ...
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

    % Do the calculations ------------------------------------------------------

    % NOTE: To determine the steepness of the curve, for the given width of the
    %       curve, use the following formula:
    %           k = 2*log(95/5)/width

    y = l ./ (1 + exp(-k * (x - x_zero)));

end  % End of function Logistic_Function

% End of file 'Logistic_Function.m'
