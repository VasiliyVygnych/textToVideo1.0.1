//
//  RateView.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 09.11.2024.
//

import UIKit
import SnapKit
import StoreKit

class RateView: UIView {
    
    weak var delegate: CustomViewDelegate?
    var view = UIViewController()
    
    private var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.7
        return view
    }()
    private let imageLogo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
    }()
    private var textLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.font = .systemFont(ofSize: 19,
                                weight: .bold)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    private let imageStars: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    private var firstButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white,
                           for: .normal)
        view.layer.cornerRadius = 8
        view.titleLabel?.font = .systemFont(ofSize: 19,
                                            weight: .bold)
        view.tag = 1
        return view
    }()
    private var secondButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.titleLabel?.font = .systemFont(ofSize: 19,
                                            weight: .bold)
        view.tag = 2
        return view
    }()
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        addSubview()
        setupeColorAndImage()
        setupeText()
        setupeConstraints()
        setupeButton()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupeColorAndImage() {
        imageLogo.image = HomeConstants.HomeImage.customLogo
        imageStars.image = HomeConstants.HomeImage.starsImage
        
        contentView.backgroundColor = HomeConstants.HomeColor.customDarkColor
        firstButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        secondButton.backgroundColor = HomeConstants.HomeColor.viewCustomColor
    }
    func setupeText() {
        textLabel.text = HomeConstants.HomeText.rateViewTitle.localized(LanguageConstant.appLaunguage)
        firstButton.setTitle(HomeConstants.HomeText.rateTitleYes.localized(LanguageConstant.appLaunguage),
                             for: .normal)
        secondButton.setTitle(HomeConstants.HomeText.rateTitleNo.localized(LanguageConstant.appLaunguage),
                              for: .normal)
        secondButton.setTitleColor(HomeConstants.HomeColor.customGrayC4,
                                   for: .normal)
    }
    private func addSubview() {
        addSubview(blurView)
        addSubview(contentView)
        contentView.addSubview(imageLogo)
        contentView.addSubview(textLabel)
        contentView.addSubview(imageStars)
        contentView.addSubview(firstButton)
        contentView.addSubview(secondButton)
    }
    func showMy() {
        delegate?.showView()
    }
    private func setupeButton() {
        firstButton.addTarget(self,
                              action: #selector(buttonTapped),
                              for: .touchUpInside)
        secondButton.addTarget(self,
                               action: #selector(buttonTapped),
                               for: .touchUpInside)
    }
    @objc func buttonTapped(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.isHidden = true
            self?.delegate?.isHideTabBar(false)
        }
        switch sender.tag {
        case 1:
            viewAnimate(view: firstButton,
                        duration: 0.2,
                        scale: 0.97)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.openAppStore()
            }
        case 2:
            viewAnimate(view: secondButton, // no
                        duration: 0.2,
                        scale: 0.97)
        default:
            break
        }
    }
    func openAppStore() {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        let parameters = [SKStoreProductParameterITunesItemIdentifier: IdApp.appID]
        
        storeViewController.loadProduct(withParameters: parameters) { (result, error) in
            if error == nil {
                self.view.present(storeViewController,
                                  animated: true)
            } else {
                print("Error loading product: \(String(describing: error))")
            }
        }
    }
    func viewAnimate(view: UIView,
                     duration: Double,
                     scale: Double) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            view.transform = CGAffineTransform(scaleX: scale,
                                               y: scale)
        }, completion: { finished in
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                view.transform = CGAffineTransform(scaleX: 1,
                                                   y: 1)
            })
        })
    }
    private func setupeConstraints() {
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(305)
            make.height.greaterThanOrEqualTo(190)
        }
        imageLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(contentView.snp.top)
            make.width.height.equalTo(80)
        }
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(imageLogo.snp.bottom).offset(10)
            make.left.equalTo(15)
            make.width.equalToSuperview().inset(15)
            make.height.greaterThanOrEqualTo(20)
        }
        imageStars.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(27)
            make.bottom.equalTo(firstButton.snp.top).inset(-15)
        }
        
        firstButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(contentView.snp.centerX).offset(-10)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().inset(20)
        }
        secondButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.left.equalTo(contentView.snp.centerX).offset(10)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().inset(20)
        }
        
    }
}
extension RateView: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true,
                               completion: nil)
    }
}
