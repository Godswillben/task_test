import Cocoa
import FlutterMacOS
import desktop_multi_window

@main
class AppDelegate: FlutterAppDelegate {
  // new code
  // override func applicationDidFinishLaunching(_ aNotification: Notification) {
  //   // 1. Register all plugins for the MAIN window.
  //   // This is the default registration that should be called.
  //   GeneratedPluginRegistrant.register(with: self)

  //   // 2. Register all plugins for future SECONDARY windows.
  //   // This MUST happen AFTER the main registration.
  //   // This line registers plugins using the MainFlutterWindow's registry.
  //   // Note: The specific function name 'registerPlugins(in:)' may be slightly 
  //   // different depending on the exact version/setup.
  //   if let window = self.mainFlutterWindow {
  //       // Use a conditional check as 'mainFlutterWindow' might be nil initially
  //       // depending on the lifecycle.
  //       DesktopMultiWindowPlugin.registerPlugins(in: window) 
  //   }
    
  //   super.applicationDidFinishLaunching(aNotification)
  // }

  // default
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
