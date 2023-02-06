FROM l.gcr.io/google/bazel:2.2.0

RUN apt-get update -y \ 
&& apt-get -y --no-install-recommends --allow-unauthenticated install \
   build-essential \
   gcc-10 \
   gcc-10-base \
   gcc-10-doc \
   g++-10 \
   libstdc++-10-dev \
   libstdc++-10-doc \
   unzip \
   wget \
   llvm-3.5 \
   clang-3.5 \
   apt-transport-https \
   ca-certificates \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# clang --version && \
   
RUN curl -L -O -J https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip && \
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
