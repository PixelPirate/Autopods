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

    func isInSync(_ podfile: Podfile) -> Bool {
        func contents(of url: URL) -> [String: String] {
            var checksums: [String: String] = [:]
            let file = try! String(contentsOf: url)
            let regex = try! NSRegularExpression(pattern: "(?<id>\\w+): (?<checksum>\\w+)\\n")
            let matches = regex.matches(in: file, range: NSRange.init(file.startIndex..., in: file))
            for match in matches {
                let id = String(file[Range(match.range(withName: "id"), in: file)!])
                let checksum = String(file[Range(match.range(withName: "checksum"), in: file)!])
                checksums[id] = checksum
            }
            return checksums
        }

        let lockfile = contents(of: podfile.lockFileURL)
        let manifest = contents(of: podfile.manifestURL)

        return lockfile == manifest
    }
}
