import Cocoa

final class FilesCollectionView: NSCollectionView {

    override func awakeFromNib() {
        super.awakeFromNib()

        #if swift(>=4.0)
            let NSURLPboardType = NSPasteboard.PasteboardType(kUTTypeURL as String)
        #endif
        registerForDraggedTypes([NSURLPboardType])
    }

    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = board[0] as? String
            else { return false }

        let suffix = URL(fileURLWithPath: path).lastPathComponent
        for ext in ["Podfile"] {
            if ext.lowercased() == suffix.lowercased() {
                return true
            }
        }
        return false
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            self.layer?.backgroundColor = NSColor.green.cgColor
            return .copy
        } else {
            return NSDragOperation()
        }
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            self.layer?.backgroundColor = NSColor.green.cgColor
            return .copy
        } else {
            return NSDragOperation()
        }
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }

    override func draggingEnded(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }

        let url = URL(fileURLWithPath: path)

        let podfile = Podfile(url: url)
        Services.podfiles.insert(podfile)

        return true
    }

//    override func deleteBackward(_ sender: Any?) {
//        print(selectionIndexes)
//    }
}
