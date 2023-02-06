# FROM l.gcr.io/google/bazel:2.2.0
# FROM l.gcr.io/google/bazel:latest
FROM gcr.io/bazel-public/bazel:latest

RUN apt-get update -y && \
   apt-get upgrade -y && \
   apt-get dist-upgrade -y && \
   apt-get install software-properties-common -y && \
   add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
   apt-get update -y && \
   apt-get -y --no-install-recommends --allow-unauthenticated install \
   build-essential \
   apt-utils \
   gcc-11 \
   g++-11 \
   libstdc++-10-dev \
   unzip \
   wget \
   llvm-3.5 \
   clang-3.5 \
   apt-transport-https \
   ca-certificates \
   xz-utils \
   curl \
   && \
   update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 60 --slave /usr/bin/g++ g++ /usr/bin/g++-11 && \
   update-alternatives --config gcc
#    && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN clang --version && \
   curl -SL http://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz | tar -xJC .  && \
   cp -r clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/ /usr/local/clang-7.0.1  && \
   export LD_LIBRARY_PATH=/usr/local/clang-7.0.1/lib:$LD_LIBRARY_PATH && \
   export PATH=/usr/local/clang-7.0.1/bin:$PATH && \
   ldconfig && \
   curl -L -O -J https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip && \
   unzip commandlinetools-linux-8512546_latest.zip -d "/commandlinetools-linux-8512546_latest" && \
   export ANDROID_HOME="/commandlinetools-linux-8512546_latest" && \
   export PATH="$ANDROID_HOME/cmdline-tools/bin:/usr/local/bin/:$PATH" && \
   echo $PATH  && \
   yes | sdkmanager --sdk_root=$ANDROID_HOME --install "platform-tools" "platforms;android-29" "build-tools;29.0.3" "ndk-bundle" && \
   mkdir -p /src/workspace && \
   cd /src/workspace && \
   git clone --recursive https://github.com/google/fhir.git && \
   cd fhir && \
   echo "--cxxopt=-std=c++17" > ./.bazelrc && \
   git checkout v0.7.4 && \
   git submodule update --init --recursive && \
   bazel query @local_config_cc//:toolchain --output=build && \
   bazel build //cc/google/fhir/... --verbose_failures

VOLUME /src/workspace
VOLUME /tmp/build_output

### bazel build //absl/...
ENTRYPOINT [ "/bin/bash" ]
