import Foundation
import Cocoa

final class CoordinatorService {

    var progressCoordinator: ProgressCoordinator? = nil

    func coordinate(added podfile: Podfile) {
        let url = Repository.gitHeadURL(from: podfile.url) ?? podfile.url
        Services.fileWatch.start(watching: url) { [unowned self] in
            self.coordinate(updated: podfile)
        }
    }

    func coordinate(updated podfile: Podfile, launch: (Podfile) -> Progress = Services.cocoapods.install) {
        let progress = launch(podfile)
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
