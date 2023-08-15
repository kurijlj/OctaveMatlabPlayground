function [A, V, H, D, info] = ufwt_2D(f, w, J, scaling = 'sqrt')
    % --------------------------------------------------------------------------
    %
    % Function: ufwt_2D(f, w, J, scaling)
    %
    % --------------------------------------------------------------------------
    %
    % Use:
    %       -- [A, V, H, D, info] = ufwt_2D(f, w, J)
    %       -- [A, V, H, D, info] = ufwt_2D(f, w, J, scaling)
    %
    % Description:
    %       Compute the 2D undecimated wavelet transform of a 2D image f using
    %       the wavelet w and the number of scales J.
    %
    % Function parameters:
    %       -- f: 2D image
    %       -- w: wavelet filterbank
    %       -- J: number of filterbank iterations
    %       -- scaling: filter scaling flag (default: 'sqrt')
    %
    %       Note: For more information on the input parameters, please refer to
    %       the documentation of the ufwt function of the ltfat package.
    %
    % Return:
    %       -- A: residual approximation coefficients stored in L x W matrix.
    %       -- V: vertical detail coefficients stored in
    %             J x filtNo - 1 x L x W matrix.
    %       -- H: horizontal detail coefficients stored in
    %             J x filtNo - 1 x L x W matrix.
    %       -- D: diagonal detail coefficients stored in
    %             J x filtNo - 1 x filtNo - 1 x L x W matrix.
    %       -- info: Transform parameters structure.
    %
    % Required packages:
    %       -- ltfat (http://ltfat.org/)
    %
    % Example:
    %       -- [A, V, H, D, info] = ufwt_2D(f, w, J)
    %       -- [A, V, H, D, info] = ufwt_2D(f, w, J, 'sqrt')
    %
    % Copyright (C) 2005-2022 Peter L. Soendergaard <peter@sonderport.dk>
    % and others.
    % Modifications Copyright (C) 2023 Ljubomir Kurij
    % <ljubomir_kurij@protonmail.com>.
    % This file is part of LTFAT version 2.5.0
    %
    % This program is free software: you can redistribute it and/or modify
    % it under the terms of the GNU General Public License as published by
    % the Free Software Foundation, either version 3 of the License, or
    % (at your option) any later version.
    %
    % This program is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU General Public License for more details.
    %
    % You should have received a copy of the GNU General Public License
    % along with this program.  If not, see <http://www.gnu.org/licenses/>.
    %
    % --------------------------------------------------------------------------

end  % End of function ufwt_2D

% End of file ufwt_2D.m