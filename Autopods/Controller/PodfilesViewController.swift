import Cocoa

class PodfilesViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var statusTextField: NSTextField!

    override func viewDidLoad() {
        collectionView.collectionViewLayout = ListLayout()
        updateStatusText()

        NotificationCenter.default.addObserver(forName: PodfilesService.PodfilesUpdated,
                                               object: nil,
                                               queue: nil) { [weak self] _ in
            self?.podfilesUpdated()
        }
    }

    @IBAction func delete(_ sender: AnyObject) {
        let indexe = collectionView.selectionIndexes
        let index = indexe.index(after: indexe.startIndex)
        let indexPath = IndexPath(item: indexe.first!, section: indexe[index])

        let pods = Services.podfiles.podfiles
        let podIndex = pods.index(pods.startIndex, offsetBy: indexPath.item)
        let pod = pods[podIndex]

        Services.podfiles.remove(pod)
    }
}

extension PodfilesViewController {

    private func podfilesUpdated() {
        collectionView.reloadData()
        updateStatusText()
    }
}

extension PodfilesViewController: NSCollectionViewDataSource {

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return Services.podfiles.podfiles.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CocoapodViewItem"), for: indexPath)
        guard let cocoapodViewItem = item as? CocoapodViewItem else { return item }
        let pods = Services.podfiles.podfiles
        let podIndex = pods.index(pods.startIndex, offsetBy: indexPath.item)
        let pod = pods[podIndex]
        cocoapodViewItem.representedObject = pod

        return cocoapodViewItem
    }
}

extension PodfilesViewController: NSCollectionViewDelegate {

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    }
}

private extension PodfilesViewController {

    func updateStatusText() {
        let numberOfPods = Services.podfiles.podfiles.count
        if numberOfPods == 0 {
            statusTextField.stringValue = "Drag a Podfile into Autopods to begin tracking."
        } else {
            let pluralSuffix = numberOfPods > 1 ? "s" : ""
            let text = String.localizedStringWithFormat("Tracking %d pod%@", numberOfPods, pluralSuffix)

            let darkGreen = NSColor(red: 0.342, green: 0.667, blue: 0.447, alpha: 1)
            let attributedText = NSMutableAttributedString(string: "✔︎ ", attributes: [NSAttributedStringKey.foregroundColor: darkGreen])
            attributedText.append(NSMutableAttributedString(string: text))

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(0..<attributedText.length))

            statusTextField.attributedStringValue = attributedText
        }
    }
}
