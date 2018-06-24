//
//  CarouselCell.swift
//  CarouselCollectionLayout
//
//  Created by Bartosz Kamiński on 11/06/2018.
//  Copyright © 2018 Bartosz Kamiński. All rights reserved.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    
    // MARK: - Public Properties

	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

    // MARK: - Private Properties

	private let maskShapeLayer: CAShapeLayer = CAShapeLayer()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .red
		layer.mask = maskShapeLayer
        setupImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

	override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		maskShapeLayer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 12).cgPath
	}
    
    // MARK: - Private Methods
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
        }
    }
}

extension CarouselCell {
    class var reusableIndentifer: String { return String(describing: self) }
}
