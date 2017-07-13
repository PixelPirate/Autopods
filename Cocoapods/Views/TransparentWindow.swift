//
//  TransparentWindow.swift
//  TestWindow
//
//  Created by Barbara Reichart on 20/01/17.
//  Copyright © 2017 Barbara Reichart. All rights reserved.
//

import Cocoa

class TransparentWindowController: NSWindowController {

    @IBInspectable var closeButton: Bool = false

    override func windowDidLoad() {
        guard let window = window else {
            fatalError()
        }

        window.isOpaque = false
        window.styleMask = NSWindowStyleMask([
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
        window.standardWindowButton(NSWindowButton.fullScreenButton)?.isHidden = true
        window.standardWindowButton(NSWindowButton.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(NSWindowButton.zoomButton)?.isHidden = true
        window.level = Int(CGWindowLevelForKey(.floatingWindow))

        window.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        window.contentView?.wantsLayer = true
        window.invalidateShadow()

        //.screens()[0] is the screen with the menu bar.
        if let screen = NSScreen.main() {
            let visibleFrame = screen.visibleFrame
            let windowSize = window.frame.size
            let origin = NSPoint(x: visibleFrame.origin.x + visibleFrame.size.width - windowSize.width - 20,
                                 y: visibleFrame.origin.y + visibleFrame.size.height - windowSize.height - 20)
            window.setFrameOrigin(origin)
        }
        window.makeKeyAndOrderFront(self)
    }
}
