import CoreGraphics

protocol Numeric: ExpressibleByIntegerLiteral {
    static func + (lhs: Self, rhs: Self) -> Self
    static func - (lhs: Self, rhs: Self) -> Self
    static func * (lhs: Self, rhs: Self) -> Self
    static func / (lhs: Self, rhs: Self) -> Self
}

extension Float: Numeric {}
extension CGFloat: Numeric {}
extension Double: Numeric {}

extension Int: Numeric {}
extension Int8: Numeric {}
extension Int16: Numeric {}
extension Int32: Numeric {}
extension Int64: Numeric {}

extension UInt: Numeric {}
extension UInt8: Numeric {}
extension UInt16: Numeric {}
extension UInt32: Numeric {}
extension UInt64: Numeric {}

func lerp<N: Numeric>(from a: N, to b: N, percent t: N) -> N {
    return (1 - t) * a + t * b
}

func inverseLerp<N: Numeric>(from: N, to: N, value: N) -> N {
    let difference = to - from
    let percent = (value - from) / difference
    return percent
}

func clamp<T: Comparable>(min minimal: T, max maximal: T, value: T) -> T {
    return min(max(value, minimal), maximal)
}
