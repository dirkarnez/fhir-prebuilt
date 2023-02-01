FROM l.gcr.io/google/bazel:latest

RUN apt-get update -y \ 
&& apt-get -y --no-install-recommends install \
   build-essential \
#    android-sdk \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN mkdir -p /src/workspace && cd /src/workspace && git clone --recursive https://github.com/google/fhir.git && cd fhir && bazel build //cc/google/fhir/...

VOLUME /src/workspace
VOLUME /tmp/build_output



### bazel build //absl/...
ENTRYPOINT [ "/bin/bash" ]
