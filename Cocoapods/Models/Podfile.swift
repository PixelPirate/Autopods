import Foundation

struct Podfile: Codable {
    let url: URL
}

extension Podfile: Equatable {

    static func ==(lhs: Podfile, rhs: Podfile) -> Bool {
        return lhs.url == rhs.url
    }
}

extension Podfile: Hashable {

    var hashValue: Int {
        return url.hashValue
    }
}
