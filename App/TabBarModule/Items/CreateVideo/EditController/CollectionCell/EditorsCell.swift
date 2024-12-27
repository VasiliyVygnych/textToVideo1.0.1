//
//  EditorsCell.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 11.11.2024.
//

import UIKit
import SnapKit

class EditorsCell: UICollectionViewCell {
    
    var viewModel: HomeViewModelProtocol?
    
    override var isSelected: Bool {
        didSet {
            nameTitle.textColor = isSelected ? UIColor.white : HomeConstants.HomeColor.customGrayColor
            selectImage.isHidden = isSelected ? false : true
        }
    }
    
    var nameTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .semibold)
        view.textColor = HomeConstants.HomeColor.customGrayColor
        view.textAlignment = .left
       return view
    }()
   private var selectImage: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "selectEditors")
        view.isHidden = true
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        initialization()
        setupeConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension EditorsCell {
    func initialization() {
        contentView.addSubview(nameTitle)
        contentView.addSubview(selectImage)
    }
    func setupeConstraint() {
        nameTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.equalToSuperview()
            make.height.equalTo(20)
            make.right.equalTo(-15)
        }
        selectImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(nameTitle.snp.right)
            make.height.equalTo(5)
            make.bottom.equalToSuperview()
        }
    }
}
