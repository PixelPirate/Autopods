import Foundation

/// An ordered set is an ordered collection of instances of `Element` in which
/// uniqueness of the objects is guaranteed.
public struct OrderedSet<E: Hashable>: Equatable, Collection {
    public typealias Element = E
    public typealias Index = Int

    public typealias Indices = Range<Int>

    private var elements: NSMutableOrderedSet

    /// Creates an empty ordered set.
    public init() {
        self.elements = NSMutableOrderedSet()
    }

    /// Creates an ordered set with the contents of `array`.
    ///
    /// If an element occurs more than once in `element`, only the first one
    /// will be included.
    public init(_ array: [Element]) {
        self.init()
        for element in array {
            insert(element)
        }
    }

    // MARK: Working with an ordered set
    /// The number of elements the ordered set stores.
    public var count: Int { return elements.count }

    /// Returns `true` if the set is empty.
    public var isEmpty: Bool { return elements.count == 0 }

    /// Returns the contents of the set as an array.
    public var contents: [Element] { return elements.array as! [Element] }

    /// Returns `true` if the ordered set contains `member`.
    public func contains(_ member: Element) -> Bool {
        return elements.contains(member)
    }

    /// Adds an element to the ordered set.
    ///
    /// If it already contains the element, then the set is unchanged.
    ///
    /// - returns: True if the item was inserted.
    @discardableResult
    public mutating func insert(_ newElement: Element) -> Bool {
        let inserted = !elements.contains(newElement)
        elements.add(newElement)
        return inserted
    }

    /// Remove and return the element at the beginning of the ordered set.
    public mutating func removeFirst() -> Element {
        let firstElement = elements.object(at: 0) as! Element
        elements.removeObject(at: 0)
        return firstElement
    }

    /// Remove and return the element at the end of the ordered set.
    public mutating func removeLast() -> Element {
        let lastElement = elements.object(at: elements.count - 1) as! Element
        elements.removeObject(at: elements.count - 1)
        return lastElement
    }

    /// Remove all elements.
    public mutating func removeAll(keepingCapacity keepCapacity: Bool) {
        elements.removeAllObjects()
    }

    public mutating func remove(_ element: Element) {
        elements.remove(element)
    }
}

extension OrderedSet: ExpressibleByArrayLiteral {
    /// Create an instance initialized with `elements`.
    ///
    /// If an element occurs more than once in `element`, only the first one
    /// will be included.
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

extension OrderedSet: RandomAccessCollection {
    public var startIndex: Int { return contents.startIndex }
    public var endIndex: Int { return contents.endIndex }
    public subscript(index: Int) -> Element {
        return contents[index]
    }
}

public func == <T>(lhs: OrderedSet<T>, rhs: OrderedSet<T>) -> Bool {
    return lhs.contents == rhs.contents
}

extension OrderedSet: Hashable where Element: Hashable { }
