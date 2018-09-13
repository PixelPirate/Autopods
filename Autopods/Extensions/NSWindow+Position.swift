import AppKit

extension NSWindow {

    private static let screenPaddingInsets = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    func moveTopLeft(on screen: NSScreen) {
        let origin = NSPoint(x: screen.visibleFrame.maxX - frame.size.width - NSWindow.screenPaddingInsets.right,
                             y: screen.visibleFrame.maxY - frame.size.height - NSWindow.screenPaddingInsets.top)
        setFrameOrigin(origin)
    }
}
