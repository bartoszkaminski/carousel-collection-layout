//
//  ViewController.swift
//  CarouselCollectionLayout
//
//  Created by Bartosz Kamiński on 11/06/2018.
//  Copyright © 2018 Bartosz Kamiński. All rights reserved.
//

import UIKit
import SnapKit

class CarouselViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = CarouselLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reusableIndentifer)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(100)
        }
    }
}

extension CarouselViewController: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.reusableIndentifer, for: indexPath) as! CarouselCell
        cell.label.text = "Text"
        return cell
    }
}

extension CarouselViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 60)
    }
}
