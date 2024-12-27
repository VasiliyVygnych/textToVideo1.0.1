//
//  CategoryCell.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 09.12.2024.
//

import UIKit
import SnapKit

class CategoryCell: UICollectionViewCell {
    
    var viewModel: HomeViewModelProtocol?
    
    private var previewImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 14
        view.contentMode = .scaleToFill
        return view
    }()
    private var nameTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.2
       return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
        setupeConstraint()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureData(_ model: CategoryData) {
        previewImage.backgroundColor = .systemBlue
        previewImage.image = model.image
        nameTitle.text = model.name
    }
}
private extension CategoryCell {
    func initialization() {
        contentView.addSubview(previewImage)
        contentView.addSubview(nameTitle)
    }
    func setupeConstraint() {
        previewImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(167)
        }
        nameTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(previewImage.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
