import Foundation

final class CocoapodsService {

    var processes: [LoggingProcess] = []

    func update(_ podfile: Podfile) -> Progress {
        print("update: ", podfile.url)

        let dir = podfile.url.deletingLastPathComponent()

        let process = LoggingProcess()
        process.launchPath = "/usr/local/bin/pod"
        process.arguments = ["install"]
        process.currentDirectoryPath = dir.path
        var environment = ProcessInfo.processInfo.environment
        environment["LANG"] = "en_US.UTF-8"
        process.environment = environment

        process.launch()
        processes.append(process)

        return ProcessProgress(process: process)
    }
}
