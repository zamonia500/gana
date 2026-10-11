# Gana [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/zamonia500/gana/master/LICENSE) [![GitHub release](https://img.shields.io/github/release/zamonia500/gana.svg)](https://github.com/zamonia500/gana/releases)

A macOS input source switcher with user-defined shortcuts.

Gana is a fork of [Kawa](https://github.com/hatashiro/kawa) by utatti, updated
to run natively on Apple Silicon and recent macOS (26 or later).

## Demo

Demo of the original Kawa; Gana works the same way.

[![demo](https://cloud.githubusercontent.com/assets/1013641/9109734/d73505e4-3c72-11e5-9c71-49cdf4a484da.gif)](http://vimeo.com/135542587)

## Install

### Using [Homebrew](https://brew.sh/)

```shell
brew install --cask zamonia500/tap/gana
```

Gana is not signed with an Apple Developer ID, so macOS blocks it on first
launch. Allow it in **System Settings → Privacy & Security → Open Anyway**,
or remove the quarantine attribute:

```shell
xattr -dr com.apple.quarantine /Applications/Gana.app
```

### Manually

Download `Gana.zip` from [Releases](https://github.com/zamonia500/gana/releases),
unzip it and move `Gana.app` to `Applications`. The same first-launch step as
above applies.

## Caveats

### CJKV input sources

There is a known bug in the macOS's Carbon library that switching keyboard
layouts using `TISSelectInputSource` doesn't work well with complex input
sources like [CJKV](https://en.wikipedia.org/wiki/CJK_characters).

## Development

Dependencies are managed with Swift Package Manager and are resolved
automatically by Xcode.

```bash
$ git clone git@github.com:zamonia500/gana.git
$ open gana/kawa.xcodeproj
```

## License

Gana is released under the [MIT License](LICENSE).
