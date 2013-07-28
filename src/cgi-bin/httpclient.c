/*
 * httpclient.c -- a light-weight httpclient: request a web page and print it
 *
 * author: falcon <zhangjinw@gmail.com> 
 * update: 2008-06-14
 *
 * usage: ./httpclient http://x.x.x.x:port/path/to/an/html/file
 *
 * NOTE: please don't use HTTP/1.1, because it will resturn multi-range bytes to
 * your to force you filter the range numbers.
 */

#include <errno.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netdb.h>

void gethost(char *, char *, int *, char *);

int main(int argc, char *argv[])
{
	struct sockaddr_in server_addr;
	struct hostent *host;
	char file[1024], addr[256], buf[1024], request[1024];
	int sockfd, port, nbytes, send, totalsend, i;

	/* make sure user input an argument as the web adress */

	if (argc != 2) {
		fprintf(stderr, "Usage:%s web-address\n", argv[0]);
		return -1;
	}

	/* get host address, port, and file name with full path */

	gethost(argv[1], addr, &port, file);

	/* get ip address, save it to "host" */
	if ((host = gethostbyname(addr)) == NULL) {
		fprintf(stderr, "gethostname() error: %s\n",
			strerror(errno));
		return -1;
	}

	/* create the socket */

	if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
		fprintf(stderr, "socket() error: %s\n", strerror(errno));
		return -1;
	}

	/* fullfill the server info and send connection to it */
	bzero(&server_addr, sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(port);
	server_addr.sin_addr = *((struct in_addr *) host->h_addr);

	if (connect
	    (sockfd, (struct sockaddr *) (&server_addr),
	     sizeof(struct sockaddr))
	    == -1) {
		fprintf(stderr, "connect() error: %s\n", strerror(errno));
		return -1;
	}

	/* generate the request message header, and send http request to the server */

	sprintf(request, "GET /%s HTTP/1.0\r\nAccept: */*\r\nAccept-Language: en-us\r\n\
User-Agent: Mozilla/5.0\r\nHost: %s:%d\r\nConnection: Close\r\n\r\n", file,
		addr, port);

	send = 0;
	totalsend = 0;
	nbytes = strlen(request);
	while (totalsend < nbytes) {
		send =
		    write(sockfd, request + totalsend, nbytes - totalsend);
		if (send == -1) {
			printf("write() error: %s\n", strerror(errno));
			return -1;
		}
		totalsend += send;
	}

	/* receive the http response */
	i = 0;
	while ((nbytes = read(sockfd, buf, 1)) == 1) {
		/* filter the message header */
		if (i < 4) {
			if(buf[0] == '\r' || buf[0] == '\n') i ++;
			else i = 0;
		} else 	printf("%c", buf[0]);
	}

	/* close the socket */
	close(sockfd);

	return 0;
}

/*
 * gethost -- get the host address, port and file
 * @src: the web URL input by user
 * @addr: host address
 * @port: host port
 * @file: host file with full path, such as /path/to/file
 */

void gethost(char *src, char *addr, int *port, char *file)
{
	char *p1 = NULL;
	char *p2 = NULL;

	memset(addr, 0, sizeof(addr));
	memset(file, 0, sizeof(file));

	*port = 0;
	if (!(*src))
		return;
	/* get the position after http:// or https:// */
	p1 = src;
	if (!strncmp(p1, "http://", sizeof("http://") - 1))
		p1 = src + sizeof("http://") - 1;
	else if (!strncmp(p1, "https://", sizeof("https://") - 1))
		p1 = src + sizeof("https://") - 1;

	/* get the position of the fist "/" character after http:// or https:// */
	p2 = strchr(p1, '/');
	if (!p2) {
		memcpy(addr, p1, strlen(p1));
	} else {
		memcpy(addr, p1, strlen(p1) - strlen(p2));
		if (p2 + 1) {
			memcpy(file, p2 + 1, strlen(p2) - 1);
			file[strlen(p2) - 1] = 0;
		}
	}

	if (p2)
		addr[strlen(p1) - strlen(p2)] = 0;
	else
		addr[strlen(p1)] = 0;

	/* get the port value */
	p2 = strchr(addr, ':');
	if (!p2) { 
		*port = 80;
	} else {
		*port = atoi(p2 + 1);
		addr[strlen(p1) - strlen(p2)] = '\0';
	}
}
