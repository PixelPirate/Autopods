import Foundation

final class PodfilesService {

    static let PodfilesUpdated = Notification.Name("com.piay.cocoapods.PodfilesUpdated")

    init() {
        for podfile in podfiles {
            PodfilesService.handle(added: podfile)
        }
    }

    var podfiles: OrderedSet<Podfile> {
        get {
            guard let data = UserDefaults.standard.array(forKey: "podfiles") as? [Data] else { return [] }
            let items = try! data.map {
                try PropertyListDecoder().decode(Podfile.self, from: $0)
            }
            return OrderedSet(items)
        }
        set {
            let dataArray = try! newValue.map(PropertyListEncoder().encode)
            UserDefaults.standard.set(dataArray, forKey: "podfiles")
            NotificationCenter.default.post(name: PodfilesService.PodfilesUpdated, object: self)
        }
    }

    func insert(_ podfile: Podfile) {
        var files = podfiles
        files.insert(podfile)
        podfiles = files

        PodfilesService.handle(added: podfile)
    }

    static func handle(added podfile: Podfile) {
        guard ProcessInfo.processInfo.processName != "System Preferences" else {
            return
        }

        Services.coordinator.coordinate(added: podfile)
    }

    func remove(_ podfile: Podfile) {
        var files = podfiles
        files.remove(podfile)
        podfiles = files
    }
}
