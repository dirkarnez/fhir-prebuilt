FROM l.gcr.io/google/bazel:latest

RUN apt-get update -y \ 
&& apt-get -y --no-install-recommends install \
   build-essential \
   unzip \
#    android-sdk \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -L -O -J https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip && \
   unzip commandlinetools-linux-8512546_latest.zip && \
   CURRENT=$PWD && \
   echo $CURRENT && \
   export ANDROID_HOME="$CURRENT/commandlinetools-win-9123335_latest" && \
   export PATH="$ANDROID_HOME/cmdline-tools/bin:$PATH" && \
   echo $PATH
   cd $ANDROID_HOME/cmdline-tools/bin && \
   ls && \
   cd $CURRENT && \
   sdkmanager --sdk_root=$ANDROID_HOME --install "platform-tools" "platforms;android-27" "build-tools;27.0.2" "ndk-bundle" && \
   mkdir -p /src/workspace && \
   cd /src/workspace && \
   git clone --recursive https://github.com/google/fhir.git && \
   cd fhir && \
   bazel build //cc/google/fhir/...

VOLUME /src/workspace
VOLUME /tmp/build_output



### bazel build //absl/...
ENTRYPOINT [ "/bin/bash" ]
