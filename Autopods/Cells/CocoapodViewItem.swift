import Cocoa

final class CocoapodViewItem: NSCollectionViewItem {

    @IBOutlet weak var pathControl: NSPathControl!

    override var representedObject: Any? {
        didSet {
            pathControl.url = (representedObject as? Podfile)?.url
        }
    }
}
