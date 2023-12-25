function x_off = Coregister_Signal(x_ref, y_ref, x_target, y_target)
    %% -------------------------------------------------------------------------
    %%
    %% Function: Coregister_Signal(x_ref, y_ref, x_target, y_target)
    %%
    %% -------------------------------------------------------------------------
    %
    %% Description:
    %       This function coregisters the target signal to the reference signal
    %       using the sum of squared differences (SSD) as the similarity metric.
    %
    %% Usage:
    %       x_off = Coregister_Signal(x_ref, y_ref, x_target, y_target)
    %
    %% Function parameters:
    %       x_ref       - x-axis of the reference signal
    %       y_ref       - y-axis of the reference signal
    %       x_target    - x-axis of the target signal
    %       y_target    - y-axis of the target signal
    %
    %% Output:
    %       x_off       - x-axis shift of the target signal relative to the
    %                     reference signal
    %
    %% Examples:
    %       x_off = Coregister_Signal(x_ref, y_ref, x_target, y_target)
    %
    %% (C) Copyright 2023 Ljubomir Kurij
    %
    %% -------------------------------------------------------------------------
    fname = 'Coregister_Signal';
    use_case_a = sprintf( ...
                         ' - x_off = %s(x_ref, y_ref, x_target, y_target)', ...
                         fname ...
                        );

    % Check the imput arguments ------------------------------------------------

    % Check the number of input arguments
    if nargin ~= 4
        error( ...
              'Invalid call to %s. Correct usage is:\n%s', ...
              fname, ...
              use_case_a ...
             );
    end  % End of if nargin ~= 4

    % Check the type of the input arguments
    validateattributes( ...
                       x_ref, ...
                       {'numeric'}, ...
                       {'vector', 'real', 'finite', 'nonnan', 'nonsparse'}, ...
                       fname, ...
                       'x_ref', ...
                       1 ...
                      );
    validateattributes( ...
                       y_ref, ...
                       {'numeric'}, ...
                       {'vector', 'real', 'finite', 'nonnan', 'nonsparse'}, ...
                       fname, ...
                       'y_ref', ...
                       2 ...
                      );
    validateattributes( ...
                       x_target, ...
                       {'numeric'}, ...
                       {'vector', 'real', 'finite', 'nonnan', 'nonsparse'}, ...
                       fname, ...
                       'x_target', ...
                       3 ...
                      );
    validateattributes( ...
                       y_target, ...
                       {'numeric'}, ...
                       {'vector', 'real', 'finite', 'nonnan', 'nonsparse'}, ...
                       fname, ...
                       'y_target', ...
                       4 ...
                      );

    % Check the size of the input arguments
    if length(x_ref) ~= length(y_ref)
        error( ...
              'The length of x_ref and y_ref must be the same.' ...
             );
    end  % End of if length(x_ref) ~= length(y_ref)
    if length(x_target) ~= length(y_target)
        error( ...
              'The length of x_target and y_target must be the same.' ...
             );
    end  % End of if length(x_target) ~= length(y_target)

    % Check the values of the input arguments
    if any(diff(x_ref) <= 0)
        error( ...
              'The values of x_ref must be strictly increasing.' ...
             );
    end  % End of if any(diff(x_ref) <= 0)
    if any(diff(x_target) <= 0)
        error( ...
              'The values of x_target must be strictly increasing.' ...
             );
    end  % End of if any(diff(x_target) <= 0)

    % Do the computation -------------------------------------------------------

    % Resample abscissas of the reference and target signals. In the case of
    % abscissa values not being equally spaced, resample them to equally spaced
    % abscissa values.
    x_ref = Resample_Abscissa(x_ref);
    x_target = Resample_Abscissa(x_target);

    % Resample the abscissas of the reference and target signals to the common
    % (i.e. smallest) sampling interval. This is done to avoid the situation
    % where the reference and target signals have different sampling intervals
    % and to avoid the error in the computation of the SSD (sum of squared
    % differences)
    x_ref_r = x_ref;
    x_target_r = x_target;
    if diff(x_ref)(1) < diff(x_target)(1)
        x_target_r = x_target(1):x_ref(2) - x_ref(1):x_target(end);
    elseif diff(x_ref)(1) > diff(x_target)(1)
        x_ref_r = x_ref(1):x_target(2) - x_target(1):x_ref(end);
    end  % End of if diff(x_ref)(1) < diff(x_target)(1)

    % Resample the ordinates of the reference and target signals
    y_ref = interp1(x_ref, y_ref, x_ref_r);
    y_target = interp1(x_target, y_target, x_target_r);
    x_ref = x_ref_r;
    x_target = x_target_r;

    % Clear the variables that are no longer needed
    clear('x_ref_r', 'x_target_r');

    % Calculate the common abscissa range (i.e. the union of the abscissa
    % ranges)
    x_min = min([x_ref(1), x_target(1)]);
    x_max = max([x_ref(end), x_target(end)]) + x_ref(2) - x_ref(1);
    x_common = x_min:x_ref(2) - x_ref(1):x_max;

    % Extrapolate the ordinate of the reference signal to the
    % common abscissa range
    y_left = find(x_common > x_ref(1), 1) - 1;
    y_right = find(x_common > x_ref(1), 1) + length(y_ref) - 1;
    y_ref_r = ones(1, length(x_common));
    y_ref_r(1:y_left) = y_ref_r(1:y_left) .* y_ref(1);
    y_ref_r(y_left + 1:y_right) = y_ref(:);
    y_ref_r(y_right + 1:end) = y_ref_r(y_right + 1:end) .* y_ref(end);

    % Extrapolate the ordinate of the target signal to the
    % common abscissa range
    y_left = find(x_common > x_target(1), 1) - 1;
    y_right = find(x_common > x_target(1), 1) + length(y_target) - 1;
    y_target_r = ones(1, length(x_common));
    y_target_r(1:y_left) = y_target_r(1:y_left) .* y_target(1);
    y_target_r(y_left + 1:y_right) = y_target(:);
    y_target_r(y_right + 1:end) = y_target_r(y_right + 1:end) .* y_target(end);

    % Re-bound resampled values to the original variable names
    y_ref = y_ref_r;
    y_target = y_target_r;

    % Clear the variables that are no longer needed
    clear( ...
          'y_ref_r', ...
          'y_target_r', ...
          'y_left', ...
          'y_right', ...
          'x_min', ...
          'x_max', ...
          'x_ref', ...
          'x_target' ...
         );

    % Calculate the full span of the shifts of the target signal relative to
    % the reference signal
    shift_step = x_common(2) - x_common(1);
    shift_min = x_common(1) - x_common(end);
    shift_max = x_common(end) - x_common(1);
    x_shift = shift_min:shift_step:shift_max;
    y_ssd = zeros(1, length(x_shift));

    % Clear the variables that are no longer needed
    clear('shift_min', 'shift_max', 'shift_step');

    % Compute the sum of squared differences (SSD) between the reference
    % and target signals for all possible shifts of the target signal
    % relative to the reference signal
    idx = 1;
    while length(x_shift) >= idx
        y_target_shifted = Shift_Signal(x_common, y_target, x_shift(idx));
        y_ssd(idx) = sum((y_ref - y_target_shifted).^2);
        idx = idx + 1;

        % Plot live preview of the SSD calculation
        subplot(2, 1, 1);
        plot(x_common, y_ref, 'b', x_common, y_target_shifted, 'r');
        subplot(2, 1, 2);
        plot(x_shift, y_ssd, 'k');
        pause(0.001);

    end  % End of while length(x_shift) >= idx

    % Find the shift that minimizes the SSD
    [~, i_min] = min(y_ssd);
    x_off = x_shift(i_min);

end  % End of function Coregister_Signal

% End of file Coregister_Signal.m
