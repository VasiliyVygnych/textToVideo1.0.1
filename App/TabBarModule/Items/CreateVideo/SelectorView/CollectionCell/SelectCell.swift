//
//  SelectCell.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 05.12.2024.
//

import UIKit
import SnapKit

class SelectCell: UICollectionViewCell {
    
    var previewImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
         return view
     }()
    private var nameTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 13,
                                weight: .semibold)
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 2
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.2
        return view
    }()
    var createButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 22
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        return view
    }()
    var soonView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
         return view
     }()
    private var soonViewTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
        view.numberOfLines = 2
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.2
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        initialization()
        setupeConstraint()
        setupeView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupeView() {
        soonView.image = UIImage(named: "soonViewImage")
        soonViewTitle.text = "Opening soon".localized(LanguageConstant.appLaunguage)
        createButton.setTitle("Create now".localized(LanguageConstant.appLaunguage),
                              for: .normal)
        createButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        createButton.setTitleColor(.white,
                                   for: .normal)
    }
    func configure(_ model: SelectorModel) {
        previewImage.backgroundColor = .systemBlue
        previewImage.image = model.previewImage
        nameTitle.text = model.title
    }
}
private extension SelectCell {
    func initialization() {
        contentView.addSubview(previewImage)
        contentView.addSubview(soonView)
        soonView.addSubview(soonViewTitle)
        soonView.isHidden = true
        contentView.addSubview(nameTitle)
        contentView.addSubview(createButton)
    }
    func setupeConstraint() {
        previewImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.width.equalTo(183)
            make.centerX.equalToSuperview()
        }
        soonView.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(previewImage)
            make.height.equalTo(35)
        }
        soonViewTitle.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(30)
        }
        nameTitle.snp.makeConstraints { make in
            make.top.equalTo(previewImage.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        createButton.snp.makeConstraints { make in
            make.top.equalTo(nameTitle.snp.bottom).offset(20)
            make.width.equalTo(previewImage)
            make.height.equalTo(46)
            make.centerX.equalToSuperview()
        }
    }
}
