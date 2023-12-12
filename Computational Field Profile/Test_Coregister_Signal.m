% ==============================================================================
%
% Test_Corregister_Signal.m - Set of tests for the Corregister_Signal function
%
% Copyright (C) 2023 Ljubomir Kurij
%
% ==============================================================================

% Define the logistic function
lf1 = @(x, x_zero) 1 ./ (1 + exp(-1.73 .* (x - x_zero)));
lf2 = @(x, x_zero) 1 ./ (1 + exp(-(1.73/1.5) .* (x - x_zero)));

% Define the reference signal for the logistic function
rs = linspace(0, 10, 201)';
rs(:, 2) = lf1(rs(:, 1), 5);

% Define the test signals for the logistic function.

% The first test signal is shifted % by 12 units to the left from the reference
% signal, spans from -10.0 to -5.0, and has 4 times smaller resolution than the
% reference signal.`
ts1 = linspace(-10, -5, 26)';
ts1(:, 2) = lf1(ts1(:, 1), -7);

% The second test signal is also shifted by 12 units to the left from the
% reference signal, it also spans from -10.0 to -5.0, but has 2 times smaller
% resolution than the reference signal, and has a different slope.
ts2 = linspace(-10, -5, 51)';
ts2(:, 2) = lf2(ts2(:, 1), -7);

% The third test signal is not shifted from the reference signal, spans from
% 2.0 to 15.0, and has 2 times smaller resolution than the reference signal,
% and has a different slope.
ts3 = linspace(2, 15, 131)';
ts3(:, 2) = lf2(ts3(:, 1), 5);

% Test the Coregister_Signal function with the first test signal.
figure;
Coregister_Signal(rs(:, 1), rs(:, 2), ts1(:, 1), ts1(:, 2))

% Test in the reverse order.
figure;
Coregister_Signal(ts1(:, 1), ts1(:, 2), rs(:, 1), rs(:, 2))

% Test the Coregister_Signal function with the second test signal.
figure;
Coregister_Signal(rs(:, 1), rs(:, 2), ts2(:, 1), ts2(:, 2))

% Test in the reverse order.
figure;
Coregister_Signal(ts2(:, 1), ts2(:, 2), rs(:, 1), rs(:, 2))

% Test the Coregister_Signal function with the third test signal.
figure;
Coregister_Signal(rs(:, 1), rs(:, 2), ts3(:, 1), ts3(:, 2))

% Test in the reverse order.
figure;
Coregister_Signal(ts3(:, 1), ts3(:, 2), rs(:, 1), rs(:, 2))

% End of file Test_Corregister_Signal.m
