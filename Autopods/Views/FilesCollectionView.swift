import Cocoa

protocol FilesCollectionViewDelegate: class {
    func filesCollectionView(_ collectionView: FilesCollectionView, performImportFrom url: URL)
}

final class FilesCollectionView: NSCollectionView {

    static let dropableFilenames = ["Podfile"]

    weak var filesDelegate: FilesCollectionViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        #if swift(>=4.0)
            let NSURLPboardType = NSPasteboard.PasteboardType(kUTTypeURL as String)
        #endif
        registerForDraggedTypes([NSURLPboardType])
    }

    fileprivate func isValidDraggingObject(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = board[0] as? String
            else { return false }

        if FileManager.default.isDirectory(atPath: path) {
            return true
        }

        return isPodfile(at: URL(fileURLWithPath: path))
    }

    private func isPodfile(at url: URL) -> Bool {
        guard !FileManager.default.isDirectory(atPath: url.path) else {
            return false
        }

        for filename in FilesCollectionView.dropableFilenames {
            if filename.caseInsensitiveCompare(url.lastPathComponent) == .orderedSame {
                return true
            }
        }
        return false
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if isValidDraggingObject(sender) == true {
            self.layer?.backgroundColor = NSColor.green.cgColor
            return .copy
        } else {
            return NSDragOperation()
        }
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        if isValidDraggingObject(sender) == true {
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
        guard
            let pasteboard = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteboard[0] as? String
        else {
            return false
        }

        if FileManager.default.isDirectory(atPath: path) {
            filesDelegate?.filesCollectionView(self, performImportFrom: URL(fileURLWithPath: path))
        } else {
            let url = URL(fileURLWithPath: path)

            let podfile = Podfile(url: url)
            Services.podfiles.insert(podfile)
        }

        return true
    }
}

fileprivate extension FileManager {

    func isDirectory(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory), isDirectory.boolValue {
            return true
        }
        return false
    }
}
