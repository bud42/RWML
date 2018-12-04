FROM ubuntu:trusty

RUN apt-get update -qq && apt-get install -yq --no-install-recommends  \
        apt-utils bzip2 ca-certificates curl unzip xorg wget xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && localedef --force --inputfile=en_US --charmap=UTF-8 C.UTF-8 \
    && chmod 777 /opt && chmod a+s /opt

# Install packages required by dax
RUN apt-get update && apt-get install -y \
    python-pip libfreetype6-dev pkg-config libxml2-dev libxslt1-dev \
    python-dev zlib1g-dev python-numpy python-scipy python-requests \
    python-urllib3 python-pandas

# Install dax 
RUN pip install matplotlib==2.2.2
RUN pip install dax==0.8.0

# Install FSL
RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    bc dc libfontconfig1 libfreetype6 libgl1-mesa-dev libglu1-mesa-dev \
    libgomp1 libice6 libxcursor1 libxft2 libxinerama1 libxrandr2 libxrender1 libxt6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "Downloading FSL ..." \
    && curl -sSL --retry 5 https://www.dropbox.com/s/jlv3ye9n0zzwmjj/fsl-5.0.10-centos6_64.tar.gz \
    | tar zx -C /opt \
    && /bin/bash /opt/fsl/etc/fslconf/fslpython_install.sh -q -f /opt/fsl
ENV FSLDIR=/opt/fsl \
    PATH=/opt/fsl/bin:$PATH
    
# Install FreeSurfer v6.0.1
RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    bc libgomp1 libxmu6 libxt6 tcsh perl tar perl-modules \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "Downloading FreeSurfer ..." \
    && curl -sSL --retry 5 \
    https://www.dropbox.com/s/ncog7pqnyor40pu/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.1-MinimumForDocker.tgz \
    | tar xz -C /opt
ENV FREESURFER_HOME=/opt/freesurfer

# Install packages needed to use freeview
RUN apt-get update && apt-get install -y \
libjpeg62 libglu1-mesa libqt4-opengl libqt4-scripttools

# Configure environment
ENV FSLDIR=/opt/fsl
ENV FSLOUTPUTTYPE=NIFTI_GZ
ENV PATH=/usr/lib/fsl/5.0:$PATH
ENV FSLMULTIFILEQUIT=TRUE
ENV POSSUMDIR=/opt/fsl
ENV LD_LIBRARY_PATH=/opt/fsl:$LD_LIBRARY_PATH
ENV FSLTCLSH=/usr/bin/tclsh
ENV FSLWISH=/usr/bin/wish
ENV FSLOUTPUTTYPE=NIFTI_GZ
ENV OS Linux
ENV FS_OVERRIDE 0
ENV FIX_VERTEX_AREA=
ENV SUBJECTS_DIR /opt/freesurfer/subjects
ENV FSF_OUTPUT_FORMAT nii.gz
ENV MNI_DIR /opt/freesurfer/mni
ENV LOCAL_DIR /opt/freesurfer/local
ENV FREESURFER_HOME /opt/freesurfer
ENV FSFAST_HOME /opt/freesurfer/fsfast
ENV MINC_BIN_DIR /opt/freesurfer/mni/bin
ENV MINC_LIB_DIR /opt/freesurfer/mni/lib
ENV MNI_DATAPATH /opt/freesurfer/mni/data
ENV FMRI_ANALYSIS_DIR /opt/freesurfer/fsfast
ENV PERL5LIB /opt/freesurfer/mni/lib/perl5/5.8.5
ENV MNI_PERL5LIB /opt/freesurfer/mni/lib/perl5/5.8.5
ENV PATH=$PATH:/opt/freesurfer/bin:/opt/freesurfer/fsfast/bin:/opt/freesurfer/tktools:/opt/freesurfer/mni/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PYTHONPATH=""
ENV FS_LICENSE=/opt/license.txt
RUN touch /opt/license.txt

# Install packages needed make screenshots
RUN apt-get update && apt-get install -y \
    imagemagick ghostscript libgs-dev \
    && apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Make sure other stuff is in path
COPY src /opt/src/
RUN chmod +x /opt/src/main.sh
ENV PATH=/opt/src:$PATH

# Make directories for I/O to bind
RUN mkdir /INPUTS /OUTPUTS

# Get the spider code
COPY spider.py /opt/spider.py
ENTRYPOINT ["python", "/opt/spider.py"]

# Silly fix for ImageMagick
COPY policy.xml /etc/ImageMagick/policy.xml
