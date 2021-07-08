## =================> STAGES for Consul server <=======================
FROM consul:1.9.5 as consulServerDev
COPY ./consul-server/entrypoint.sh /entrypoint.sh
COPY ./consul-server /consul/config/
RUN chmod +x /entrypoint.sh
EXPOSE 8500
CMD ["/entrypoint.sh"]
