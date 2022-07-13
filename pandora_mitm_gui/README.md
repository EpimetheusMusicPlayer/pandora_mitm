# Pandora MITM

A Pandora app reverse-engineering toolbox.

![Screenshot](https://user-images.githubusercontent.com/20849728/178569867-7689740f-ac08-4c4e-9732-054738e80655.png)

## Features
- Dynamic decryption, analysis and modification of Pandora JSON API messages
- Extensibility through a [Dart](https://dart.dev) plugin API
- Built-in plugins that enable:
  - Message recording with (some) response previews
  - API message object definition inference (+ [iapetus] code generation)
  - Feature unlocking
  - Fake authentication token expiration
  - mitmproxy UI enhancements

## Getting started

### Setup

1. Follow the [pandora_mitm setup instructions](../pandora_mitm#backend-setup).
2. Download the [latest desktop build](https://github.com/EpimetheusMusicPlayer/pandora_mitm/releases).
   Alternatively, try out the [Web version](https://epimetheusmusicplayer.github.io/pandora_mitm).
   
   Note that:
   - The Web version has reduced performance and may not connect in some browsers
   - It should be trivial to add builds for other platforms - there's no OS-specific code in use. PRs are welcome.

### Usage

Plugins can be added, configured, and removed using the plugin selection panel on the left-hand side.  
Useful templates can be accessed through the drop-down menu next to the add button.

## Technologies
A rough overview of the technology stack used in this project is as follows:
> [Python](https://python.org)
- [mitmproxy](https://mitmproxy.org)
- [mitmproxy Remote Interceptions](https://github.com/hacker1024/mitmproxy_remote_interceptions)
> [Dart](https://dart.dev)
- [mitmproxy_ri_client](https://github.com/hacker1024/mitmproxy_ri_client.dart)
- [iapetus]
- [pandora_mitm](../pandora_mitm)
> [Flutter](https://flutter.dev)
- [pandora_mitm_gui_core](../pandora_mitm_gui_core)

### Also see
- [pandora_mitm_cli](../pandora_mitm_cli)

[iapetus]: https://github.com/EpimetheusMusicPlayer/iapetus
