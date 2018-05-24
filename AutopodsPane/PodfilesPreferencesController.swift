import Cocoa
import ServiceManagement

class PodfilesPreferencesController: NSObject {

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var enableUpdatesSwitch: NSButton!
    
    override func awakeFromNib() {
        collectionView.collectionViewLayout = ListLayout()
        enableUpdatesSwitch.state = Services.configuration.automaticUpdates ? .on : .off

        NotificationCenter.default.addObserver(forName: PodfilesService.PodfilesUpdated,
                                               object: nil,
                                               queue: nil) { [weak self] _ in
                                                self?.podfilesUpdated()
        }
    }

    @IBAction func automaticUpdateChanged(_ sender: NSButton) {
//        let a: [String] = SMCopyAllJobDictionaries(kSMDomainUserLaunchd) as! [String]
//        if let CFArray = SMCopyAllJobDictionaries(kSMDomainUserLaunchd) {
//            let NSArray: NSArray = CFArray.takeUnretainedValue()
//            let array = Array(NSArray)
//            for item in array {
//                display("\(item)")
//            }
//        }

        if sender.state == .on {
            let bundle = AutopodsPane.shared().bundle
            guard let url = bundle.url(forResource: "Autopods", withExtension: "app") else {
                return
            }
            try! NSWorkspace.shared.launchApplication(at: url, options: .andHide, configuration: [:])


        } else {

        }

        Services.configuration.automaticUpdates = sender.state == .on
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

extension PodfilesPreferencesController {

    private func podfilesUpdated() {
        collectionView.reloadData()
    }
}

extension PodfilesPreferencesController: NSCollectionViewDataSource {

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

extension PodfilesPreferencesController: NSCollectionViewDelegate {

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    }
}
