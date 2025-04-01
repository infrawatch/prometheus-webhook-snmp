# >> ignore DL3007 warning (base image version pin)
# hadolint ignore=DL3007
FROM registry.access.redhat.com/ubi9:latest

# >> ignore SC2086 because passing quoted env vars to dnf causes issues (fail to install)
# hadolint ignore=SC2086
RUN INSTALL_PKGS="\
        procps-ng \
        lsof \
        python3 \
        python3-devel \
        gcc \
        " && \
    dnf -y --setopt=tsflags=nodocs --setopt=skip_missing_names_on_install=False install $INSTALL_PKGS && \
    dnf -y clean all

COPY . /source/app
WORKDIR /source/app

RUN python3 -m pip install --no-cache-dir -r requirements-build.txt && \
    python3 -m pip install --no-cache-dir . && \
    python3 -m pip freeze

# Cleanup
# >> ignore SC2086 because passing quoted env vars to dnf causes issues (fail to install)
# hadolint ignore=SC2086
RUN UNINSTALL_PKGS="\
        gcc \
        " && \
    dnf remove -y $UNINSTALL_PKGS && \
    dnf -y clean all

ENV SNMP_COMMUNITY="public"
ENV SNMP_PORT=162
ENV SNMP_HOST="localhost"
ENV SNMP_RETRIES=5
ENV SNMP_TIMEOUT=1
ENV ALERT_OID_LABEL="oid"
ENV TRAP_OID_PREFIX="1.3.6.1.4.1.50495.15"
ENV TRAP_DEFAULT_OID="1.3.6.1.4.1.50495.15.1.2.1"
ENV TRAP_DEFAULT_SEVERITY=""

EXPOSE 9099

CMD ["sh", "-c", "/usr/local/bin/prometheus-webhook-snmp --debug --snmp-port=\"${SNMP_PORT}\" --snmp-host=\"${SNMP_HOST}\" --snmp-community=\"${SNMP_COMMUNITY}\" --snmp-retries=\"${SNMP_RETRIES}\" --snmp-timeout=\"${SNMP_TIMEOUT}\" --alert-oid-label=\"${ALERT_OID_LABEL}\" --trap-oid-prefix=\"${TRAP_OID_PREFIX}\" --trap-default-oid=\"${TRAP_DEFAULT_OID}\" --trap-default-severity=\"${TRAP_DEFAULT_SEVERITY}\" run"]
