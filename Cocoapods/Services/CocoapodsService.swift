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

final class LoggingProcess {

    let process = Process()
    private(set) var output = ""
    private(set) var error = ""

    init() {
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        outputPipe.fileHandleForReading.readabilityHandler = { [weak self] fileHandle in
            let data = fileHandle.availableData
            FileHandle.standardOutput.write(data)
            if let string = String(data: data, encoding: .utf8) {
                self?.output.append(string)
            }
        }

        errorPipe.fileHandleForReading.readabilityHandler = { [weak self] fileHandle in
            let data = fileHandle.availableData
            FileHandle.standardError.write(data)
            if let string = String(data: data, encoding: .utf8) {
                self?.error.append(string)
            }
        }

        process.terminationHandler = { task in
            (task.standardError as? Pipe)?.fileHandleForReading.readabilityHandler = nil
            (task.standardOutput as? Pipe)?.fileHandleForReading.readabilityHandler = nil
        }
    }

    var launchPath: String? {
        set {
            process.launchPath = newValue
        }
        get {
            return process.launchPath
        }
    }

    var arguments: [String]? {
        set {
            process.arguments = newValue
        }
        get {
            return process.arguments
        }
    }

    var currentDirectoryPath: String {
        set {
            process.currentDirectoryPath = newValue
        }
        get {
            return process.currentDirectoryPath
        }
    }

    var environment: [String: String]? {
        set {
            process.environment = newValue
        }
        get {
            return process.environment
        }
    }

    func launch() {
        process.launch()
    }

    func waitUntilExit() {
        process.waitUntilExit()
    }

    var terminationStatus: Int32 {
        return process.terminationStatus
    }

    func terminate() {
        process.terminate()
    }
}
