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
    end

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
    end
    if length(x_target) ~= length(y_target)
        error( ...
              'The length of x_target and y_target must be the same.' ...
             );
    end

    % Check the values of the input arguments
    if any(diff(x_ref) <= 0)
        error( ...
              'The values of x_ref must be strictly increasing.' ...
             );
    end
    if any(diff(x_target) <= 0)
        error( ...
              'The values of x_target must be strictly increasing.' ...
             );
    end

    % Do the computation -------------------------------------------------------

    % Resample abscissas of the reference and target signals
    x_ref = Resample_Abscissa(x_ref);
    x_target = Resample_Abscissa(x_target);

    % Resample the abscissas to the signal with the smallest sampling interval
    x_ref_r = x_ref;
    x_target_r = x_target;
    if diff(x_ref)(1) < diff(x_target)(1)
        x_target_r = x_target(1):x_ref(2) - x_ref(1):x_target(end);
    else
        x_ref_r = x_ref(1):x_target(2) - x_target(1):x_ref(end);
    end

    % Resample the ordinates of the reference and target signals
    y_ref = interp1(x_ref, y_ref, x_ref_r, 'spline');
    y_target = interp1(x_target, y_target, x_target_r, 'spline');
    x_ref = x_ref_r;
    x_target = x_target_r;
    clear('x_ref_r', 'x_target_r');

    % Extrapolate the ordinates of the reference and target signals
    % to the same abscissa range (i.e. the union of the abscissa ranges)
    x_min = min([x_ref(1), x_target(1)]);
    x_max = max([x_ref(end), x_target(end)]);
    x_common = x_min:x_ref(2) - x_ref(1):x_max;
    y_ref = interp1(x_ref, y_ref, x_common, 'spline', 'extrap');
    y_target = interp1(x_target, y_target, x_common, 'spline', 'extrap');
    clear('x_min', 'x_max', 'x_ref', 'x_target');

    % Compute the sum of squared differences (SSD) between the reference
    % and target signals for all possible shifts of the target signal
    % relative to the reference signal
    x_off = x_common;
    y_ssd = zeros(1, length(x_off));
    for i = 1:length(x_off)
        y_ssd(i) = sum((y_ref - circshift(y_target, i - 1)).^2);
    end
    clear('x_common', 'y_ref', 'y_target');

    % Find the shift that minimizes the SSD
    [~, i_min] = min(y_ssd);
    x_off = x_off(i_min);

end  % End of function Coregister_Signal

% End of file Coregister_Signal.m
