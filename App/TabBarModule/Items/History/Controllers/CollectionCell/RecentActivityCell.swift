//
//  RecentActivityCell.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit
import SnapKit

class RecentActivityCell: UICollectionViewCell {
    
    var viewModel: HomeViewModelProtocol?
    
    var conteinerView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
         return view
     }()
    private let timeImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    private var nameTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 13,
                                weight: .semibold)
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()
    private let arrowImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.alpha = 0.3
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        initialization()
        setupeConstraint()
        setupeView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupeView() {
        nameTitle.textColor = HomeConstants.HomeColor.colorWhite38
        timeImage.image = HomeConstants.HomeImage.timeImage
        arrowImage.image = HomeConstants.HomeImage.chevronRight
        conteinerView.image = HomeConstants.HomeImage.backgroundActivity
        conteinerView.backgroundColor = HomeConstants.HomeColor.customGrayColor
    }
    func configure(_ model: IncompleteData) {
        if let selector = model.sreateSelector {
            switch selector {
            case "first": // TextToImage
                let descriptionVideo = String(format: "%@: %@",
                                              "Text To Image".localized(LanguageConstant.appLaunguage),
                                              model.descriptions ?? "")
                nameTitle.text = descriptionVideo
            case "second": // VideoToVideo
                let descriptionVideo = String(format: "%@: %@ - %@",
                                              "Video To Video".localized(LanguageConstant.appLaunguage),
                                              "Style".localized(LanguageConstant.appLaunguage),
                                              model.styleMode ?? "")
                nameTitle.text = descriptionVideo
            case "third": // base
                let descriptionVideo = String(format: "%@ %@",
                                              model.pluginMode ?? "",
                                              model.descriptions ?? "")
                nameTitle.text = descriptionVideo
            default:
                break
            }
        }
    }
}
private extension RecentActivityCell {
    func initialization() {
        contentView.addSubview(conteinerView)
        conteinerView.addSubview(timeImage)
        conteinerView.addSubview(nameTitle)
        conteinerView.addSubview(arrowImage)
    }
    func setupeConstraint() {
        conteinerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        timeImage.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
        }
        nameTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().inset(15)
            make.right.equalTo(-50)
            make.left.equalTo(timeImage.snp.right).inset(-10)
        }
        arrowImage.snp.makeConstraints { make in
            make.width.height.equalTo(27)
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        } 
    }
}
