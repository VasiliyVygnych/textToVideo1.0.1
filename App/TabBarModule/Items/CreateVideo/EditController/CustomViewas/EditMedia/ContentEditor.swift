//
//  ContentEditor.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 11.11.2024.
//

import UIKit
import SnapKit

class ContentEditor: UIView {
    
    var viewModel: HomeViewModelProtocol?
    private let cellIdentifier = "contentEditor"
    
    private var headerTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .regular)
        view.textAlignment = .center
        return view
    }()
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 213,
                                height: 108)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = .init(top: 10,
                                    left: 0,
                                    bottom: 10,
                                    right: 0)

        return layout
    }()
    lazy var collectionView: UICollectionView = {
       let view = UICollectionView(frame: .zero,
                                             collectionViewLayout: self.layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.register(MediaCell.self,
                      forCellWithReuseIdentifier: cellIdentifier)
        return view
   }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "customGrayColor56")
        addSubview()
        setupeColor()
        setupeText()
        setupeConstraints()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupeColor() {
        headerTitle.textColor = UIColor(named: "textGrayColor")
    }
    func setupeText() {
        headerTitle.text = "Chapter 1"
    }
    private func addSubview() {
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(headerTitle)
    }
    private func setupeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(headerTitle.snp.right).inset(10)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        headerTitle.snp.makeConstraints { make in
            make.left.equalTo(-10)
            make.width.greaterThanOrEqualTo(20)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        headerTitle.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
}
extension ContentEditor: UICollectionViewDataSource,
                             UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        20
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as? MediaCell else { return UICollectionViewCell() }
        cell.mediaButton.isHidden = true
        cell.mediaFile.backgroundColor = .systemBlue
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let collectionCell = self.collectionView.cellForItem(at: indexPath) {
            viewModel?.viewAnimate(view: collectionCell,
                                   duration: 0.2,
                                   scale: 0.96)
          
            
            
            
            
        }
    }
}
