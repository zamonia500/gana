import Cocoa
import KeyboardShortcuts
import UserNotifications

@MainActor
extension InputSource {
  private static var boundShortcutNames = Set<KeyboardShortcuts.Name>()

  // KeyboardShortcuts uses the name as a key path, so it must not contain dots.
  var shortcutName: KeyboardShortcuts.Name {
    return KeyboardShortcuts.Name(id.replacingOccurrences(of: ".", with: "-"))
  }

  // Handlers stack up on every registration, so each input source is bound at most once.
  func bindShortcut() {
    guard InputSource.boundShortcutNames.insert(shortcutName).inserted else { return }

    KeyboardShortcuts.onKeyDown(for: shortcutName) { [self] in
      select()

      if PermanentStorage.showsNotification {
        showNotification()
      }
    }
  }

  private func showNotification() {
    let center = UNUserNotificationCenter.current()
    center.removeAllDeliveredNotifications()

    let content = UNMutableNotificationContent()
    content.body = name
    if let attachment = icon.flatMap(InputSource.notificationAttachment) {
      content.attachments = [attachment]
    }

    center.add(UNNotificationRequest(identifier: "input-source-changed", content: content, trigger: nil))
  }

  // UNNotificationAttachment only accepts files, so the icon is written out as a PNG first.
  private static func notificationAttachment(for icon: NSImage) -> UNNotificationAttachment? {
    guard let tiff = icon.tiffRepresentation,
      let png = NSBitmapImageRep(data: tiff)?.representation(using: .png, properties: [:]) else {
      return nil
    }

    let url = FileManager.default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension("png")

    do {
      try png.write(to: url)
      return try UNNotificationAttachment(identifier: "icon", url: url)
    } catch {
      return nil
    }
  }
}
