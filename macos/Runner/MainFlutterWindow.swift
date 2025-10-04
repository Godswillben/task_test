import Cocoa
import FlutterMacOS
import desktop_multi_window
import window_manager

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    // Add the plugin registration callback:
    // DesktopMultiWindowPlugin.setOnWindowCreatedCallback { (registrar) in
    //     GeneratedPluginRegistrant.register(with: registrar)
    // }

     // 1. Add the following line to enable window_manager settings
    // This allows it to control the window border and level.
    self.styleMask.remove(.resizable) // Optional: Prevent resizing
    self.styleMask.insert(.fullSizeContentView) 

    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
