import Foundation

final class PodfilesService {

    static let PodfilesUpdated = Notification.Name("com.piay.cocoapods.PodfilesUpdated")

    init() {
        for podfile in podfiles {
            Services.coordinator.coordinate(added: podfile)
        }
    }

    var podfiles: Set<Podfile> {
        get {
            guard let data = UserDefaults.standard.array(forKey: "podfiles") as? [Data] else { return [] }
            let items = try! data.map {
                try PropertyListDecoder().decode(Podfile.self, from: $0)
            }
            return Set(items)
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

        Services.coordinator.coordinate(added: podfile)
    }

    func remove(_ podfile: Podfile) {
        var files = podfiles
        files.remove(podfile)
        podfiles = files
    }
}
