import Foundation

final class ConfigurationService {

    static let ConfigurationUpdated = Notification.Name("com.piay.cocoapods.ConfigurationUpdated")

    enum OptionKeys: String {
        case automaticInstall
        case IsTrackingFiles
    }

    func registerDefaults() {
        UserDefaults.standard.register(defaults: [
            OptionKeys.IsTrackingFiles.rawValue : true]
        )
    }

    var automaticUpdates: Bool {
        get {
            return UserDefaults.standard.bool(forKey: OptionKeys.automaticInstall.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: OptionKeys.automaticInstall.rawValue)
            DistributedNotificationCenter.default().post(name: ConfigurationService.ConfigurationUpdated, object: nil)
        }
    }

    var isTrackingFiles: Bool {
        get {
            return UserDefaults.standard.bool(forKey: OptionKeys.IsTrackingFiles.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: OptionKeys.IsTrackingFiles.rawValue)
            DistributedNotificationCenter.default().post(name: ConfigurationService.ConfigurationUpdated, object: nil)
        }
    }
}
