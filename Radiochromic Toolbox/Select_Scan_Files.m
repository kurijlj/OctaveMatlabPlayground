function csfp = Select_Scan_Files(varargin)
    %% -------------------------------------------------------------------------
    %%
    %% Function: Select_Scan_Files(dt, flt)
    %%
    %% -------------------------------------------------------------------------
    %
    %  Use:
    %       -- csfp = Select_Scan_Files()
    %       -- csfp = Select_Scan_Files(dt)
    %       -- csfp = Select_Scan_Files(dt, flt)
    %
    %% Description:
    %       Return a cell array containig absolute paths to the selected scan
    %       files. It invokes 'uigetfile' function to provide GUI interface for
    %       multiple files selection. If 'Cancel' is selected, empty cell array
    %       is returned.
    %
    %% Function parameters:
    %       - dt:  string, def. 'Select Scan Files'
    %              Can be used to customize the dialog title.
    %       - flt: two-column cell array of strings, def. {'*.tif',
    %              'Radiochromic Film Scan'}
    %              Two-column cell array containing a list of file extensions
    %              and file descriptions pairs. See the help on 'uigetfile' for
    %              detail description.
    %
    %% Return:
    %       - csfp: cell array of strings containing absolute paths to the
    %               selected scan files
    %
    %% Examples:
    %       >> Select_Scan_Files()
    %       ans =
    %           {
    %             [1,1] = Scan_1.tif
    %             [1,2] = Scan_2.tif
    %             ...
    %           }
    %
    %       >> Select_Scan_Files('Select scan files')
    %       ans =
    %           {
    %             [1,1] = Scan_1.tif
    %             [1,2] = Scan_2.tif
    %             ...
    %           }
    %
    %       >> Select_Scan_Files('Select files', {'*.tif', 'Scan File'})
    %       ans =
    %           {
    %             [1,1] = Scan_1.tif
    %             [1,2] = Scan_2.tif
    %             ...
    %           }
    %
    %       >> Select_Scan_Files('Select files', {'*.tif', 'TIF File'; '*.jpg',
    %       'JPG File'})
    %       ans =
    %           {
    %             [1,1] = Scan_1.tif
    %             [1,2] = Scan_2.tif
    %             [1,3] = Scan_3.jpg
    %             [1,4] = Scan_4.jpg
    %             ...
    %           }
    %
    %% (C) Copyright 2023 Ljubomir Kurij
    %
    %% -------------------------------------------------------------------------
    fname = 'Select_Scan_Files';
    use_case_a = sprintf(' -- csfp = %s()', fname);
    use_case_b = sprintf(' -- csfp = %s(dt)', fname);
    use_case_c = sprintf(' -- csfp = %s(dt, flt)', fname);

    % Check input parameters ---------------------------------------------------

    % Check number of input parameters
    if 2 < nargin
        % Invalid call to function
        error( ...
              'Invalid call to %s. Correct usage is:\n%s\n%s\n%s', ...
              fname, ...
              use_case_a, ...
              use_case_b, ...
              use_case_c ...
             );

    elseif 2 == nargin
        % User supplied value for the dialog title and file filter
        dt = varargin{1};
        flt = varargin{2};

    elseif 1 == nargin
        % User supplied value for the dialog title
        dt = varargin{1};
        flt = {'*.tif', 'Radiochromic Film Scan'};

    else
        % User did not supply any value
        dt = 'Select Scan Files';
        flt = {'*.tif', 'Radiochromic Film Scan'};

    end  % End of if 2 < nargin

    % Check input parameters types

    % Validate value supplied for the dialog name
    if ~ischar(dt) || isempty(dt)
        error('%s: must be a nonempty string', 'dt');

    end  % End of if ~ischar(dt) || isempty(dt)

    % Validate values supplied for the file filter
    if isempty(flt)
        error('%s: must be a nonempty cell array', 'flt');

    else
        if ~iscell(flt)
            error('%s: must be a cell array', 'flt');

        end  % End of if ~iscell(flt)

        if 2 > size(flt, 2)
            error('%s: must be a two column cell array', 'flt');

        end  % End of if 2 > size(flt, 2)

        idx = 1;
        while size(flt, 1) >= idx
            if ~ischar(flt{idx, 1}) || isempty(flt{idx, 1})
                error('%s[%d, 1] must be a nonempty string', 'flt', idx);

            end  % End of if ~ischar(flt{idx, 1})

            if ~ischar(flt{idx, 2}) || isempty(flt{idx, 2})
                error('%s[%d, 2] must be a nonempty string', 'flt', idx);

            end  % End of if ~ischar(flt{idx, 1})

            ++idx;

        end  % End of while size(flt, 1) >= idx

    end  % End of if isempty(flt)

    % Do the work --------------------------------------------------------------

    % Initialize return variables to default values
    csfp = {};

    % Invoke 'uigetfile' function to provide GUI interface for multiple files
    % selection
    [sfp, dir] = uigetfile(flt, dt, 'MultiSelect', 'on');

    if ~isequal(0, sfp) && ~isequal(0, dir)
        % User selected some files. Reconstruct absolute paths

        % Check if user selected more than one file
        if ~iscell(sfp)
            % User selected single file
            csfp{end + 1} = fullfile(dir, sfp);

        else
            % User selected more than one file
            idx = 1;
            while length(sfp) >= idx
                csfp{end + 1} = fullfile(dir, sfp{idx});
                idx = idx + 1;

            end  % End of while length(sfp) >= idx

        end  % ~iscell(sfp)

    end  % ~isequal(0, sfp) && ~isequal(0, dir)

end  % End of function Select_Scan_Files

% End of file Select_Scan_Files.m
