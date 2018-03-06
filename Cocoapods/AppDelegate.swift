import Cocoa
import ServiceManagement


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window in sender.windows {
                window.makeKeyAndOrderFront(self)
            }
        }

        return true
    }

    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        return Services.podfiles.podfiles.reduce(into: NSMenu()) { (menu, podfile) in
            guard let repository = Repository(url: podfile.url) else {
                return
            }
            menu.addItem(BlockMenuItem(title: "Update \(repository.name)") {
                Services.coordinator.coordinate(updated: podfile)
            })
        }
    }
}
