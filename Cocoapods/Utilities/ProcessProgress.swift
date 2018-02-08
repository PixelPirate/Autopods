import Foundation

final class ProcessProgress: Progress {

    let process: LoggingProcess
    var timer: Timer? = nil

    func funcy(_ x: Double) -> Double {
        switch x {
        case 0...0.25:
            let t = inverseLerp(from: 0, to: 0.25, value: x)
            return (0...0.35).at(t)
        case 0.25...0.375:
            let t = inverseLerp(from: 0.25, to: 0.375, value: x)
            return (0.35...0.4).at(t)
        case 0.375...0.575:
            let t = inverseLerp(from: 0.375, to: 0.575, value: x)
            return (0.4...0.5).at(t)
        case 0.575...1:
            let t = inverseLerp(from: 0.575, to: 1, value: x)
            return (0.5...0.99).at(t)
        default: return x
        }
    }

    init(process: LoggingProcess) {
        self.process = process
        super.init()

        let max = 7.0
        let start = CFAbsoluteTimeGetCurrent()
        let end = start + max
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
            guard self.status != .ended else {
                timer.invalidate()
                return
            }

            let current = CFAbsoluteTimeGetCurrent()
            let percent = inverseLerp(from: start, to: end, value: current)
            if percent > 1 {
                timer.invalidate()
            }
            self.status = .progress(self.funcy(percent))
        }

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let progress = self else {
                return
            }

            progress.process.waitUntilExit()

            guard progress.process.terminationStatus == 0 else {
                progress.status = .error(Error.processFailed(path: progress.process.launchPath ?? "", error: progress.process.error))
                return
            }

            progress.status = .ended
        }
    }

    deinit {
        process.terminate()
    }
}

extension ProcessProgress {

    enum Error: Swift.Error {
        case processFailed(path: String, error: String)
    }
}
