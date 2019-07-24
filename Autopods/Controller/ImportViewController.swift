import Cocoa

class ImportViewController: NSViewController {

    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var statusTextField: NSTextField!

    private let importTask = ImportTask()

    override func awakeFromNib() {
        importTask.delegate = self
    }

    override func viewWillAppear() {
        progressIndicator.startAnimation(self)
    }

    @IBAction func cancel(_ sender: Any?) {
        importTask.cancel()
    }

    func beginImport(_ url: URL) {
        progressIndicator.doubleValue = 0
        progressIndicator.isIndeterminate = true
        importTask.beginImport(from: url)
    }
}

extension ImportViewController: ImportTaskDelegate {

    func importTaskDidBeginScanning(_ importTask: ImportTask) {
        progressIndicator.doubleValue = 0
        progressIndicator.isIndeterminate = true
    }

    func importTaskDidDetermineRemainingItems(_ importTask: ImportTask) {
        progressIndicator.doubleValue = 0
        progressIndicator.isIndeterminate = false
    }

    func importTask(_ importTask: ImportTask, progressChanged progress: Double) {
        progressIndicator.doubleValue = progress * 100
    }

    func importTaskDidFinish(_ importTask: ImportTask) {
        DispatchQueue.main.async {
            for podfileURL in importTask.podfileURLs {
                let podfile = Podfile(url: podfileURL)
                Services.podfiles.insert(podfile)
            }
            self.dismiss(nil)
        }
    }
}
