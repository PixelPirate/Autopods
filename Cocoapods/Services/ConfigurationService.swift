import Foundation

final class ConfigurationService {

    static let ConfigurationUpdated = Notification.Name("com.piay.cocoapods.ConfigurationUpdated")

    var automaticUpdates: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "AutomaticInstall")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AutomaticInstall")
            DistributedNotificationCenter.default().post(name: ConfigurationService.ConfigurationUpdated, object: nil)
        }
    }
}
