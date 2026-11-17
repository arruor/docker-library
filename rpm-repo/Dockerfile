FROM almalinux:9

RUN dnf -y install createrepo_c python3 \
    && dnf clean all \
    && rm -rf /var/cache/dnf

COPY entrypoint.sh /usr/local/bin/rpm-repo-entrypoint
RUN chmod 0755 /usr/local/bin/rpm-repo-entrypoint

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/rpm-repo-entrypoint"]
