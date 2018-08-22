import Foundation

final class ProcessProgress: Progress {

    let process: LoggingProcess
    var timer: Timer? = nil

    func funcy(_ x: Double) -> Double {
        switch x {
        case ...0.25:
            let t = inverseLerp(from: 0, to: 0.25, value: max(x, 0))
            return (0...0.35).at(t)
        case 0.25...0.375:
            let t = inverseLerp(from: 0.25, to: 0.375, value: x)
            return (0.35...0.4).at(t)
        case 0.375...0.575:
            let t = inverseLerp(from: 0.375, to: 0.575, value: x)
            return (0.4...0.5).at(t)
        case 0.575...:
            let t = inverseLerp(from: 0.575, to: 1, value: min(x, 1))
            return (0.5...0.9).at(t)
        default: return x
        }
    }

    init(process: LoggingProcess) {
        self.process = process
        super.init()

        let max = 10.0
        let start = CFAbsoluteTimeGetCurrent()
        let end = start + max
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
            let current = CFAbsoluteTimeGetCurrent()
            let percent = inverseLerp(from: start, to: end, value: current)
            if percent > 1 {
                timer.invalidate()
            }
            self.status = .progress(self.funcy(percent))
        }

// Debug, always show error.
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.status = .error(Error.processFailed(path: self.process.currentDirectoryPath , error: self.process.error))
//        }

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let progress = self else {
                return
            }

            progress.process.waitUntilExit()

            progress.timer?.invalidate()

            guard progress.process.terminationStatus == 0 else {
                progress.status = .error(Error.processFailed(
                    path: progress.process.currentDirectoryPath,
                    error: progress.process.error)
                )
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
