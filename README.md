# hvnea
HVNEA (HV Noise and Earthquake Automatic analysis) is a software package to automatically 
compute the horizontal-to-vertical spectral ratios (HV) on earthquakes and ambient noise vibrations.
This package makes extensive use of third party programs, such as Geopsy, Gsac, ImageMagick, GMT, others;
so for your convenience we also make it available as a docker image.

Gsac is part of the software CPS (Computer Programs in Seismology, https://www.eas.slu.edu/eqc/eqc_cps/CPS/CPS330.html),
and is used here by courtesy of professor R. B. Herrmann, Department of Earth and Atmospheric Sciences Saint Louis University.

Geopsy is one of the central components of HVNEA processing;
it is developed and mantained by Geopsy team (https://www.geopsy.org/index.html)

ImageMagick (https://imagemagick.org/) is provided by ImageMagick Studio LLC;
it is distributed under the license at https://imagemagick.org/script/license.php,
so the package HVNEA includes this license.

Installation on Linux and Mac
1) make sure you have installed all necessary third party programs
2) unpack the HVNEA.yyyymmdd.tar.gz file in a directory contained in the system environment variable PATH
3) edit the configuration files in the "conf" directory as needed

Use with Docker
1) first time:
- copy the Docker image to your machine or create the Docker image by yourself using the dockerfile "Dockerfile"
and the software version in HVNEA.yyyymmdd.docker.tar.gz;
this version is different from that in HVNEA.yyyymmdd.tar.gz in that it uses gsac instead of sac
- load it into the Docker engine
- create a Docker container running the image
2) next times:
- just run the existing container
