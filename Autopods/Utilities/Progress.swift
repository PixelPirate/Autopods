class Progress {
    internal(set) var status: Status = .pending {
        didSet {
            changed?()
        }
    }

    var changed: (() -> Void)? = nil
}

extension Progress {

    enum Status {
        case pending
        case progress(Double)
        case ended
        case error(Error)
    }
}

extension Progress.Status: Equatable {

    static func ==(lhs: Progress.Status, rhs: Progress.Status) -> Bool {
        switch (lhs, rhs) {
        case (.pending, pending): return true
        case (.progress(let p1), .progress(let p2)) where p1 == p2: return true
        case (.ended, .ended): return true
        default: return false
        }
    }
}
