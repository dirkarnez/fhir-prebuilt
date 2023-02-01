FROM l.gcr.io/google/bazel:latest

RUN apt-get update -y \ 
&& apt-get -y --no-install-recommends install \
   build-essential \
#    android-sdk \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /src/workspace
VOLUME /tmp/build_output


RUN cd /src/workspace && git clone --recursive https://github.com/google/fhir.git && cd fhir

WORKDIR /src/workspace/fhir

### bazel build //absl/...
ENTRYPOINT [ "/bin/bash", "cd", "/src/workspace/fhir", "&&", "bazel", "build", "//cc/google/fhir/..." ]
