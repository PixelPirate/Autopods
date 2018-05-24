import Cocoa

final class ListLayout: NSCollectionViewLayout {

    private var attributes: [IndexPath : NSCollectionViewLayoutAttributes] = [:]

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepare() {
        for section in 0..<collectionView!.numberOfSections {
            for item in 0..<collectionView!.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let height = 20 as CGFloat
                let y = height * CGFloat(item)
                let itemAttributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
                itemAttributes.frame = NSRect(x: 0, y: y, width: collectionView!.bounds.width, height: height)
                attributes[indexPath] = itemAttributes
            }
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        return attributes[indexPath]
    }

    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        return attributes.values.filter { rect.intersects($0.frame) }
    }

    override var collectionViewContentSize: NSSize {
        guard let dataSource = collectionView?.dataSource else { return .zero }
        var totalItems = 0
        let sections = 1 //dataSource.numberOfSections!(in: collectionView!)
        for section in 0..<sections {
            let items = dataSource.collectionView(collectionView!, numberOfItemsInSection: section)
            totalItems += items
        }

        let contentSize = NSSize(width: collectionView!.bounds.width, height: CGFloat(20 * totalItems))
        return contentSize
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        return true //collectionView?.bounds.width != newBounds.width
    }

//    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
//        return collectionView!.contentOffset
//    }
}
