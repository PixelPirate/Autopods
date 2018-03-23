import Foundation

final class CocoapodsService {

    var processes: [LoggingProcess] = []

    func update(_ podfile: Podfile) -> Progress {
        return process(for: podfile, withArgument: "update")
    }

    func install(_ podfile: Podfile) -> Progress {
        return process(for: podfile, withArgument: "install")
    }

    private func process(for podfile: Podfile, withArgument argument: String) -> Progress {
        print("\(argument): ", podfile.url)

        let dir = podfile.url.deletingLastPathComponent()

        let process = LoggingProcess()
        process.launchPath = "/usr/local/bin/pod"
        process.arguments = [argument]
        process.currentDirectoryPath = dir.path
        var environment = ProcessInfo.processInfo.environment
        environment["LANG"] = "en_US.UTF-8"
        process.environment = environment

        process.launch()
        processes.append(process)

        return ProcessProgress(process: process)
    }
}
