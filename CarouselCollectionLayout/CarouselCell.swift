//
//  CarouselCell.swift
//  CarouselCollectionLayout
//
//  Created by Bartosz Kamiński on 11/06/2018.
//  Copyright © 2018 Bartosz Kamiński. All rights reserved.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .red
		layer.mask = maskShapeLayer
        setupLabel()
    }

	private let maskShapeLayer: CAShapeLayer = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		maskShapeLayer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 12).cgPath
	}
    
    private func setupLabel() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.top.greaterThanOrEqualToSuperview()
            make.trailing.bottom.lessThanOrEqualToSuperview()
        }
    }
}

extension CarouselCell {
    class var reusableIndentifer: String { return String(describing: self) }
}
