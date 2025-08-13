FROM python:3.11-slim

#https://stackoverflow.com/a/72551258
ENV PIP_ROOT_USER_ACTION=ignore
# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV PYTHONUNBUFFERED=1
ENV LANG=C.UTF-8
##https://stackoverflow.com/questions/59732335/is-there-any-disadvantage-in-using-pythondontwritebytecode-in-docker/60797635#60797635
ENV PYTHONDONTWRITEBYTECODE=1


# Install basic build tools and curl for downloading uv
RUN set -ex && \
    apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install uv (fast Python installer), symlink it to /usr/local/bin
RUN set -ex && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    ln -sf /root/.local/bin/uv /usr/local/bin/uv

# Copy only dependency files first for caching
COPY pyproject.toml uv.lock ./

# Install Python dependencies using uv via lockfile
RUN set -ex && \
    uv pip install --system --requirement pyproject.toml

# Then copy the rest of your code
COPY ./ ./

WORKDIR /

#CMD ["/bin/sh"]
#https://docs.docker.com/reference/build-checks/json-args-recommended/
#CMD tail -f /dev/null
CMD ["tail", "-f", "/dev/null"]
#SHELL tail -f /dev/null


#CMD ["/bin/sh"]
#CMD tail -f /dev/null


#delete all  containers
#docker rm -f $(docker ps -a -q)

#This command will only show the dangling images
#(images that are not tagged or referenced by any container)
#docker images -f "dangling=true"
#delete all dangling images
#docker image prune -f
#delete all unused images
#docker image prune -a -f

#delete all images
#docker rmi -f $(docker images -q)

#deleta all build cache
#docker builder prune --all
#verify builder cache deleted
#docker builder du

#https://gallery.ecr.aws/lambda/python/
#docker system prune --all
#docker rm -f agents-from-scratch


#docker rmi -f agents-from-scratch-i
#docker rm -f agents-from-scratch
##docker build --no-cache . -t agents-from-scratch-i
#docker build --no-cache --progress=plain . -t agents-from-scratch-i
#docker run --rm -it agents-from-scratch-i bash
#docker exec -it $(docker ps -q -n=1) bash

#net stop com.docker.service
#net start com.docker.service

#net stop LxssManager
#net start LxssManager

#wsl --shutdown
#wsl --list --running
#wsl -d Ubuntu-20.04

#sudo docker stats | sudo tee -a docker_stats.log
#sudo watch -n 15 "docker stats --no-stream | sudo tee -a docker_stats.log"
#RAM+SWAP memory
#watch -n 1 free -h