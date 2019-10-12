# Docker-Dplug

## Example usage

### Build The Container

`docker build -t dplug-build -f Dockerfile .`

### Example usage

`docker run -w /src/examples/clipit --volume "/path/to/vst2_sdk:/VST2_SDK" --volume "/path/to/dplug:/src" dplug-build -c VST --compiler ldc2 -a x86_64 -b release-nobounds`
