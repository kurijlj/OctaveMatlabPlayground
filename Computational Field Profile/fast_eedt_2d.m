function DT = fast_eedt_2d(I)
    %% -------------------------------------------------------------------------
    %%
    %% Function: fast_eedt_2d(I)
    %%
    %% -------------------------------------------------------------------------
    %
    %% Use:
    %       - DT = fast_eedt_2d(I)
    %
    %% Description:
    %       Compute the Euclidean distance transform of a 2D binary image I
    %       using the fast marching method. The distance transform is
    %       computed only on the pixels of the mask.
    %
    %% Function parameters:
    %       - I: binary image
    %
    %% Return:
    %       - DT: distance transform
    %
    %% Examples:
    %       I = imread('circles.png');
    %       I = im2bw(I);
    %       DT = fast_eedt_2d(I);
    %       figure; imshow(DT, []);
    %
    %% (C) Copyright 2023 Ljubomir Kurij
    %
    %% -------------------------------------------------------------------------
    fname = 'fast_eedt_2d';
    use_case_a = sprintf('%s(I)', fname);

    % Check input parameters ---------------------------------------------------

    % Check the number of input parameters
    if 1 ~= nargin
        error( ...
              'Invalid call to %s. Correct usage is:\n%s', ...
              fname, ...
              use_case_a ...
             );
    end  % End of if 1 ~= nargin

    % Check the type of the input parameter
    validateattributes( ...
                       I, ...
                       {'numeric'}, ...
                       {'2d'}, ...
                       fname, ...
                       'I', ...
                       1 ...
                      );
    uv = unique(I);  % Get all unique values in the binary image
    if 2 ~= numel(uv) && ~all(ismember(uv, [0 1]))
        error( ...
              'Invalid call to %s. The input image must be a binary mask.', ...
              fname ...
             );
    end  % End of if 2 ~= numel(uv)

    % Do the computation -------------------------------------------------------

    % NOTE: The code below is a direct copy of the code from the following
    %       paper:
    %
    %       Tilo Strutz, "The Distance Transform and its Computation - An
    %       Introduction", Technical paper, 2021.
    %
    %       The paper can be found at:
    %       https://arxiv.org/pdf/2106.03503.pdf
    %
    %       For real world computations, the bwdist function from the Image
    %       Processing Toolbox should be used instead of this function.

    [M, L] = size(I);
    max_dist = L * L + M * M;
    DT = ones(size(I)) * max_dist;

    DT(I > 0) = 0;  % Set the distance to 0 for all pixels in the mask

    % Compute the column-wise distances
    for j = 1:L % for all columns
        ds = 1;  % distance step
        for i = 2:M  % propagate distances downwards
            if DT(i , j ) > DT(i-1,j) + ds
                DT(i , j) = DT(i-1,j) + ds;
                ds = ds + 2;
            else
                ds = 1;
            end  % End of if DT(i , j ) > DT(i−1,j) + ds
        end  % End of for i = 2:M

        ds = 1;
        for i = M-1:-1:1  % propagate distances upwards
            if DT(i , j) > DT(i+1, j) + ds
                DT(i , j) = DT(i+1, j) + ds;
                ds = ds + 2;
            else
                ds = 1;
            end  % End of if DT(i , j) > DT(i+1, j) + ds
        end  % End of for i = M−1:−1:1
    end  % End of for j = 1:L

    % Compute the row-wise distances
    js = zeros(1, L+1);  % stores intersection positions
    ks = zeros(1, L);    % positions of contributors

    for i = 1:M  % all rows
        DTV = DT(i ,:) ;  %copy row of distances
        idx = 1;
        js(1) = -max_dist;  % serves as stopping point
        ks(1) = 1;          % assume first (possibly dummy) contributor
        m = 1;              % take parabola at first column (if any) as given

        while m < L  % look for next contributor
            m = m + 1;
            if DTV(m) < max_dist
                mm = m * m;
                % compute intersection with previous contributor
                k = ks(idx); % position of previous
                j = ceil((DTV(m) - DTV(k) - k*k + mm)/(2*(m - k)));

                while j <= js(idx)  % new parabola hides previous
                    idx = idx - 1;  % go one element back
                    k = ks(idx);    % position of previous
                    % compute intersection with previous contributor
                    j = ceil((DTV(m) - DTV(k) - k*k + mm)/(2*(m - k)));
                end  % End of while j <= js(idx)

                if j <= L  % make sure that new parabola contributes
                           % inside matrix
                    idx = idx + 1;  % store parameters in next elements
                    js(idx) = max(1, j);  % save new intersection,
                                          % keep it inside range
                    ks(idx) = m;  % save column of next contributor
                end  % End of if j <= L
            end  % End of if DTV(m) < max_dist
        end  % End of while m < L

        js(1) = 1;         % left border of contribution
        js(idx+1) = L + 1; % right border of contribution

        % now apply collected information (lower envelop)
        for n = 1:idx  % for all stored contributors
            k = ks(n);  % column of contributor
            for j = js(n) : js(n+1) - 1  % get region of contribution
                DT(i , j) = DTV(k) + (j - k) * (j - k); % assign distance
            end  % End of for j = js(n) : js(n+1) − 1
        end  % End of for n = 1:idx
    end  % End of for i = 1:M
end  % End of function fast_eedt_2d

% End of file 'fast_eedt_2d.m'