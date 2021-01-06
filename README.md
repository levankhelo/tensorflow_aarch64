# tensorflow_aarch64
Tensorflow for aarch64

## How to build tensorflow for aarch64
1. Read Tensorflow documentation about the build process [see here](https://www.tensorflow.org/install/source_rpi)
2. Clone Tensorflow repository
```
$ git clone https://github.com/tensorflow/tensorflow.git
$ cd tensorflow
```
3. Checkout and cross-compile Tensorflow on a x86 machine. Tensorflow isn't made (for now) to be able to compile on an ARM machine due to the bazel version used. This version is not compatible with any ARM processor. It is also quicker to cross-compile since it requires time (at least 6 hours for a 6C/12T processor).
```
$ git checkout branch_name  # r1.9, r1.10, etc.
$ tensorflow/tools/ci_build/ci_build.sh PI-PYTHON38 tensorflow/tools/ci_build/pi/build_raspberry_pi.sh AARCH64
```
4. You'll find all the compiled files in the output-artifacts directory. This reposirtory only focuses on the wheel package for python but there is also shared object files that are being generated for C/C++ development. You've got 3 options here :
  4.1 Get the image from DockerHub [https://hub.docker.com/r/flodutot/tensorflow_aarch64](https://hub.docker.com/r/flodutot/tensorflow_aarch64)
  4.2 Build the ARM64 compatible docker image from an ARM64 machine. To do that way, copy the wheel package in the Dockerfiles directory and send everything to the host machine. Then run the following command : 
  ```
  $ docker build --pull --rm -f "Dockerfiles/cpu-jupyter.Dockerfile" -t tensorflowaarch64:cpu-jupyter "Dockerfiles" --build-arg TF_PACKAGE_VERSION=branch_name
  or
  $ docker build --pull --rm -f "Dockerfiles/cpu.Dockerfile" -t tensorflowaarch64:cpu "Dockerfiles" --build-arg TF_PACKAGE_VERSION=branch_name
  ```
  4.3 You can also cross-build the ARM64 image on an x86 machine with the QEMU integration in Docker using the command ```docker buildx```


Good luck and have fun!
