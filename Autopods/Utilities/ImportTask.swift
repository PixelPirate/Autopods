import Foundation

protocol ImportTaskDelegate: class {
    func importTaskDidBeginScanning(_ importTask: ImportTask)
    func importTaskDidDetermineRemainingItems(_ importTask: ImportTask)
    func importTask(_ importTask: ImportTask, progressChanged progress: Double)
    func importTaskDidFinish(_ importTask: ImportTask)
}

class ImportTask {

    weak var delegate: ImportTaskDelegate?

    private let queue = DispatchQueue(label: "Autopods.ImportTask")

    private var importValid = true

    private(set) var podfileURLs: [URL] = []

    func beginImport(from url: URL) {
        queue.async {
            self.importValid = true

            DispatchQueue.main.async {
                self.delegate?.importTaskDidBeginScanning(self)
            }

            let fileCount = self.countOfFiles(in: url)

            DispatchQueue.main.async {
                self.delegate?.importTaskDidDetermineRemainingItems(self)
            }

            self.podfileURLs = self.podfileURLs(in: url, totalFileCount: fileCount)

            DispatchQueue.main.async {
                self.delegate?.importTaskDidFinish(self)
            }
        }
    }

    func cancel() {
        queue.async {
            self.importValid = false
        }
    }

    deinit {
        queue.async {
            self.importValid = false
        }
    }

    private func countOfFiles(in url: URL) -> Int {
        let keys: Set<URLResourceKey> = [.isDirectoryKey]

        let directoryEnumerator = FileManager.default.enumerator(
            at: url,
            includingPropertiesForKeys: Array(keys),
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
            )!

        return directoryEnumerator.reduce(into: 0, { (result, value) in
            guard
                importValid,
                let fileURL = value as? URL,
                let resourceValues = try? fileURL.resourceValues(forKeys: keys),
                resourceValues.isDirectory == true,
                let count = try? FileManager.default.contentsOfDirectory(at: fileURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).count
                else {
                    return
            }

            result += count
        })
    }

    private func podfileURLs(in url: URL, totalFileCount: Int) -> [URL] {
        var handledFiles = 0

        let keys: Set<URLResourceKey> = [.isDirectoryKey]

        let directoryEnumerator = FileManager.default.enumerator(
            at: url,
            includingPropertiesForKeys: Array(keys),
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
            )!

        let totalFileCount = Double(totalFileCount)
        return directoryEnumerator.compactMap {
            guard
                importValid,
                let fileURL = $0 as? URL,
                let resourceValues = try? fileURL.resourceValues(forKeys: keys),
                resourceValues.isDirectory == false
                else {
                    return nil
            }

            defer {
                let progress = Double(handledFiles) / totalFileCount

                DispatchQueue.main.async {
                    self.delegate?.importTask(self, progressChanged: progress)
                }
            }

            handledFiles += 1

            guard fileURL.lastPathComponent == "Podfile" else {
                return nil
            }

            return fileURL
        }
    }
}
