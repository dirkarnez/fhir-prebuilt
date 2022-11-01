FROM l.gcr.io/google/bazel:latest

VOLUME /src/workspace
VOLUME /tmp/build_output

WORKDIR /src/workspace

### bazel build //absl/...
### bazel build //cc/google/fhir/...
ENTRYPOINT [ "/bin/bash" ]