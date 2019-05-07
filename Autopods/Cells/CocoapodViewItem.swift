import Cocoa

final class CocoapodViewItem: NSCollectionViewItem {

    @IBOutlet weak var pathControl: NSPathControl!

    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue

            pathControl.backgroundColor = isSelected ? NSColor.selectedControlColor : NSColor.clear
            view.setNeedsDisplay(view.bounds)
        }
    }

    override var representedObject: Any? {
        didSet {
            pathControl.url = (representedObject as? Podfile)?.url
        }
    }
}
