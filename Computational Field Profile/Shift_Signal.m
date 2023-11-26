function ys = Shift_Signal(x, y, shift)
    %% -------------------------------------------------------------------------
    %%
    %% Function: Shift_Signal(x, y, shift)
    %%
    %% -------------------------------------------------------------------------
    %
    %% Description:
    %       Shifts the signal y by shift displacement. The signal x is the
    %       time / space vector of the signal y.
    %
    %% Usage:
    %       ys = Shift_Signal(x, y, shift)
    %
    %% Function Parameters:
    %       x       -   time / space vector of the signal y
    %       y       -   signal to be shifted
    %       shift   -   time / space displacement of the signal y
    %
    %% Output Parameters:
    %       ys      -   shifted signal
    %
    %% Examples:
    %       x = linspace(0, 10, 1000);
    %       y = sin(x);
    %       ys = Shift_Signal(x, y, 2);
    %       plot(x, y, x, ys);
    %
    %% (C) Copyright 2023 Ljubomir Kurij
    %
    %% -------------------------------------------------------------------------
    fname = 'Shift_Signal';
    use_case_a = sprintf(' - ys = %s(x, y, shift)', fname);

    % Check input parameters ---------------------------------------------------

    % Check number of input parameters
    if nargin ~= 3
        error( ...
              'Invalid call to %s. Correct usage is:\n%s', ...
              fname, ...
              use_case_a ...
             );

    end  % End of if nargin ~= 3

    % Check the type of the input parameters
    validateattributes( ...
                       x, ...
                       {'numeric'}, ...
                       {'vector', 'real', 'finite', 'nonnan', 'nonsparse'}, ...
                       fname, ...
                       'x', ...
                       1 ...
                      );
    validateattributes( ...
                       y, ...
                       {'numeric'}, ...
                       {'vector', 'real', 'finite', 'nonnan', 'nonsparse'}, ...
                       fname, ...
                       'y', ...
                       2 ...
                      );
    validateattributes( ...
                       shift, ...
                       {'numeric'}, ...
                       {'scalar', 'real', 'finite', 'nonnan', 'nonsparse'}, ...
                       fname, ...
                       'shift', ...
                       3 ...
                      );

    % Check the size of the input parameters
    if length(x) ~= length(y)
        error('Vectors x and y must have the same length.');

    end  % End of if length(x) ~= length(y)

    % Absciisa must monotonically increase
    if any(diff(x) <= 0)
        error( ...
              'The values of x must be strictly increasing.' ...
             );
    end  % End of if any(diff(x) <= 0)

    % shift must not exceed the maximum absciisa span
    if abs(shift) > (x(end) - x(1))
        error('shift must not exceed the maximum absciisa span.');

    end  % End of if abs(shift) > (x(end) - x(1))

    % Do the computation -------------------------------------------------------

    % We assume that the abscissa vector x is sorted in ascending order, and is
    % uniformly spaced. We also assume that the abscissa vector x is a row
    % vector.
    x_step = x(2) - x(1);
    y_step_shift = round(shift / x_step);

    % Shift the signal y
    if y_step_shift > 0
        ys = [y(1) .* ones(1, abs(y_step_shift)), y(1:end - y_step_shift)];

    elseif y_step_shift < 0
        ys = [y(1 - y_step_shift:end), y(end) .* ones(1, abs(y_step_shift))];

    else
        ys = y;

    end  % End of if y_step_shift > 0

end  % End of function Shift_Signal

% End of file Shift_Signal.m
