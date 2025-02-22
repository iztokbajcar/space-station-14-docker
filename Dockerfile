# Download build
FROM debian:10 as fetch

RUN apt-get update && apt-get install -y curl unzip wget

# linux-arm64  linux-x64  win-x64  osx-x64
ARG platform=linux-x64
ARG FORK=wizden

RUN echo "Build list url: $BUILD_LIST_URL"

RUN get_fork_build_url() { \
        case "$FORK" in \
            "goob") \
                BUILD_LIST_URL="https://cdn.goobstation.com/fork/GoobLRP" \
                ;; \
            *) \
                BUILD_LIST_URL="https://wizards.cdn.spacestation14.com/fork/wizards" \
                ;; \
        esac \
    } && \
    get_fork_build_url && \
    version_line="$(curl $BUILD_LIST_URL | grep 'class=\"versionNumber\"' | head -n1)" && \
    version="$(echo $version_line | cut -c33-72)" && \
    wget $BUILD_LIST_URL/version/${version}/file/SS14.Server_${platform}.zip

RUN mkdir /ss14 && \
	mv SS14.Server_${platform}.zip /ss14 && \
	cd /ss14 && \
	unzip SS14.Server_${platform} && \
	rm SS14.Server_${platform}.zip && \
	rm server_config.toml



FROM mcr.microsoft.com/dotnet/runtime:8.0

RUN adduser --disabled-password --home /home/ss14 --shell /bin/bash ss14
COPY --from=fetch /ss14 /home/ss14
RUN chown -Rv ss14 /home/ss14 && chmod -Rv u+x /home/ss14

USER ss14
WORKDIR /home/ss14
ENTRYPOINT ["/home/ss14/Robust.Server"]

