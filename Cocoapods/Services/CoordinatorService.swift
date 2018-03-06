import Foundation
import Cocoa

final class CoordinatorService {

    var progressCoordinator: ProgressCoordinator? = nil

    func coordinate(added podfile: Podfile) {
        Services.fileWatch.start(watching: podfile.url) { [unowned self] in
            self.coordinate(updated: podfile)
        }
    }

    func coordinate(updated podfile: Podfile) {
        let progress = Services.cocoapods.update(podfile)
        self.progressCoordinator = Services.userInterfaceService.show(progress)
        self.progressCoordinator?.ended = {
            self.progressCoordinator = nil
        }
    }
}

func display(_ text: String) {
    DispatchQueue.main.async {
        let alert = NSAlert()
        alert.messageText = "Info"
        alert.informativeText = text
        alert.runModal()
    }
}
