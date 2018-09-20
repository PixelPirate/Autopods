import Foundation

final class CocoapodsService {

    enum Error: Swift.Error {
        case noPodfile
    }

    var processes: [LoggingProcess] = []

    private static let podfileLine = try! NSRegularExpression(pattern: "(?<id>\\w+): (?<checksum>\\w+)\\n")

    func update(_ podfile: Podfile) -> Progress {
        return process(for: podfile, withArgument: "update")
    }

    func install(_ podfile: Podfile) -> Progress {
        return process(for: podfile, withArgument: "install")
    }

    private func process(for podfile: Podfile, withArgument argument: String) -> Progress {
        print("\(argument): ", podfile.url)

        let dir = podfile.url.deletingLastPathComponent()

        let process = CocoapodsProcess()
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

    func isInSync(_ podfile: Podfile) throws -> Bool {
        func contents(of url: URL) throws -> [String: String] {
            var checksums: [String: String] = [:]
            guard let file = try? String(contentsOf: url) else {
                throw Error.noPodfile
            }
            let matches = CocoapodsService.podfileLine.matches(in: file, range: NSRange.init(file.startIndex..., in: file))
            for match in matches {
                let id = String(file[Range(match.range(withName: "id"), in: file)!])
                let checksum = String(file[Range(match.range(withName: "checksum"), in: file)!])
                checksums[id] = checksum
            }
            return checksums
        }

        let lockfile = try contents(of: podfile.lockFileURL)
        let manifest = try contents(of: podfile.manifestURL)

        return lockfile == manifest
    }
}
