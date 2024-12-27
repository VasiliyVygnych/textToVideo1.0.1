//
//  SettingsButtonBuild.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//
import UIKit
import SnapKit
import StoreKit

final class SettingsButtonBuild: UIView {
    
    var viewModel: SettingsViewModelProtocol?
    var alerts: AlertManagerProtocol?
    weak var delegate: CustomViewDelegate?
    
    
    var buttonStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 3
        view.layer.cornerRadius = 18
        view.axis = .horizontal
        view.backgroundColor = .clear
        return view
    }()
    private var button: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var images: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    private var buttonTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .left
        return view
    }()
    init() {
        super.init(frame: .zero)
        addSubviews()
        setupeConstraints()
        button.addTarget(self,
                         action: #selector (buttonTapped),
                         for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(title: String,
                   index: Int) {
        button.backgroundColor = SettingsConstants.SettingsColor.viewCustomColor
        images.image = SettingsConstants.SettingsImages.chevronRight
        if index == 5 {
            images.image = SettingsConstants.SettingsImages.shareImages
        }
        buttonTitle.text = title
        button.tag = index
    }
    @objc func buttonTapped(_ sender: UIButton) {
        viewModel?.viewAnimate(view: button,
                               duration: 0.2,
                               scale: 0.98)
        switch sender.tag {
        case 0:
            viewModel?.restoreSubscription()
        case 1:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.viewModel?.openWebViewController(title: Constants.TextPaywall.privacyPolicy.localized(LanguageConstant.appLaunguage),
                                                       mode: .privacyPolicy)
            }
        case 2:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.viewModel?.openWebViewController(title: Constants.TextPaywall.termsOfUse.localized(LanguageConstant.appLaunguage),
                                                       mode: .termsOfUse)
            }
        case 3:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                SKStoreReviewController.requestRateApp()
            }
        case 4:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.delegate?.showView()
            }
        case 5:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                let url = URL(string: "https://apps.apple.com/us/app/\(IdApp.appID)")!
                let view = UIActivityViewController(activityItems: [url],
                                                    applicationActivities: nil)
                self?.viewModel?.presentView(view: view)
            }
        default:
            break
        }
    }
    private func addSubviews() {
        addSubview(buttonStack)
        buttonStack.addSubview(button)
        button.addSubview(buttonTitle)
        button.addSubview(images)
    }
    private func setupeConstraints() {
        buttonStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        images.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(23)
            make.height.equalTo(24)
            make.right.equalTo(-20)
        }
        buttonTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.right.equalTo(images.snp.left).inset(-15)
            make.left.equalTo(20)
        }
    }
}
