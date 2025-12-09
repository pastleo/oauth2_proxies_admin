# Development Environment

This directory contains a Docker Compose setup for running mock oauth2-proxy services that can be managed by the Phoenix app running locally.

## Quick Start

```
git clone https://github.com/pastleo/oauth2_proxies_admin.git
cd oauth2_proxies_admin
```

1. Setup:
   ```bash
   mix setup
   cp config/local.example.exs config/local.exs # edit if needed
   ```

2. Start the mock oauth2-proxy services:
   ```bash
   cd dev
   docker compose up
   ```

3. Start Phoenix locally:
   ```bash
   iex -S mix phx.server
   ```

4. Access the services:
   - **Admin UI**: http://localhost:4000 (Phoenix running locally)
   - **App 1**: http://localhost:8081 (mock oauth2-proxy with nginx)
   - **App 2**: http://localhost:8082 (mock oauth2-proxy with nginx)

## Testing Email Management

1. Access the admin UI at http://localhost:4000
2. You'll see two proxy services: `app1-oauth2-proxy` and `app2-oauth2-proxy`
3. Add/remove emails for each service
4. Check `dev/proxies/*/emails` files change
4. The admin will automatically restart the corresponding Docker containers
5. Verify the containers restarted: `docker compose ps`
6. Check the restart timestamp in the admin UI
