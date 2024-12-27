//
//  SelectSubscribeBuild.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 23.12.2024.
//

import UIKit
import SnapKit

class SelectSubscribeBuild: UIView {
    
    var viewModel: MainViewModelProtocol?
    weak var delegate: PayWallDelegate?
    private var stackHeight = 0
    private var duration = SubscriptionDuration.yearly
    private var modelType = PayWallType.free
    
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
     }()
    private var nameTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 25,
                                weight: .bold)
        view.textAlignment = .left
        view.numberOfLines = 0
         return view
    }()
    private var discountPriceTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textAlignment = .right
         return view
    }()
    private var priceTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .semibold)
        view.textAlignment = .right
         return view
    }()
    private var descriptionTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textAlignment = .left
        view.numberOfLines = 0
//        view.adjustsFontSizeToFitWidth = true
//        view.minimumScaleFactor = 0.2
         return view
    }()
   private var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var stackView: UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    var subscribeButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 28
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        return view
    }()
    init() {
        super.init(frame: .zero)
        addSubview()
        setupeText()
        setupeColor()
        setupeButton()
        setupeConstraints()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupeText() {
        subscribeButton.setTitle("Upgrade".localized(LanguageConstant.appLaunguage),
                                 for: .normal)
    }
    private func setupeColor() {
        self.backgroundColor = UIColor(named: "backgroundCustom")
        contentView.backgroundColor = UIColor(named: "subscribeColor")
        separatorView.backgroundColor = UIColor(named: "colorWhite16")
        nameTitle.textColor = .white
        
        discountPriceTitle.textColor = UIColor(named: "colorWhite41")
        
        priceTitle.textColor = .white
        descriptionTitle.textColor = UIColor(named: "colorWhite60")
    }
    func configure(data: PayWallData,
                   model: [PayWallDescription],
                   index: Int,
                   appData: AppData?) {
        nameTitle.text = data.name
        descriptionTitle.text = data.description
        duration = data.duration
        priceTitle.text = data.price
        let alpha = data.duration == .yearly ? 1.0 : 0.0
        if data.duration == .yearly {
            discountPriceTitle.alpha = alpha
            if let discount = data.discount {
                let discountTitle = NSAttributedString(string: discount,
                                                       attributes: [
                   .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ])
                discountPriceTitle.attributedText = discountTitle
            }
        } else {
            discountPriceTitle.alpha = alpha
        }
        if data.type == .free {
            discountPriceTitle.alpha = 0
        }
        modelType = data.type
        stackHeight = model.count * 50
        stackView.snp.updateConstraints { make in
            make.height.equalTo(stackHeight)
        }
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        model.forEach { data in
            let view = BuildSubscribe()
            view.configure(data: data)
            stackView.addArrangedSubview(view)
        }
        if data.type == .free {
            subscribeButton.isHidden = true
            subscribeButton.snp.updateConstraints { make in
                make.top.equalTo(stackView.snp.bottom).offset(0)
                make.height.equalTo(0)
            }
            layoutSubviews()
        }
        checkSubscriptionActive(data: appData)
    }
    func checkSubscriptionActive(data: AppData?) {
        switch modelType {
        case .free:
            if data?.freeIsActive == true {
                contentView.layer.borderWidth = 1
                contentView.layer.borderColor = UIColor(named: "customBlueColor")?.cgColor
            } else {
                contentView.layer.borderWidth = 0
            }
        case .plus:
            switch duration {
            case .monthly:
                if data?.plusMounthlyActive == true {
                    isSelectSubscribe(true)
                } else {
                    isSelectSubscribe(false)
                }
            case .yearly:
                if data?.plusYearlyActive == true {
                    isSelectSubscribe(true)
                } else {
                    isSelectSubscribe(false)
                }
            }
        case .ultra:
            switch duration {
            case .monthly:
                if data?.ultraMounthlyActive == true {
                    isSelectSubscribe(true)
                } else {
                    isSelectSubscribe(false)
                }
            case .yearly:
                if data?.ultraYearlyActive == true {
                    isSelectSubscribe(true)
                } else {
                    isSelectSubscribe(false)
                }
            }
        }
    }
    func isSelectSubscribe(_ bool: Bool) {
        if bool {
            subscribeButton.isEnabled = false
            subscribeButton.backgroundColor = UIColor(named: "infoViewColor")
            subscribeButton.setTitleColor(UIColor(named: "grayColorText"),
                                          for: .normal)
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor(named: "customBlueColor")?.cgColor
        } else {
            subscribeButton.backgroundColor = Constants.ColorPaywall.customBlueColor
            subscribeButton.isEnabled = true
            subscribeButton.setTitleColor(.white,
                                          for: .normal)
        }
        subscribeButton.updateConfiguration()
    }
    private func addSubview() {
        addSubview(contentView)
        contentView.addSubview(nameTitle)
        contentView.addSubview(priceTitle)
        contentView.addSubview(discountPriceTitle)
        contentView.addSubview(descriptionTitle)
        
        contentView.addSubview(separatorView)
        
        contentView.addSubview(stackView)
        contentView.addSubview(subscribeButton)
    }
    private func setupeButton() {
        subscribeButton.addTarget(self,
                                  action: #selector(subscribe),
                                  for: .touchUpInside)
    }
    @objc func subscribe(_ sender: UIButton) {
        viewModel?.viewAnimate(view: subscribeButton,
                               duration: 0.2,
                               scale: 0.95)
        switch modelType {
        case .free:
            delegate?.didCompletePayment(.free)
        case .plus:
            switch duration {
            case .monthly:
                delegate?.didCompletePayment(.monthlyPlus)
            case .yearly:
                delegate?.didCompletePayment(.yearlyPlus)
            }
        case .ultra:
            switch duration {
            case .monthly:
                delegate?.didCompletePayment(.monthlyUltra)
            case .yearly:
                delegate?.didCompletePayment(.yearlyUltra)
            }
        }
    }
    private func setupeConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.bottom.equalToSuperview().inset(10)
        }
        nameTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        discountPriceTitle.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.right.equalTo(priceTitle.snp.left).inset(-10)
            make.width.greaterThanOrEqualTo(20)
            make.bottom.equalTo(priceTitle.snp.bottom)
        }
        priceTitle.snp.makeConstraints { make in
            make.top.equalTo(nameTitle.snp.top).offset(5)
            make.right.equalTo(-20)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(20)
        }
        descriptionTitle.snp.makeConstraints { make in
            make.top.equalTo(nameTitle.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
        }
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitle.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(stackHeight)
        }
        subscribeButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
