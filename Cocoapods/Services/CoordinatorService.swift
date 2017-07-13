import Foundation

final class CoordinatorService {

    func coordinate(added podfile: Podfile) {
        Services.fileWatch.start(watching: podfile.url) {
            Services.cocoapods.update(podfile)
        }
    }
}
