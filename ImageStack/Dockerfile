FROM scientificlinux/sl:7

RUN yum install -y \
        wget unzip \
        libXt libXext libXmu libXrender libXcomposite

# install Matlab-2019a
WORKDIR /mcr-install
RUN wget https://ssd.mathworks.com/supportfiles/downloads/R2019a/Release/5/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2019a_Update_5_glnxa64.zip
RUN unzip MATLAB_Runtime_R2019a_Update_5_glnxa64.zip
RUN ./install -mode silent -agreeToLicense yes

WORKDIR /app
RUN rm -rf /mcr-install

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:\
/usr/local/MATLAB/MATLAB_Runtime/v96/runtime/glnxa64:\
/usr/local/MATLAB/MATLAB_Runtime/v96/bin/glnxa64:\
/usr/local/MATLAB/MATLAB_Runtime/v96/sys/os/glnxa64:\
/usr/local/MATLAB/MATLAB_Runtime/v96/sys/opengl/lib/glnxa64:\
/usr/local/MATLAB/MATLAB_Runtime/v96/sys/java/jre/glnxa64/jre/lib/amd64/server:\
/usr/local/MATLAB/MATLAB_Runtime/v96/sys/java/jre/glnxa64/jre/lib/amd64
ENV XAPPLRESDIR=/usr/local/MATLAB/MATLAB_Runtime/v96/X11/app-defaults
ENV MCR_CACHE_VERBOSE=true
# inhibit ctf lock since we are not embedding the archive in the executable
ENV MCR_INHIBIT_CTF_LOCK=1

# Copy the entrypoint script
COPY src/scripts/entrypoint.sh /app
COPY bin/ImageStack.ctf /app
COPY bin/ImageStack /app

RUN chmod 555 /app/ImageStack.ctf
RUN chmod 755 /app/entrypoint.sh /app/ImageStack

# dummy run in order to create the MCR CACHE
RUN /app/ImageStack || true

ENTRYPOINT [ "/app/entrypoint.sh" ]
