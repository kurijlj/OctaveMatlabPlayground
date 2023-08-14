classdef Film_Scan
    %% -------------------------------------------------------------------------
    %%
    %% Class: Film_Scan
    %%
    %% -------------------------------------------------------------------------
    %
    %% Description:
    %       - This class is used to store the information of a radiochromic film
    %         scan.
    %
    %% Properties:
    %       - date_of_irradiation: serial date number (see: datenum), def. NaN
    %             Date of irradiation of the film, if known. The date of
    %             irradiation must be no older than 01-Jan-2000.
    %
    %       - date_of_scan: serial date number (see: datenum), def. now
    %             Date of the scan of the film, if known. If reading pixel
    %             values from a film scan, this property is set to the value
    %             read from the file metadata, or to the current date and time
    %             if no metadata is available. If the scan is created manually,
    %             this property is set to the user defined value, or to the
    %             current date and time if no value is given.
    %
    %       - film_lot_number: string, def. 'none'
    %             LOT number of the film used for the measurement.
    %
    %       - film_type: 'EBT3'|'EBT4'|'EBT3P'|'EBT-XD'|'HD-V2'|'MD-V3'|...
    %             'RTQA2-1010'|'RTQA2-111'|'RTQA2-1417'|'XR-CT3'|'XR-RV3'|...
    %             'XR-M3'|'LD-V1', def. 'EBT3'
    %             Type of the film used for the measurement. For the most up to
    %             date list of available film types, refer to Ashland's
    %             radiotherapy films website (https://www.ashland.com).
    %
    %       - irradiation_type: 'Proton'|'Photon'|'Electron'|'Neutron'|...
    %             'HeavyIon'|'Unknown', def. 'Unknown'
    %             Type of the radiation used for the irradiation of the film.
    %
    %       - pixel_values: double matrix, def. NaN
    %             Matrix of pixel values of the scan. The pixel values are
    %             stored as double values in the range of 0 to 65535. The pixel
    %             values are read from the scan file, or from the user defined
    %             matrix if the scan is created manually.
    %
    %       - scan_file_name: string, def. 'none'
    %             Absolute path to the scan file. If the scan is created from
    %             the pixel_values matrix, this property is set to 'none'.
    %
    %       - scan_resolution: double, def. 0
    %             Resolution of the scan in dpi (dots per inch) or dpcm (dots
    %             per centimeter). Used to properly scale the scan to the
    %             correct size. The resolution is determined from the metadata
    %             of the tif file, if available. If no metadata is available,
    %             the resolution is set to user defined value, or to the
    %             default value of 'none' if no value is given. If the scan is
    %             created from the pixel_values matrix, the resolution is set
    %             to user defined value, or to the default value of 'none' if
    %             no value is given.
    %
    %       - scan_resolution_unit: 'dpi'|'dpcm', def. 'none'
    %             Unit of the scan resolution. Used to properly scale the scan
    %             to the correct size. The resolution unit is determined from
    %             the metadata of the tif file, if available. If no metadata is
    %             available, the resolution unit is set to user defined value,
    %             or to the default value of 'none' if no value is given. If
    %             the scan is created from the pixel_values matrix, the
    %             resolution unit is set to user defined value, or to the
    %             default value of 'none' if no value is given.
    %
    %       - scan_title: string, def. 'Film Scan'
    %             Title of the scan (e.g. 'Film Scan 1'). Used to identify the
    %             scan during analysis.
    %
    %       - scan_type: 'Control'|'DeadPixels'|'DummyDeadPixels'|...
    %             'DummyControl'|'DummyIrradiated'|'DummyZeroL'|'Irradiated'|...
    %             'ZeroL'|'Unknown', def. 'Unknown'
    %             Type of the film scan. This property determines how the scan
    %             object is going to be handled by the Net_Optical_Density and
    %             Normalized_Pixel_Value classes. The following types are
    %             available:
    %               - 'Control': A control scan, i.e. a scan of an unirradiated
    %                 film piece. The scan is used to determine any change in
    %                 the film LOT absorbance due to environmental conditions,
    %                 e.g., temperature, visible light, humidity, scanning
    %                 light, etc. this control film piece must be of the same
    %                 shape and size as the irradiated film pieces that are used
    %                 for the actual dose measurement. Ref: Slobodan Devic,
    %                 Radiochromic film dosimetry: Past, present, and future,
    %                 Physica Medica, Volume 27, Issue 3, 2011, Pages 122-134,
    %                 ISSN 1120-1797,
    %                 https://doi.org/10.1016/j.ejmp.2010.10.001.
    %
    %               - 'DeadPixels': A scan object with calculated dead pixels
    %                 for the given film piece. The dead pixels are calculated
    %                 from the control scan.
    %
    %               - 'DummyDeadPixels': A scan object with calculated dead
    %                 pixels for the given dummy control film piece. The dead
    %                 pixels are calculated from the dummy control scan.
    %               - 'DummyControl': A dummy control scan, generated from the
    %                 given pixel values. The dummy control scan is used to
    %                 test various algorithms for analysis and pixel value
    %                 manipulation in conjunction with the dummy irradiated
    %                 scan and the dummy zero light scan.
    %
    %               - 'DummyIrradiated': A dummy irradiated scan, generated
    %                 from the given pixel values. The dummy irradiated scan is
    %                 used to test various algorithms for analysis and pixel
    %                 value manipulation in conjunction with the dummy control
    %                 scan and the dummy zero light scan.
    %
    %               - 'DummyZeroL': A dummy zero light scan, generated from the
    %                 given pixel values. The dummy zero light scan is used to
    %                 test various algorithms for analysis and pixel value
    %                 manipulation in conjunction with the dummy control scan
    %                 and the dummy irradiated scan.
    %
    %               - 'Irradiated': An irradiated scan, i.e. a scan of an
    %                 irradiated film piece. The scan is used to read out the
    %                 dose distribution in the film piece. The irradiated film
    %                 piece must be of the same shape and size as the control
    %                 film piece. See also 'Control' for more information.
    %
    %               - 'ZeroL': A zero light scan, i.e. a scan of an zero-light
    %                 transmitted intensity value, which characterizes the
    %                 background signal of the scanner. The zero light scan is
    %                 determined over the same ROI with an opaque piece of
    %                 film. The zero light scan is used to correct the
    %                 irradiated scan for the background signal of the scanner.
    %                 Ref: Devic, S., Seuntjens, J., Sham, E., Podgorsak, E.B.,
    %                 Schmidtlein, C.R., Kirov, A.S. and Soares, C.G. (2005),
    %                 Precise radiochromic film dosimetry using a flat-bed
    %                 document scanner. Med. Phys., 32: 2245-2253.
    %                 https://doi.org/10.1118/1.1929253
    %
    %               - 'Unknown': The type of the scan is unknown. This type is
    %                 used as convienience for scans that are not used for
    %                 analysis, e.g. a scan of a film piece that is not used for
    %                 the dose measurement.
    %
    %
    %% Constructor parameters:
    %       - tif_file: string
    %             Absolute path to the tif file of the scan. The tif file must
    %             be a 16-bit color image (RGB). The pixel values are converted
    %             to double precision floating point numbers (double) before
    %             further processing. If the tif_file is given, the
    %             pixel_values matrix must not be given. Otherwise, an error is
    %             reported.
    %
    %       - pixel_values: double matrix
    %             Matrix of the pixel values of the scan. Used to support the
    %             creation of dummy (computational) scans. The pixel_values
    %             matrix must be a 3D matrix of size [height, width, 3], where
    %             the third dimension represents the RGB color channels. The
    %             pixel values must be in the range of 0 to 65535. The pixel
    %             values are converted to double precision floating point number
    %             (double) before further processing. If the pixel_values
    %             matrix is given, the tif_file must not be given. Otherwise,
    %             an error is reported.
    %
    %       - Title: string, def. 'Film Scan'
    %             Title of the scan (e.g. 'Film Scan 1'). See 'scan_title'
    %             property for more information.
    %
    %       - DateOfIrradiation: serial date number (see: datenum), def. NaN
    %             Date of irradiation of the film. See 'date_of_irradiation'
    %             property for more information.
    %
    %       - DateOfScan: serial date number (see: datenum), def. now
    %             Date of the scan of the film. See 'date_of_scan' property
    %             for more information.
    %
    %       - Type: 'Control'|'DeadPixels'|'DummyDeadPixels'|'DummyControl'|
    %             |'DummyIrradiated'|'DummyZeroL'|'Irradiated'|'ZeroL'|
    %             |'Unknown', def. 'Unknown'
    %             Type of the scan. See 'scan_type' property for more
    %             information.
    %
    %       - Smoothing: Pixel_Value_Smoothing object,
    %             def. Pixel_Value_Smoothing('Method', 'None')
    %             Pixel value smoothing object. The smoothing object is used to
    %             smooth the pixel values of the scan. The smoothing object
    %             must be of the class Pixel_Value_Smoothing. For more
    %             information see the Pixel_Value_Smoothing class.
    %
    %       - Resolution: double, def. 400
    %             Resolution of the scan in dots per inch (dpi). See
    %             'scan_resolution' property for more information.
    %
    %       - ResolutionUnit: 'dpi'|'dpcm', def. 'dpi'
    %             Unit of the scan resolution. See 'scan_resolution_unit'
    %             property for more information.
    %
    %% Public methods:
    %
    %       - obj = Film_Scan(varargin): Class constructor.
    %
    %
    %% (C) Copyright 2023 Ljubomir Kurij
    %
    %% -------------------------------------------------------------------------


end  % End of classdef Film_Scan

% End of file Film_Scan.m