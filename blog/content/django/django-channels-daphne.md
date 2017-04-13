Title: django-channels-daphne
Date: 2016-08-03 10:20
Modified: 2016-08-28 15:03:17
Category: Python
Tags: django
Slug: django-channels-daphne
Authors: zhangdi
Summary: Django ASGI (HTTP/WebSocket) server

[daphne](https://pypi.python.org/pypi/daphne/0.13.1)

Django ASGI (HTTP/WebSocket) server

Latest Version: 0.14.3

  
Daphne is a HTTP, HTTP2 and WebSocket protocol server for ASGI, and developed to power Django Channels.

It supports automatic negotiation of protocols; there’s no need for URL prefixing to determine WebSocket endpoints versus HTTP endpoints.

Running

Simply point Daphne to your ASGI channel layer instance, and optionally set a bind address and port (defaults to localhost, port 8000):

```bash
daphne -b 0.0.0.0 -p 8001 django_project.asgi:channel_layer
```
Root Path (SCRIPT_NAME)

In order to set the root path for Daphne, which is the equivalent of the WSGI SCRIPT_NAME setting, you have two options:

Pass a header value Daphne-Root-Path, with the desired root path as a URLencoded ASCII value. This header will not be passed down to applications.
Set the --root-path commandline option with the desired root path as a URLencoded ASCII value.
The header takes precedence if both are set. As with SCRIPT_ALIAS, the value should start with a slash, but not end with one; for example:

``` bash
daphne --root-path=/forum django_project.asgi:channel_layer
```
