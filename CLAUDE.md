# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Gana (a fork of [Kawa](https://github.com/hatashiro/kawa); the Xcode project, target and source folder still use the `kawa` name, while the product, module and bundle ID are `Gana` / `io.github.zamonia500.Gana`) is a macOS menu-bar app (`LSUIElement`, no Dock icon) that lets users bind global keyboard shortcuts to individual input sources (keyboard layouts / IMEs). Swift 5, AppKit + Carbon, deployment target macOS 26.

## Build

The only dependency, `sindresorhus/KeyboardShortcuts` (3.x), is a Swift package referenced from `kawa.xcodeproj`; Xcode resolves it automatically. Requires full Xcode (the package uses SwiftUI macros, so Command Line Tools alone can't build it).

```bash
xcodebuild -project kawa.xcodeproj -scheme kawa -configuration Release build
```

There is a single app target (`kawa`) and no test target or linter configuration.

## Architecture

- **Entry / lifecycle** — `AppDelegate` creates the `StatusBar` singleton (menu-bar icon that opens preferences) and binds a global shortcut for every input source at launch. The preferences window opens automatically only on first launch (tracked via `PermanentStorage.launchedForTheFirstTime`) or when the app is re-activated (e.g. relaunched from Finder).
- **UI** — Built from `kawa/en.lproj/Main.storyboard`. `MainWindowController.shared` is instantiated from the storyboard by identifier `"MainWindow"`. The window hosts `ShortcutViewController` (table of input sources) and `PreferencesViewController` (notification toggle, quit). On window close, focus is handed back to the menu-bar-owning app.
- **Input sources** — `TISInputSource+Additions.swift` wraps Carbon's `TISGetInputSourceProperty` into typed Swift properties. `InputSource` (`InputSourceManager.swift`) wraps a `TISInputSource`, resolves its icon, and `InputSource.sources` lists selectable keyboard input sources. Selection is done with `TISSelectInputSource`.
- **Shortcuts** — `InputSource+Shortcut.swift` maps each input source to a `KeyboardShortcuts.Name` (its ID with `.` replaced by `-`; names must not contain dots) and registers a key-down handler that selects the source and optionally posts a `UserNotifications` notification. KeyboardShortcuts persists shortcuts in `UserDefaults` itself. `onKeyDown` handlers accumulate, so `bindShortcut()` guards against double registration; it is called at launch and again from `ShortcutCellView` to pick up input sources added later.
- **Recorder** — `KeyboardShortcuts.RecorderCocoa` cannot be created from a storyboard, so `ShortcutCellView` adds it in code; the storyboard cell is empty.
- **Settings** — `PermanentStorage` is a small typed wrapper over `UserDefaults` keyed by the `StorageKey` enum.

## Caveat

macOS's `TISSelectInputSource` is known to misbehave with complex CJKV input sources (noted in README; CHANGELOG 1.0.0 mentions a workaround for this). Keep that in mind when touching selection logic.

Release notes go in `CHANGELOG.md`.
