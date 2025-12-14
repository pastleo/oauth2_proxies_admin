# OAuth2 Proxy Email Admin

A Phoenix web application to manage authenticated email lists for multiple [oauth2-proxy](https://github.com/oauth2-proxy/oauth2-proxy) services for file-based docker/podman compose setup

## How It Works

The application scans a `proxies` (env `PROXIES_PATH`) folder, each folder inside represents a oauth2-proxy service using folder name as oauth2-proxy container name, and a `emails` file inside:

```
proxies/
├── spliit-oauth2-proxy/
│   └── emails # one email per line
├── some-app-1-oauth2-proxy/
│   └── emails
└── some-app-2-oauth2-proxy/
    └── emails
```

## Deployment

`compose.yml`:

 ```yaml
services:
  oauth2_proxies_admin:
    # get latest release version first: https://github.com/pastleo/oauth2_proxies_admin/pkgs/container/oauth2_proxies_admin
    image: ghcr.io/pastleo/oauth2_proxies_admin:main-xxxxxxx
    environment:
      PROXIES_PATH: /proxies
    user: 0
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./proxies:/proxies
    env_file: .env
    restart: always
  oauth2-proxy:
    image: quay.io/oauth2-proxy/oauth2-proxy
    container_name: admin_oauth2_proxy
    environment:
      OAUTH2_PROXY_HTTP_ADDRESS: http://:4180
      OAUTH2_PROXY_UPSTREAMS: http://oauth2_proxies_admin:4000
      OAUTH2_PROXY_AUTHENTICATED_EMAILS_FILE: /allowed/emails
    env_file: .env
    ports:
      - "4180:4180"
    volumes:
      - ./proxies/admin_oauth2_proxy:/allowed
    restart: always
 ```

`.env`:

```
SECRET_KEY_BASE= # mix phx.gen.secret
PHX_HOST="example.com"

# OAUTH2_PROXY_ envs
# see https://oauth2-proxy.github.io/oauth2-proxy/
```

and prepare initial allowed emails:

```bash
mkdir -p proxies/admin_oauth2_proxy
echo "admin@example.com" > ./proxies/admin_oauth2_proxy/emails
```

## Development

See [dev/README.md](./dev/README.md) for detailed instructions.

## Learn More

- Official Phoenix website: https://www.phoenixframework.org/
- Phoenix Guides: https://hexdocs.pm/phoenix/overview.html
- Phoenix Docs: https://hexdocs.pm/phoenix
- Phoenix Forum: https://elixirforum.com/c/phoenix-forum
- Phoenix Source: https://github.com/phoenixframework/phoenix
