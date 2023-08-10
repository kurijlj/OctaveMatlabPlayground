# FoV Elements Subproject

Welcome to the **FoV Elements** subproject! This repository contains a
collection of algorithms and functions that focus on various aspects of working
with Field of View (FoV) manipulation and analysis. The primary objectives of
this subproject are outlined below:

## Objectives

1. **Computational FoV Generation Algorithm:**
   Develop an algorithm to generate a computational Field of View (FoV). This
   FoV will consist of a 2D pixel map with a predefined number of pixels and
   preset pixel values, resembling a checkerboard pattern.

2. **Reposition and Resize ROI Algorithm:**
   Implement a general algorithm to reposition and resize a given Region of
   Interest (ROI) bounding box within a provided FoV.

3. **Binary Mask Calculation Algorithm:**
   Design a general algorithm to calculate a binary mask representing the
   presence of the given ROI within the provided FoV.

4. **Plotting ROI Bounding Box Algorithm:**
   Develop a general algorithm to plot the bounding box of a given ROI over the
   plot of a FoV, providing a visual representation of their spatial
   relationship.

5. **Test Suite Development:**
   Create a comprehensive test suite that covers all the aforementioned
   algorithms. The tests should ensure the correctness and robustness of the
   implemented functions under various scenarios and edge cases.

## Contents

The subproject is structured as follows:

- **`./Make_Dummy_Fov.m`**: This file contains the source code for the
computational FoV generation mentioned above. The FoV is specified by its width
and height. Example:
   ```
   >> MakeDummyFov(30, 20)
   ```
creates a dummy FoV pixel map of 30 pixels wide and 20 pixels high.

- **`./Roi_2_Fov.m`**: This file contains the source code for the general
algorithm to reposition and resize a given Region of Interest bounding box
within provided FoV. Example:
   ```
   >> Roi_2_Fov(30, 20, 5, 5, 25, 15)
   ans =

       5
       5
      25
      15

   >>
   ```
creates a dummy FoV pixel map of 30 pixels wide and 20 pixels high.

- **`./Roi_2_Bw.m`**: This file contains the source code for the general
algorithm to calculate a binary mask representing the presence of the given ROI
within the provided FoV. Example:
   ```
   >> Roi_2_Bw(5, 5, 2, 2, 3, 3)
   ans =

      0   0   0   0   0
      0   1   1   1   0
      0   1   1   1   0
      0   1   1   1   0
      0   0   0   0   0

>>
   ```

- **`./Roi_2_Plot.m`**: This file contains the source code for the general
algorithm to plot the bounding box of a given ROI over the plot of a FoV,
providing a visual representation of their spatial relationship. Example:
   ```
   >> hfig = figure();
   >> hax = axes('parent', hfig);
   >> Roi_2_Plot(hax, 10, 10, 50, 50)
   >> Roi_2_Plot(hax, 10, 10, 50, 50, 'color', 'g')
   ```

- **`./Test_Fov_Elements.m`**: This file contains the source code for the test
suite that covers all the aforementioned algorithms. To see the test results
execute:
   ```
   >> Test_Fov_Elements.m
   ```

## Getting Started

To get started with using the FoV Elements subproject, follow these steps:

1. Clone this repository to your local machine:
   ```
   git clone [repository_url]
   ```

2. Navigate to the `FoV Elements/` directory to explore and utilize the
algorithms implemented for FoV manipulation.

3. If you're interested in testing the algorithms, execute `Test_Fov_Elements.m`
from within Octave/Matlab environment.