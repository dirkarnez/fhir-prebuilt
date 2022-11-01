FROM l.gcr.io/google/bazel:latest

RUN apt-get update -y \ 
&& apt-get -y --no-install-recommends install \
   build-essential \
#    android-sdk \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /src/workspace
VOLUME /tmp/build_output

WORKDIR /src/workspace

### bazel build //absl/...
### bazel build //cc/google/fhir/...
ENTRYPOINT [ "/bin/bash" ]
