# SSR Disabled for DSM Builds

## Problem
Seerr's Next.js SSR model is fundamentally incompatible with DSM's package sandboxing.
DSM packages run in a restricted network namespace where they cannot make HTTP requests
to themselves during SSR.

## Symptoms We Observed
- EMFILE errors (too many file descriptors)
- ECONNREFUSED/EADDRNOTAVAIL on all loopback addresses (localhost, 127.0.0.1, 0.0.0.0)
- Infinite SSR retry loops
- Internal Server Error on page load

## Root Cause
SSR requires the server to make HTTP calls to its own API endpoints:
- `/api/v1/settings/public`
- `/api/v1/auth/me`

DSM's network isolation prevents these self-referential HTTP calls from working.

## Solution
Disabled SSR entirely for DSM builds by:
1. Adding `DISABLE_SSR=true` to the environment
2. Patching `_app.tsx` to skip SSR when this flag is set
3. Running Seerr as a pure Client-Side Rendered (CSR) application

## Trade-offs
- First page load is slightly slower (needs to fetch data after mount)
- No SEO impact (Seerr is an internal admin app)
- Massively improved reliability on DSM
- Simpler architecture with no SSR-specific networking issues

## Alternative (Future)
The proper long-term fix would be refactoring Seerr to never make HTTP calls during SSR,
instead calling internal functions directly. This would require significant upstream changes.
