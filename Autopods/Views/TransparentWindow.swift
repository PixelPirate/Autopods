import Cocoa

class TransparentWindowController: NSWindowController {

    @IBInspectable var closeButton: Bool = false

    override func windowDidLoad() {
        guard let window = window else {
            fatalError()
        }

        window.isOpaque = false
        window.styleMask = NSWindow.StyleMask([
            .nonactivatingPanel,
            .titled,
            .fullSizeContentView,
            .unifiedTitleAndToolbar
        ])

        if closeButton {
            window.styleMask = window.styleMask.union(.closable)
        }

        window.isMovableByWindowBackground = false
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.showsToolbarButton = false
        window.isMovable = false
        window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isHidden = true
        window.level = .floating

        window.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        window.contentView?.wantsLayer = true
        window.invalidateShadow()

        // Changes frame to move window to screen with status bar.
        window.makeKeyAndOrderFront(self)
        
        window.moveTopLeft(on: NSScreen.screens[0])
    }
}
