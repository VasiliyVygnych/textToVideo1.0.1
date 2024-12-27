//
//  MediaCell.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 11.11.2024.
//

import UIKit
import SnapKit

class MediaCell: UICollectionViewCell {
    
    var viewModel: HomeViewModelProtocol?
    
    var mediaFile: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    var mediaButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    private var buttonTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textAlignment = .center
        return view
    }()
    private var uploadImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        initialization()
        setupeView()
        setupeConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension MediaCell {
    func initialization() {
        contentView.addSubview(mediaFile)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        contentView.addSubview(mediaButton)
        mediaButton.addSubview(buttonTitle)
        mediaButton.addSubview(uploadImage)
    }
    func setupeView() {
        buttonTitle.text = HomeConstants.HomeText.uploadMedia.localized(LanguageConstant.appLaunguage)
        mediaButton.backgroundColor = HomeConstants.HomeColor.editButtoncolor
        buttonTitle.textColor = HomeConstants.HomeColor.customBlueColor
        uploadImage.image = HomeConstants.HomeImage.uploadImage
    }
    func setupeConstraint() {
        mediaFile.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mediaButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        uploadImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(21)
            make.bottom.equalTo(buttonTitle.snp.top).inset(-5)
        }
        buttonTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(15)
            make.bottom.equalToSuperview().inset(30)
        }
    }
}
