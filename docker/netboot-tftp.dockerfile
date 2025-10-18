FROM alpine:3.20
RUN apk add --no-cache wget tftp-hpa
RUN mkdir -p /srv/tftp && \
    chmod -R 755 /srv/tftp && \
    addgroup -S tftpd && \
    adduser -s /bin/false -S -D -H -h /data -G tftpd tftpd
RUN wget -O /srv/tftp/amd.efi https://boot.netboot.xyz/ipxe/netboot.xyz.efi && \
    wget -O /srv/tftp/amd-snp.efi https://boot.netboot.xyz/ipxe/netboot.xyz-snp.efi && \
    wget -O /srv/tftp/arm.efi https://boot.netboot.xyz/ipxe/netboot.xyz-arm64.efi && \
    chmod 644 /srv/tftp/*.efi

EXPOSE 69/udp
VOLUME ["/srv/tftp"]

CMD ["in.tftpd" ,"-L","-v","-s","-u","tftpd","/srv/tftp"]