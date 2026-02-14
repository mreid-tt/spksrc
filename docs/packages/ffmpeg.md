---
title: FFmpeg
description: FFmpeg multimedia framework for audio and video processing
tags:
  - media
  - transcoding
  - video
  - audio
---

# FFmpeg

FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video.

SynoCommunity provides multiple FFmpeg versions:

- **FFmpeg 4** (`ffmpeg4`) - Legacy support
- **FFmpeg 5** (`ffmpeg5`) - Stable release  
- **FFmpeg 6** (`ffmpeg6`) - Current stable
- **FFmpeg 7** (`ffmpeg7`) - Latest features

## Package Information

| Property | Value |
|----------|-------|
| Package Name | ffmpeg4, ffmpeg5, ffmpeg6, ffmpeg7 |
| Upstream | [ffmpeg.org](https://ffmpeg.org/) |
| License | LGPL/GPL |

## Architecture Support

FFmpeg packages require significant compilation resources. Hardware acceleration features vary by architecture:

- **Intel (x64)** - Full hardware acceleration via Intel Quick Sync Video (QSV) on supported models
- **AMD64** - Software encoding only
- **ARM** - Limited hardware acceleration on some models

## Hardware Acceleration

For Intel-based Synology devices with DSM 7.1+, hardware transcoding is available through the [SynoCli Video Driver](synocli-videodriver.md) package which provides:

- VA-API support
- Vulkan support (DSM 7.1+)
- OpenCL support (DSM 7.1+)

## Usage with Other Packages

Many media packages depend on FFmpeg:

- [Jellyfin](jellyfin.md) - Hardware transcoding
- [Sonarr](sonarr.md)/[Radarr](radarr.md) - Media analysis
- [Home Assistant](homeassistant.md) - Camera streams
- [Navidrome](navidrome.md) - Audio transcoding

## Building Custom FFmpeg

The spksrc framework supports building FFmpeg with custom options. Key Makefile variables:

```makefile
# Enable specific codecs
FFMPEG_CODEC_X264 = 1
FFMPEG_CODEC_X265 = 1
FFMPEG_CODEC_LIBVPX = 1

# Enable hardware acceleration
FFMPEG_VAAPI = 1
```

## Related Packages

- [SynoCli Video Driver](synocli-videodriver.md) - Intel GPU drivers
- [MKVToolNix](mkvtoolnix.md) - MKV container tools
- [MediaInfo](mediainfo.md) - Media file analysis
