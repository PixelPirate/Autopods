import Foundation

extension ClosedRange where Bound == Double {

    func at(_ index: Double) -> Double {
        return lerp(from: lowerBound, to: upperBound, percent: index)
    }
}
