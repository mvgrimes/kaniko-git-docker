# The kaniko project from
# https://github.com/GoogleContainerTools/kaniko/blob/master/deploy/Dockerfile
FROM gcr.io/kaniko-project/executor

# Install alpine base (to get apk)
FROM alpine

# Install needed tools (git)
RUN apk --no-cache update && \
    apk --no-cache add \
        git \
      && \
    rm -rf /var/cache/apk/*

COPY --from=0 /kaniko/executor /kaniko/executor
COPY --from=0 /kaniko/docker-credential-gcr /kaniko/docker-credential-gcr
COPY --from=0 /kaniko/docker-credential-ecr-login /kaniko/docker-credential-ecr-login
COPY --from=0 /kaniko/ssl/certs/ /kaniko/ssl/certs/
COPY --from=0 /kaniko/.docker/config.json /kaniko/.docker/config.json

ENV HOME /root
ENV USER /root
ENV PATH /bin:/usr/bin:/usr/local/bin:/kaniko
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/
ENV DOCKER_CREDENTIAL_GCR_CONFIG /kaniko/.config/gcloud/docker_credential_gcr_config.json

WORKDIR /workspace
RUN ["docker-credential-gcr", "config", "--token-source=env"]

ENTRYPOINT ["/kaniko/executor"]
