FROM shrippa/colmap:1.7



# Build and install ceres solver
# Checkout the latest release
ARG CERES_SOLVER_COMMIT=facb199f3e
RUN apt-get -y install libatlas-base-dev libsuitesparse-dev 
RUN git clone https://ceres-solver.googlesource.com/ceres-solver
RUN cd ceres-solver && \
    git checkout  "${CERES_SOLVER_COMMIT}"  &&\  
	mkdir build && \
	cd build && \
	cmake .. -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF && \
	make -j2 && \
	make install

# compile colmap
RUN git clone https://github.com/colmap/colmap.git && \
    cd colmap && \
    git checkout dev && \
    mkdir build && \
    cd build &&\
    cmake .. &&\
    make -j2 && \
    make install

RUN apt-get update -y
RUN apt-get install python3 python3-pip unzip wget -y

RUN pip3 install --upgrade pip

# Install pycolmap from source
RUN git clone --recursive https://github.com/colmap/pycolmap.git
RUN cd pycolmap &&  \
    pip3 install .

# Install detectron2 from source
# This will by default build detectron2 for all common cuda architectures and take a lot more time,
# because inside `docker build`, there is no way to tell which architecture will be used.
# RUN pip3 install detectron2 -f https://dl.fbaipublicfiles.com/detectron2/wheels/cu102/torch1.10/index.html


COPY . /workdir
WORKDIR /workdir/


RUN pip3 install -r requirements.txt

# RUN pip3 install pycolmap
RUN pip3 install jupyterlab notebook
RUN pip3 install ipywidgets
