# hvnea

HVNEA (HV Noise and Earthquake Automatic analysis) is a software package to automatically compute the horizontal-to-vertical spectral ratios (HV) on earthquakes and ambient noise vibrations. This package makes extensive use of third party programs, such as Geopsy, Gsac, Gnuplot, GMT, others; so for your convenience we also make it available as a docker image. The package has been successfully tested on the operating systems Ubuntu 20.04, Ubuntu 22.04, Debian 10 and Debian 11, with the program versions listed below. The operating system used for the Docker image is Ubuntu 20.04; many of the programs necessary for HVNEA to work have been installed with the apt utility.

List of third party programs and their version:

Geopsy is one of the central components of HVNEA processing; it is developed and mantained by Geopsy team (https://www.geopsy.org/index.html); version used here is 3.4.1.

Gsac (V1.1.5l) is part of the software CPS (Computer Programs in Seismology, https://www.eas.slu.edu/eqc/eqc_cps/CPS/CPS330.html),
and is used here by courtesy of professor R. B. Herrmann, Department of Earth and Atmospheric Sciences of Saint Louis University.

Qt is needed for building and running Geopsy; the version we used is 5.14.2, and we took it from Stephan Binner's personal repository ppa:beineri/opt-qt-5.14.2-focal (https://launchpad.net/~beineri/+archive/ubuntu/opt-qt-5.14.2-focal).

Gnuplot is one of the most widespread graphing utilities; here we used version 5.2.8, but using a newer version would probably not cause any problems.

GMT (Generic Mapping Tools, https://www.generic-mapping-tools.org/) is a suite of tools widely used in Earth, Ocean and Planetary sciences, and more. For this package we use version 6 (GMT 6: Wessel, P., Luis, J. F., Uieda, L., Scharroo, R., Wobbe, F., Smith, W. H. F., & Tian, D. (2019). The Generic Mapping Tools version 6. Geochemistry, Geophysics, Geosystems, 20, 5556–5564. Https://doi.org/10.1029/2019GC008515).

qlib2 et al. ...

rdseed ...

pyrocko ...

msi ...

tex live ...

jq ...

Docker ...

Installation (on Linux and Mac)
- download the distribution file HVNEA.yyyymmdd.tar.gz
- unpack it in the directory where you want to install
- edit the configuration files in the "conf" directory as needed
- add the installation directory to your environment variable PATH
- make sure you have installed all necessary third party programs

Use with Docker
- First time:
copy the Docker image to your machine or create the Docker image by yourself using the dockerfile "Dockerfile" and the software version in HVNEA.yyyymmdd.docker.tar.gz (this version is different from that in HVNEA.yyyymmdd.tar.gz in that it uses gsac instead of sac); load it into the Docker engine; create a Docker container running the image
- Next times:
just run the existing container

[Dockerimage](https://hub.docker.com/r/ingv/hvnea)
