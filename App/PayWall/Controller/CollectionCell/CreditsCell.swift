//
//  CreditsCell.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 25.12.2024.
//

import UIKit
import SnapKit

class CreditsCell: UICollectionViewCell {

    var viewModel: MainViewModelProtocol?
    weak var delegate: PayWallDelegate?
    private var crediteMode = CreditsMode.none
    var model: CreditsData?
    
    private var totalCount: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 48,
                                weight: .bold)
        view.textAlignment = .left
        return view
    }()
    private var creditsTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .medium)
        view.textAlignment = .left
        return view
    }()
    private var priceTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .medium)
        view.textAlignment = .left
        return view
    }()
    var buyButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.titleLabel?.font = .systemFont(ofSize: 16,
                                            weight: .bold)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 16
        initialization()
        setupeConstraint()
        setupeView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupeView() {
        contentView.backgroundColor = UIColor(named: "subscribeColor")
        totalCount.textColor = .white
        creditsTitle.textColor = UIColor(named: "customGrayC4")
        priceTitle.textColor = .white
        buyButton.backgroundColor = UIColor(named: "customBlueColor")
        buyButton.setTitleColor(.white,
                                for: .normal)
        
        creditsTitle.text = "credits".localized(LanguageConstant.appLaunguage)
        buyButton.setTitle("Buy now".localized(LanguageConstant.appLaunguage),
                           for: .normal)
        buyButton.addTarget(self,
                            action: #selector(buyAnimate),
                            for: .touchUpInside)
    }
    func configure(_ data: CreditsData) {
        totalCount.text = data.totalValue
        priceTitle.text = data.price
        crediteMode = .credits100
    }
    @objc func buyAnimate() {
        viewModel?.viewAnimate(view: buyButton,
                               duration: 0.2,
                               scale: 0.97)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self else { return }
            if let mode = model?.mode {
                delegate?.buyCredit(mode)
            }
        }
    }
}
private extension CreditsCell {
    func initialization() {
        contentView.addSubview(totalCount)
        contentView.addSubview(creditsTitle)
        contentView.addSubview(priceTitle)
        contentView.addSubview(buyButton)
    }
    func setupeConstraint() {
        totalCount.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.top.equalToSuperview().inset(15)
        }
        creditsTitle.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(15)
            make.top.equalTo(totalCount.snp.bottom)
        }
        priceTitle.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(20)
            make.bottom.equalTo(buyButton.snp.top).inset(-15)
        }
        buyButton.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.width.equalToSuperview().inset(15)
            make.height.equalTo(43)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
