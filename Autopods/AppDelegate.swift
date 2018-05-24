import Cocoa
import ServiceManagement


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        Services.configuration.registerDefaults()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window in sender.windows {
                window.makeKeyAndOrderFront(self)
            }
        }

        return true
    }

    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        let podsMenu = Services.podfiles.podfiles.reduce(into: NSMenu()) { (menu, podfile) in
            guard let repository = Repository(url: podfile.url) else {
                return
            }

            let item = NSMenuItem()
            item.title = repository.name
            let submenu = NSMenu()
            item.submenu = submenu
            submenu.addItem(BlockMenuItem(title: "Install") {
                Services.coordinator.coordinate(updated: podfile, launch: Services.cocoapods.install)
            })
            submenu.addItem(BlockMenuItem(title: "Update") {
                Services.coordinator.coordinate(updated: podfile, launch: Services.cocoapods.update)
            })

            menu.addItem(item)
        }

        podsMenu.addItem(NSMenuItem.separator())

        let title = Services.configuration.isTrackingFiles ? "Pause" : "Resume"
        podsMenu.addItem(BlockMenuItem(title: title) {
            Services.configuration.isTrackingFiles = !Services.configuration.isTrackingFiles
        })

        return podsMenu
    }
}
