import Cocoa

class PodfilesViewController: NSViewController {

    @IBOutlet weak var collectionView: FilesCollectionView!
    @IBOutlet weak var statusTextField: NSTextField!

    override func viewDidLoad() {
        collectionView.collectionViewLayout = ListLayout()
        collectionView.filesDelegate = self
        updateStatusText()

        NotificationCenter.default.addObserver(forName: PodfilesService.PodfilesUpdated,
                                               object: nil,
                                               queue: nil) { [weak self] _ in
            self?.podfilesUpdated()
        }
    }

    @IBAction func delete(_ sender: AnyObject) {
        let pods = Services.podfiles.podfiles
        let selectedPods = collectionView.selectionIndexes.map {
            return pods[$0]
        }

        for pod in selectedPods {
            Services.podfiles.remove(pod)
        }
    }
}

extension PodfilesViewController: FilesCollectionViewDelegate {

    func filesCollectionView(_ collectionView: FilesCollectionView, performImportFrom url: URL) {
        let importViewController = NSStoryboard(name: NSStoryboard.main, bundle: nil)
            .instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.import) as! ImportViewController
        presentViewControllerAsSheet(importViewController)
        importViewController.beginImport(url)
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
