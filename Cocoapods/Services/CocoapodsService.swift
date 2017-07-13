import Foundation

final class CocoapodsService {

    var processes: [Process] = []

    func update(_ podfile: Podfile) -> Progress {
        print("update: ", podfile.url)

        let dir = podfile.url.deletingLastPathComponent()

        let process = Process()
        process.launchPath = "/usr/local/bin/pod"
        process.arguments = ["install"]
        process.currentDirectoryPath = dir.path
        var environment = ProcessInfo.processInfo.environment
        environment["LANG"] = "en_US.UTF-8"
        process.environment = environment

        process.standardOutput = FileHandle.standardOutput
        process.standardError = FileHandle.standardError
        process.launch()
        processes.append(process)

        return ProcessProgress(process: process)
    }
}
