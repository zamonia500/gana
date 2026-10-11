import Cocoa
import KeyboardShortcuts

class ShortcutCellView: NSTableCellView {
  private var recorder: KeyboardShortcuts.RecorderCocoa?

  func setInputSource(_ inputSource: InputSource) {
    // Picks up input sources added after launch.
    inputSource.bindShortcut()

    if let recorder = recorder {
      recorder.shortcutName = inputSource.shortcutName
      return
    }

    // RecorderCocoa can't be instantiated from a storyboard, so it's added in code.
    let recorder = KeyboardShortcuts.RecorderCocoa(for: inputSource.shortcutName)
    recorder.translatesAutoresizingMaskIntoConstraints = false
    addSubview(recorder)
    NSLayoutConstraint.activate([
      recorder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
      recorder.trailingAnchor.constraint(equalTo: trailingAnchor),
      recorder.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
    self.recorder = recorder
  }
}
