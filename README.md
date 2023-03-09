# System Identification

The purpose of this project is to identify the mathematical model of a BLDC motor-driven axis. The data obtained from the experiment is used to obtain the transfer function of the system.

Matlab is used to visualize the experimental data. The "baci.mat" file is imported, which contains two fields, X and Y. The X vector represents the time domain, and the Y vector is composed of input (u'), angular velocity (w'), and angular position (th') values.
![untitled](https://user-images.githubusercontent.com/118546616/223975008-d3b19719-9645-4a5a-b516-40b78de9fe1b.jpg)


I used a step input to determine a transfer function that follows the BLDC motor axis and ploted it over the initial data 

![viteza-simulata-tot-sistem](https://user-images.githubusercontent.com/118546616/223975741-c2d7c73d-33d5-4ad6-b0ae-c02d8265feff.jpg)

After that i used parametric methods to determine a more concise transfer function for all the relations between the inputs. I used autocorelation and intercorelation methods that resulted in a much better estimation of the transfer function.

