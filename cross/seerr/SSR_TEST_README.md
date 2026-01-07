# SSR Testing in DSM Environment

## Background

The Seerr package (fork of Jellyseerr) has been experiencing SSR (Server-Side Rendering) failures when deployed in DSM (DiskStation Manager) environments. The main issue is that Next.js cannot connect to itself via loopback addresses (localhost, 127.0.0.1, 0.0.0.0) during SSR operations.

## Current Patches

### 001-fix-emfile-ssr.patch
- Handles SSR failures gracefully by catching connection errors
- Provides fallback default settings when SSR fails
- Prevents "Cannot read properties of undefined" errors in the client

### 002-add-ssr-test-endpoint.patch  
- Adds a simple test API endpoint at `/api/test-ssr`
- Can be used to verify if the Node.js server is responding properly
- Accessible after installation at: `http://<nas-ip>:<port>/api/test-ssr`

## Testing Instructions

After building and installing the Seerr package:

1. Check if the service is running:
   ```bash
   systemctl status pkgctl-seerr
   ```

2. Test the API endpoint:
   ```bash
   curl http://localhost:<port>/api/test-ssr
   ```

3. Access the web interface and check browser console for SSR fallback messages

## Known Issues

- SSR consistently fails in DSM with ECONNREFUSED/EADDRNOTAVAIL errors
- This appears to be a DSM network namespace/restriction issue
- The current workaround is to catch SSR failures and fall back to client-side rendering

## Future Work

- Investigate DSM's network namespace configuration
- Consider disabling SSR entirely if the fallback approach proves insufficient
- Test with different Node.js configurations specific to DSM
