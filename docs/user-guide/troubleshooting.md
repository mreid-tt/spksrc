# Troubleshooting

This guide covers common issues when using SynoCommunity packages.

## Repository Issues

### Cannot Add Repository

**Symptoms:**

- "Invalid location" error when adding repository
- Repository cannot be contacted

**Solutions:**

1. Verify the URL is exactly: `https://packages.synocommunity.com`
2. Check your NAS has internet access
3. Try accessing `https://packages.synocommunity.com` in a browser to verify the server is online
4. Check if your firewall blocks outbound HTTPS connections

### No Packages Visible

**Symptoms:**

- Repository added but "Community" section is empty
- Only some packages appear

**Solutions:**

1. Check your NAS architecture matches available packages (see [Compatibility](compatibility.md))
2. Ensure your DSM version is supported
3. Wait a few minutes and refresh - package lists may be loading
4. Clear Package Center cache: **Settings** > **General** > click **Clear**

## Installation Issues

### "Invalid File Format" Error

**Cause:** Downloaded an SPK for the wrong architecture.

**Solution:** Check your NAS architecture in **Control Panel** > **Info Center** > **General**, then download the correct package version.

### "Insufficient Privilege" or Permission Denied

**Solutions:**

1. Ensure you are logged in as an administrator
2. On DSM 7.x, verify trust level allows community packages:
   - **Package Center** > **Settings** > **General** > **Trust Level**: "Any publisher"

### Installation Wizard Fails

**Solutions:**

1. Check the shared folder specified in the wizard exists
2. Ensure the folder has appropriate permissions
3. Try creating a new shared folder specifically for the package
4. Check Package Center logs: `/var/log/packages/`

### Package Dependencies Not Met

**Cause:** The package requires another package that is not installed or available.

**Solution:**

1. Check Package Center for the required dependency
2. Install the dependency first, then retry
3. If the dependency is not available for your architecture, the package cannot be installed

## Runtime Issues

### Package Won't Start

**Diagnostic Steps:**

1. Check package logs:
   ```bash
   cat /var/packages/<package-name>/var/logs/*.log
   ```

2. Check system log:
   ```bash
   cat /var/log/synopkg.log | grep <package-name>
   ```

3. Try restarting the package:
   - Via Package Center: Stop, then Start
   - Via SSH: `synopkg restart <package-name>`

4. Check for port conflicts (see [Ports](../reference/ports.md))

### "Failed to Start" After DSM Update

**Cause:** DSM updates can change system components that packages depend on.

**Solutions:**

1. Repair the package: **Package Center** > click package > **Repair**
2. Stop, then start the package
3. Check if a package update is available
4. Uninstall and reinstall the package (data is preserved by default)

### Web Interface Not Accessible

**For packages with web interfaces:**

1. Verify the package is running
2. Check the port in package settings
3. Try accessing via IP address instead of hostname
4. Check if your browser is blocking the connection (try incognito mode)
5. Verify your firewall allows the port

## DSM-Specific Issues

### DSM 7.x Issues

#### Package Stopped After Reboot

Some packages may not auto-start after DSM 7 updates due to systemd changes.

**Solution:** Manually start the package after reboot, or check for package updates that address this.

#### Permission Issues with Shared Folders

DSM 7 has stricter permission controls.

**Solution:** Ensure the package user (usually `sc-<packagename>`) has appropriate permissions on required folders.

### DSM 6.x Issues

#### No Packages Available for Old DSM Versions

**Cause:** Some packages require DSM 6.1+ or DSM 6.2+.

**Solution:** Update DSM to the latest version for your NAS model, or check if older package versions are available.

## Getting Help

If the above solutions don't help:

1. **Search existing issues**: [GitHub Issues](https://github.com/SynoCommunity/spksrc/issues)
2. **Check package-specific documentation**: [Package Documentation](../packages/index.md)
3. **Ask on Discord**: [SynoCommunity Discord](https://discord.gg/nnN9fgE7EF)
4. **Open a new issue**: Include:
   - NAS model and DSM version
   - Package name and version
   - Steps to reproduce the issue
   - Relevant log excerpts
