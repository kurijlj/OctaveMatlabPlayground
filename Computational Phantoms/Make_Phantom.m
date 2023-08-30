function Make_Phantom()

% Load required packages
pkg load dicom;
pkg load image;

% Create a DICOM header structure
dcm = dicomdict('set', 'dicom-dict.txt');

% Set patient information
patientLastName = "YourLastName";
patientFirstName = "YourFirstName";
patientSex = "M"; % "M" for male, "F" for female
patientBirthday = "YYYYMMDD"; % Format: YearMonthDay (e.g., 19900101 for January 1, 1990)

% Set image properties
pixelSpacing = [1, 1];
sliceThickness = 2;
imageDimensions = [256, 256, 64]; % Width x Height x Slices

    for slice = 1:imageDimensions(3)
        % Create a blank DICOM image
        dicomImage = zeros(imageDimensions(1:2));

        % Populate dicomImage with your 3D matrix data for the current slice

        % Set DICOM header attributes
        dicomImage = uint16(dicomImage);
        dicomHeader = dicominfo('MRBRAIN.DCM'); % Load a template DICOM header or create one
        dicomHeader.PatientName.FamilyName = patientLastName;
        dicomHeader.PatientName.GivenName = patientFirstName;
        dicomHeader.PatientSex = patientSex;
        dicomHeader.PatientBirthDate = patientBirthday;
        dicomHeader.PixelSpacing = pixelSpacing;
        dicomHeader.SliceThickness = sliceThickness;

        % Save DICOM image
        dicomwrite( ...
                   dicomImage, ...
                   sprintf("MRI_slice_%03d.dcm", slice), ...
                   dicomHeader, ...
                   'dictionary', ...
                   dcm ...
                  );

    end

end  % End of function Make_Phantom

% End of file Make_Phantom.m