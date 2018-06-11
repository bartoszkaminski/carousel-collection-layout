//
//  CarouselLayout.swift
//  CarouselCollectionLayout
//
//  Created by Bartosz Kamiński on 11/06/2018.
//  Copyright © 2018 Bartosz Kamiński. All rights reserved.
//

import UIKit

class CarouselLayout: UICollectionViewLayout {
    
    // MARK: - Public Properties
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: horizontalEdges.right - horizontalEdges.left, height: 100)
    }
    
    // MARK: - Private Properties

    private var cachedItemsAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var horizontalEdges: (left: CGFloat, right: CGFloat) = (left: 0, right: 0)
    private let itemSize = CGSize(width: 100, height: 60)
    private let spacing: CGFloat = 30
    
    // MARK: - Public Methods
    
    override open func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        updateInsets()
        guard cachedItemsAttributes.isEmpty else { return }
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        for item in 0..<itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            cachedItemsAttributes[indexPath] = rawAttributesForItem(at: indexPath)
        }
        horizontalEdges.left = cachedItemsAttributes.values.map { $0.frame.minX }.min() ?? 0
        horizontalEdges.right = cachedItemsAttributes.values.map { $0.frame.maxX }.max() ?? 0
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let cachedItemsAttributes = self.cachedItemsAttributes
            .map { self.shiftedAttributes(from: $1) }
        return cachedItemsAttributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView, !collectionView.isPagingEnabled
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        let midSide = collectionView.bounds.size.width / 2
        let proposedContentOffsetCenterOrigin = proposedContentOffset.x + midSide
        let closestAttribute = findClosestAttributes(toPoint: CGPoint(x: proposedContentOffsetCenterOrigin, y: proposedContentOffsetCenterOrigin)) ?? UICollectionViewLayoutAttributes()
        return CGPoint(x: floor(closestAttribute.center.x - midSide), y: proposedContentOffset.y)
    }
    
    // MARK: - Invalidate layout
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if newBounds.size != collectionView?.bounds.size { invalidateCache() }
        return true
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if context.invalidateDataSourceCounts { invalidateCache() }
        super.invalidateLayout(with: context)
    }
    
    private func invalidateCache() {
        cachedItemsAttributes.removeAll()
    }
    
    // MARK: - Items
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = cachedItemsAttributes[indexPath] else { fatalError("No attributes cached") }
        return shiftedAttributes(from: attributes)
    }
    
    private func rawAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        guard let collectionView = collectionView else { return nil }
        attributes.frame.size = itemSize
        attributes.frame.origin.y = (collectionView.bounds.height - itemSize.height)/2
        if let previousAttributes = cachedItemsAttributes.first(where: { $0.key == IndexPath(row: indexPath.item - 1, section: indexPath.section) })?.value {
            attributes.frame.origin.x = previousAttributes.frame.maxX + spacing
        }
        return attributes
    }
    
    private func shiftedAttributes(from attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let attributes = attributes.copy() as? UICollectionViewLayoutAttributes else { fatalError("Couldn't copy attributes") }
        let focusedIndex = continousFocusedIndex()
        let roundedFocusedIndex = round(focusedIndex)
        guard attributes.indexPath.item != Int(roundedFocusedIndex) else { return attributes }
        let threshold = focusedIndex >= roundedFocusedIndex ? roundedFocusedIndex + 0.5 : roundedFocusedIndex - 0.5
        let normalizedDistanceFromThreshold = abs(focusedIndex - threshold) / 0.5
        let translate = 30 * normalizedDistanceFromThreshold
        let translateDirection: CGFloat = attributes.indexPath.item < Int(roundedFocusedIndex) ? -1 : 1
        attributes.transform = CGAffineTransform(translationX: translateDirection * translate, y: 0)
        return attributes
    }

    // MARK: - Private Methods
    
    private func findClosestAttributes(toPoint point: CGPoint) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView, !collectionView.isPagingEnabled,
            let layoutAttributes = layoutAttributesForElements(in: collectionView.bounds)
            else { return nil }
        return layoutAttributes.min(by: { abs($0.center.x - point.x) < abs($1.center.x - point.x) })
    }
    
    private func updateInsets() {
        guard let collectionView = collectionView else { return }
        collectionView.contentInset.left = (collectionView.bounds.size.width - itemSize.width) / 2
        collectionView.contentInset.right = (collectionView.bounds.size.width - itemSize.width) / 2
    }
    
    private func continousFocusedIndex() -> CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let collectionCenter = collectionView.frame.size.width / 2
        let offset = collectionView.contentOffset.x
        let normalizedPosition = collectionCenter + offset - itemSize.width / 2
        let cellWithSpacingWidth: CGFloat = itemSize.width + spacing
        return normalizedPosition / cellWithSpacingWidth
    }
}
