import Foundation

final class CocoapodsService {

    var processes: [Process] = []

    func update(_ podfile: Podfile) {
        print("update: ", podfile.url)

        let dir = podfile.url.deletingLastPathComponent()

        let process = Process()
        process.launchPath = "/usr/local/bin/pod"
        process.arguments = ["install"]
        process.currentDirectoryPath = dir.path
        process.launch()
        process.standardOutput = stdout
        process.standardError = stderr
        processes.append(process)
    }
}
