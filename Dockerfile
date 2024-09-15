# Clone from github - unfinished dockerfile

#FROM mcr.microsoft.com/dotnet/sdk:7.0 as build
#
#RUN apt-get update && apt-get install -y git python3
#
#RUN useradd -ms /bin/bash ss14
#USER ss14
#WORKDIR /home/ss14
#
#RUN git clone https://github.com/space-wizards/space-station-14.git
#WORKDIR space-station-14
#
#RUN python3 RUN_THIS.py
#RUN dotnet build
#
#
#FROM mcr.microsoft.com/dotnet/runtime:7.0
#
#RUN adduser --disabled-password --home /home/ss14 --shell /bin/bash ss14
#COPY --from=build /home/ss14/space-station-14/bin /home/ss14/bin
#COPY --from=build /home/ss14/space-station-14/RobustToolbox/bin /home/ss14/RobustToolbox/bin
#RUN chown -R ss14:ss14 /home/ss14/RobustToolbox/bin && chmod -R u+x /home/ss14/RobustToolbox/bin/
#
#USER ss14
#WORKDIR /home/ss14/RobustToolbox/bin/Server
#
#ENTRYPOINT /home/ss14/RobustToolbox/bin/Server/Robust.Server

# Download build
FROM debian:10 as fetch

RUN apt-get update && apt-get install -y curl unzip wget

# linux-arm64  linux-x64  win-x64  osx-x64
ARG platform=linux-x64
RUN version_line="$(curl https://wizards.cdn.spacestation14.com/fork/wizards | grep 'class=\"versionNumber\"' | head -n1)" && \
	version="$(echo $version_line | cut -c33-72)" && \
	wget https://wizards.cdn.spacestation14.com/fork/wizards/version/${version}/file/SS14.Server_${platform}.zip


#RUN version_line="$(curl https://central.spacestation14.io/builds/wizards/builds.html | grep 'class=\"versionNumber\"')" && \
#	version=$(echo $version_line | cut -c44-83) && \
#	wget https://cdn.centcomm.spacestation14.com/builds/wizards/builds/${version}/SS14.Server_${platform}.zip

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

