ARG BASE_IMAGE=ubuntu:20.04
FROM ${BASE_IMAGE}

ARG PROJECT_NAME=ascender
ARG USER_NAME=challenger
ARG GROUP_NAME=challengers
ARG UID=1000
ARG GID=1000
ARG PYTHON_VERSION=3.12
ARG APPLICATION_DIRECTORY=/home/${USER_NAME}/${PROJECT_NAME}

ENV DEBIAN_FRONTEND="noninteractive" \
    LC_ALL="C.UTF-8" \
    LANG="C.UTF-8" \
    UV_SYSTEM_PYTHON=0 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    TERM=xterm-256color

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Alternative way to install uv
# ADD https://astral.sh/uv/install.sh /uv-installer.sh
# Run the installer then remove it
# RUN sh /uv-installer.sh && rm /uv-installer.sh


RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update -y && apt install --no-install-recommends -y software-properties-common \
    && apt-get update && apt-get install -y \
    # Install specified Python
    vim sudo build-essential openssl libssl-dev libffi-dev ca-certificates git curl ssh openssh-client \
    && update-ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Add user. Without this, following process is executed as admin.
RUN groupadd -g ${GID} ${GROUP_NAME} \
    && useradd -ms /bin/sh -u ${UID} -g ${GID} ${USER_NAME}

# Add user to sudoers
RUN echo "${USER_NAME}    ALL=(ALL)   NOPASSWD:    ALL" >> /etc/sudoers

USER ${USER_NAME}
WORKDIR ${APPLICATION_DIRECTORY}

# Install the project's dependencies using the lockfile and settings
# RUN --mount=type=cache,target=/home/${USER_NAME}/.cache/uv,--readwrite \
RUN --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    uv venv -p ${PYTHON_VERSION} \
    # virtualenv would be inconsistent with the lockfile without --frozen, because
    # the lock file is updated during the build process, but it will be overwritten by the hosts' lock file.
    && uv sync --frozen --all-extras

