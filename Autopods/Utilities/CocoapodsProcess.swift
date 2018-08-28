import Foundation

final class CocoapodsProcess: LoggingProcess {
    private var retryProcess: CocoapodsProcess?

    override func launch() {
        guard isValidLaunchPath else {
            fatalError("Invalid launch path: The path does not end with \"pod\".")
        }

        super.launch()
    }

    override func waitUntilExit() {
        super.waitUntilExit()

        if super.terminationStatus != 0 {
            let updateSuggestions = self.updateSuggestion()
            guard !updateSuggestions.isEmpty else {
                return
            }
            retry(withUpdateSuggestions: updateSuggestions)
        }
    }

    private func updateSuggestion() -> [String] {
        let regex = try! NSRegularExpression(pattern: "You should run `pod update ([\\w\\s]*)`")
        guard
            let match = regex.firstMatch(
                in: completeOutput,
                range: NSRange(location: 0, length: completeOutput.utf16.count)
            )
            else {
                return []
        }

        let nsRange = match.range(at: 1)
        guard let range = Range(nsRange, in: completeOutput) else {
            return []
        }

        return completeOutput[range].components(separatedBy: .whitespaces)
    }

    private func retry(withUpdateSuggestions updateSuggestions: [String]) {
        //TODO: Color the progress window yellow to singal the fix-it process.
        print("Beginning automated fix-it: \"pod update \(updateSuggestions.joined(separator: " "))\"")

        let process = CocoapodsProcess()
        process.launchPath = launchPath
        process.arguments = ["update"] + updateSuggestions
        process.currentDirectoryPath = currentDirectoryPath
        var environment = ProcessInfo.processInfo.environment
        environment["LANG"] = "en_US.UTF-8"
        process.environment = environment

        retryProcess = process
        process.launch()
        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            print("Automated fix-it failed.")
            print(process.completeOutput)
            //TODO: Add ouput to error window.
            return
        }
    }

    override var terminationStatus: Int32 {
        return retryProcess?.terminationStatus ?? super.terminationStatus
    }

    private var isValidLaunchPath: Bool {
        guard let launchPath = self.launchPath else {
            return false
        }

        let launchURL = URL(fileURLWithPath: launchPath)

        guard launchURL.lastPathComponent == "pod" else {
            return false
        }

        return true
    }
}
