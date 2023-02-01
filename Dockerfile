FROM l.gcr.io/google/bazel:latest

RUN apt-get update -y \ 
&& apt-get -y --no-install-recommends --allow-unauthenticated install \
   build-essential \
   unzip \
   llvm-3.3 \
   clang-3.3 \
   wget \
   apt-transport-https \
   ca-certificates \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN clang --version && \
   curl -L -O -J https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip && \
   unzip commandlinetools-linux-8512546_latest.zip -d "/commandlinetools-linux-8512546_latest" && \
   export ANDROID_HOME="/commandlinetools-linux-8512546_latest" && \
   export PATH="$ANDROID_HOME/cmdline-tools/bin:$PATH" && \
   yes | sdkmanager --sdk_root=$ANDROID_HOME --install "platform-tools" "platforms;android-29" "build-tools;29.0.3" "ndk-bundle" && \
   mkdir -p /src/workspace && \
   cd /src/workspace && \
   git clone --recursive https://github.com/google/fhir.git && \
   cd fhir && \
   git checkout v0.7.4 && \
   bazel build //cc/google/fhir/...

VOLUME /src/workspace
VOLUME /tmp/build_output

### bazel build //absl/...
ENTRYPOINT [ "/bin/bash" ]
