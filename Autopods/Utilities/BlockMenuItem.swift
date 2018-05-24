import AppKit

class BlockMenuItem: NSMenuItem {
    let block: () -> Void

    init(title: String, block: @escaping () -> Void) {
        self.block = block
        super.init(title: title, action: #selector(performBlock), keyEquivalent: "")
        target = self
    }

    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func performBlock() {
        block()
    }
}
