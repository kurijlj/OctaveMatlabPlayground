% =============================================================================
% Copyright (C) 2023 Ljubomir Kurij <ljubomir_kurij@protonmail.com>
%
%  This file is part of Computational Field Profile.
%
% This program is free software: you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation, either version 3 of the License, or (at your option)
% any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
% more details.
%
% You should have received a copy of the GNU General Public License along with
% this program.  If not, see <http://www.gnu.org/licenses/>.
%
% =============================================================================

% =============================================================================
%
% 2024-01-05 Ljubomir Kurij <ljubomi_kurij@protonmail.com>
%
% * Signal_Denoising_Demo.m: created.
%
% =============================================================================

% =============================================================================
% * Description:
%       This script demonstrates the use of various denoising algorithms for
%       1D data.
% =============================================================================

% =============================================================================
% Package load section
% =============================================================================
pkg load signal;
pkg load ltfat;

% =============================================================================
% Script body
% =============================================================================

% Generate reference signal (Gaussian) ----------------------------------------
x = -5:0.01:5;
y = Gaussian_Signal(x, 10, 0, 1, 0);

% Generate noisy signal -------------------------------------------------------
y_noisy = Gaussian_Signal(x, 10, 0, 1, 0.1);

% Apply median filter with window size 3 --------------------------------------
y_median = medfilt1(y_noisy, 3);

% Apply Savitzky-Golay filter with window size 5 and polynomial order 2 -------
y_sgolay = sgolayfilt(y_noisy, 2, 5);

% Apply wavelet denoising -----------------------------------------------------

% Estimate noise standard deviation
c = ufwt(y_noisy, 'syn:spline161:1', 1);
sd = median(abs(y_noisy - c(:, 1)')) / 0.6745;

% Apply hard thresholding
c = ufwt(y_noisy, 'spline1:1', 3);
c(:, 2) = c(:, 2) .* (c(:, 2) > (sd * sqrt(2 * log(numel(c(:, 2))))));
c(:, 3) = c(:, 3) .* (c(:, 3) > (sd * sqrt(2 * log(numel(c(:, 3))))));
c(:, 4) = c(:, 4) .* (c(:, 4) > (sd * sqrt(2 * log(numel(c(:, 4))))));
y_wavelet = iufwt(c, 'spline1:1', 3);

% Apply total variation denoising ---------------------------------------------
lam = 1.5;                                           % Regularization parameter
no_iter = 50;                                          % Number of iterations
y_noisy_col = y_noisy(:);                              % Make column vector
cost = zeros(1, no_iter);                              % Cost function history
N = length(y_noisy_col);

I = speye(N);
D = I(2:N, :) - I(1:N - 1, :);
DDT = D * D';

y_tv = y_noisy_col;                                    % Initialization
Dx = D * y_tv;
Dy = D * y_noisy_col;

for k = 1:no_iter
    F = sparse(1:N - 1, 1:N - 1, abs(Dx) / lam) + DDT; % F: Sparse banded matrix
    y_tv = y_noisy_col - D' * (F \ Dy);             % Solve banded linear system
    Dx = D * y_tv;
    cost(k) = ...
        0.5 * sum(abs(y_tv - y_noisy_col).^2) + ...
        lam * sum(abs(Dx));                          % Cost function value
end  % End of for k = 1:no_iter

% Apply Fourier denoising with adaptive thresholding --------------------------
y_fft = fft(y_noisy);
ms = abs(y_fft);                                     % Magnitude spectrum
mad_t = 1.4826 * median(abs(y_fft - median(y_fft))); % MAD threshold
y_fourier = ifft(y_fft .* (abs(y_fft) > mad_t));

% Plot results ----------------------------------------------------------------
figure(1);

subplot(2, 3, 1);
% plot(x, y, 'k', x, y_noisy, 'r');
plot(x, y, 'linewidth', 1.5, x, y_noisy, 'linestyle', '-.');
legend('Reference signal', 'Noisy signal');
title('Reference signal and noisy signal');
text(-4.5, 0.8, sprintf('Mean square error: %.5f', mean((y - y_noisy).^2)));
printf('Mean square error: %.5f\n', mean((y - y_noisy).^2))

subplot(2, 3, 2);
plot(x, y, 'linewidth', 1.5, x, y_median, 'linestyle', '-.');
legend('Reference signal', 'Median filtered signal');
title('Reference signal and median filtered signal');
text(-4.5, 0.8, sprintf('Mean square error: %.5f', mean((y - y_median).^2)));
printf('Mean square error: %.5f\n', mean((y - y_median).^2))

subplot(2, 3, 3);
plot(x, y, 'linewidth', 1.5, x, y_sgolay, 'linestyle', '-.');
legend('Reference signal', 'Savitzky-Golay filtered signal');
title('Reference signal and Savitzky-Golay filtered signal');
text(-4.5, 0.8, sprintf('Mean square error: %.5f', mean((y - y_sgolay).^2)));
printf('Mean square error: %.5f\n', mean((y - y_sgolay).^2))

subplot(2, 3, 4);
plot(x, y, 'linewidth', 1.5, x, y_wavelet, 'linestyle', '-.');
legend('Reference signal', 'Wavelet denoised signal');
title('Reference signal and wavelet denoised signal');
text(-4.5, 0.8, sprintf('Mean square error: %.5f', mean((y(:) - y_wavelet(:)).^2)));
printf('Mean square error: %.5f\n', mean((y(:) - y_wavelet(:)).^2))

subplot(2, 3, 5);
plot(x, y, 'linewidth', 1.5, x, y_tv, 'linestyle', '-.');
legend('Reference signal', 'Total variation denoised signal');
title('Reference signal and total variation denoised signal');
text(-4.5, 0.8, sprintf('Mean square error: %.5f', mean((y(:) - y_tv(:)).^2)));
printf('Mean square error: %.5f\n', mean((y(:) - y_tv(:)).^2))

subplot(2, 3, 6);
plot(x, y, 'linewidth', 1.5, x, y_fourier, 'linestyle', '-.');
legend('Reference signal', 'Fourier denoised signal');
title('Reference signal and Fourier denoised signal');
text(-4.5, 0.8, sprintf('Mean square error: %.5f', mean((y - y_fourier).^2)));
printf('Mean square error: %.5f\n', mean((y - y_fourier).^2))

% End of file 'Signal_Denoising_Demo.m'
