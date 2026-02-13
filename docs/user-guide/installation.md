# Installation

This guide covers how to add the SynoCommunity package repository to your Synology NAS and install packages.

## Prerequisites

- A Synology NAS running DSM 5.2 or later
- Administrator access to your NAS
- An internet connection

## Adding the SynoCommunity Repository

### Step 1: Open Package Center

Log into your Synology DSM web interface and click on **Package Center** in the main menu.

### Step 2: Go to Settings

Click the **Settings** button in the top-right corner of Package Center.

### Step 3: Add Package Source

1. Select the **Package Sources** tab
2. Click **Add**
3. Enter the following information:
   - **Name**: `SynoCommunity`
   - **Location**: `https://packages.synocommunity.com`
4. Click **OK**

![Adding SynoCommunity repository](../assets/add-repository.png)

### Step 4: Trust the Repository

On DSM 7.x, you may see a warning about packages from unknown publishers. To allow installation:

1. Go to **Settings** > **General**
2. Select **Any publisher** under "Trust Level"
3. Click **OK**

!!! warning "Security Note"
    Allowing packages from any publisher means you trust community-maintained packages. SynoCommunity packages are built from open source code and reviewed by maintainers, but they are not signed by Synology.

## Installing Packages

### From Package Center

1. In Package Center, click **Community** in the left sidebar
2. Browse available packages or use the search box
3. Click on a package to view details
4. Click **Install**

### Beta Packages

Some packages are available as beta releases for testing:

1. Go to **Settings** > **General**
2. Under "Beta", select "Yes, I want to see beta versions"
3. Click **OK**

Beta packages will now appear alongside stable releases.

## Manual Installation

If you cannot add the repository (e.g., restricted network), you can install packages manually:

1. Download the `.spk` file for your architecture from [packages.synocommunity.com](https://packages.synocommunity.com)
2. In Package Center, click **Manual Install**
3. Browse to select the downloaded `.spk` file
4. Click **Next** and follow the installation wizard

!!! tip "Finding Your Architecture"
    See the [Compatibility](compatibility.md) page to determine your NAS architecture.

## Updating Packages

Packages installed from SynoCommunity receive updates through Package Center:

1. Open Package Center
2. If updates are available, you will see a notification
3. Click **Update** on individual packages, or **Update All**

## Removing Packages

1. Open Package Center
2. Click **Installed** in the left sidebar
3. Find the package you want to remove
4. Click on the package, then click **Uninstall**

!!! note "Data Retention"
    By default, uninstalling a package keeps its data. To remove all data, check the "Delete the data..." option during uninstall.

## Troubleshooting

If you encounter issues adding the repository or installing packages:

- Check your internet connection
- Verify the repository URL is correct
- See the [Troubleshooting](troubleshooting.md) guide for common issues
- Check the [GitHub issues](https://github.com/SynoCommunity/spksrc/issues) for known problems
