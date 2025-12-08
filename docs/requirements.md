OAuth2-Proxy Email Admin
==========================

Purpose
-------

Phoenix web app to manage authenticated email lists for multiple oauth2-proxy instances without SSH/restarts.

Core Features
-------------

-   Auto-discover oauth2-proxy containers from folder structure
-   View/add/remove emails per service
-   Auto-restart containers when emails updated
-   Simple UI (LiveView)

File Structure
--------------

```
priv/proxies/
├── spliit-oauth2-proxy/
│   └── emails          # one email per line
├── some-app-1-oauth2-proxy/
│   └── emails
├── some-app-2-oauth2-proxy/
    └── emails
```

**Convention:**

-   Folder name = container name to restart
-   File name is always `emails`
-   App scans `priv/proxies/` to discover services (no config needed!)

Technical Stack
---------------

-   Phoenix LiveView (UI)
-   File I/O (read/write email lists)
-   Req library (HTTP calls to Docker/Podman socket)
-   Default socket: `/var/run/docker.sock` (or `/run/podman/podman.sock` for Podman)

Container Integration
---------------------

-   Mount Docker socket: `/var/run/docker.sock` (or `/run/podman/podman.sock` for Podman)
-   Mount: `./proxies:/app/priv/proxies`
-   API call: `POST /containers/{folder_name}/restart` after file update

Security
--------

-   Protect entire app with oauth2-proxy
-   Only admin email(s) can access

Deployment
----------

-   Runs as Docker/Podman container
-   Separate from services it manages
-   Single Phoenix app manages all services
