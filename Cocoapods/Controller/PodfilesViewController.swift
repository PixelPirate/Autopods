import Cocoa

class PodfilesViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!

    override func viewDidLoad() {
        collectionView.collectionViewLayout = ListLayout()

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

