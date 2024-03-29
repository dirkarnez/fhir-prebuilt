# FROM l.gcr.io/google/bazel:2.2.0
# FROM l.gcr.io/google/bazel:latest
# FROM gcr.io/bazel-public/bazel:latest

FROM ubuntu:20.04

# RUN apt-get update && \
#       apt-get -y install sudo

# RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# USER docker
RUN apt-get update -y && \
   apt-get upgrade -y && \
   apt-get dist-upgrade -y && \
   apt-get install software-properties-common -y && \
   add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
   apt-get update -y && \
   apt-get -y --no-install-recommends --allow-unauthenticated install \
   build-essential \
   git \
   apt-utils \
   gcc-11 \
   g++-11 \
   libstdc++-11-dev \
   zip \
   unzip \
   wget \
   openjdk-17-jdk \
   apt-transport-https \
   ca-certificates \
   xz-utils \
   curl \
   && \
   update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 60 --slave /usr/bin/g++ g++ /usr/bin/g++-11 && \
   update-alternatives --config gcc \
   && \
   apt-get clean && \
   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -SL http://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz | tar -xJC .  && \
   cp -r clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/ /usr/local/clang-7.0.1  && \
   export LD_LIBRARY_PATH=/usr/local/clang-7.0.1/lib:$LD_LIBRARY_PATH && \
   export PATH=/usr/local/clang-7.0.1/bin:$PATH && \
   ldconfig

RUN cd /usr/local/bin/ && \
   curl https://github.com/bazelbuild/bazel/releases/download/4.0.0/bazel-4.0.0-linux-x86_64 -L --output bazel && \
   chmod +x bazel
   
RUN curl -L -O -J https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip && \
   unzip commandlinetools-linux-8512546_latest.zip -d "/commandlinetools-linux-8512546_latest" && \
   export ANDROID_HOME="/commandlinetools-linux-8512546_latest" && \
   export PATH="$ANDROID_HOME/cmdline-tools/bin:/usr/local/bin/:$PATH" && \
   sdkmanager --list --sdk_root=$ANDROID_HOME && \
   yes | sdkmanager --sdk_root=$ANDROID_HOME --install "platform-tools" "platforms;android-29" "build-tools;30.0.3"

RUN mkdir -p /src/workspace
VOLUME mkdir -p /tmp/build_output

VOLUME /src/workspace
VOLUME /tmp/build_output

CMD cd /src/workspace && \
   git clone --recursive https://github.com/google/fhir.git && \
   cd fhir && \
   echo "build --cxxopt -std=c++17" > ./.bazelrc && \
   git checkout v0.7.4 && \
   git submodule update --init --recursive && \
   bazel --output_base=/tmp/build_output build //cc/google/fhir/... --verbose_failures && \
   cd /tmp/build_output && \
   zip --symlinks -r fhir-v0.7.4.zip . && \
   exit
