import Cocoa
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  let statusBar = StatusBar.shared

  var justLaunched: Bool = true

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if PermanentStorage.launchedForTheFirstTime {
      PermanentStorage.launchedForTheFirstTime = false
      showPreferences()
    }

    InputSource.sources.forEach { $0.bindShortcut() }

    // Users who enabled notifications before the switch to UserNotifications haven't granted permission yet.
    if PermanentStorage.showsNotification {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { _, _ in }
    }
  }

  func applicationDidBecomeActive(_ notification: Notification) {
    if !justLaunched {
      showPreferences()
    }

    if justLaunched {
      justLaunched = false
    }
  }

  @IBAction func showPreferences(_ sender: AnyObject? = nil) {
    MainWindowController.shared.showAndActivate(self)
  }

  @IBAction func hidePreferences(_ sender: AnyObject?) {
    MainWindowController.shared.close()
  }
}
