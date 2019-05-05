programs += server
programs += client
programs_extra += verify

.PHONY: all
all: $(programs) pem_files.list

.PHONY: extra
extra: $(programs_extra)

CC = gcc
CFLAGS += -g -O0 $(OPENSSLCFLAGS)
OPENSSLCFLAGS =
OPENSSLLIBS = -lssl -lcrypto
LDLIBS = $(OPENSSLLIBS)

server: dtls_server.o dtls.o
	$(LINK.o) $^ $(LDLIBS) -o $@
client: dtls_client.o dtls.o
	$(LINK.o) $^ $(LDLIBS) -o $@

pem_files.list:
	openssl req -x509 -newkey rsa:2048 -days 3650 -nodes -keyout server-key.pem -out server-cert.pem
	openssl req -x509 -newkey rsa:2048 -days 3650 -nodes -keyout client-key.pem -out client-cert.pem
	find . -name "\*.pem" > $@

.PHONY: clean
clean:
	$(RM) *.o
	$(RM) $(programs)
	$(RM) $(programs_extra)
