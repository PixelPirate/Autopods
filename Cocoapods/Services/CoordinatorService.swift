import Foundation

final class CoordinatorService {

    var progressCoordinator: ProgressCoordinator? = nil

    func coordinate(added podfile: Podfile) {
        Services.fileWatch.start(watching: podfile.url) { [unowned self] in
            let progress = Services.cocoapods.update(podfile)
            self.progressCoordinator = Services.userInterfaceService.show(progress)
            self.progressCoordinator?.ended = {
                self.progressCoordinator = nil
            }
        }
    }
}
