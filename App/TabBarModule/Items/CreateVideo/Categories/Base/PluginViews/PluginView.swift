//
//  PluginView.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 17.10.2024.
//

import UIKit
import SnapKit

class PluginView: UIView {
    
    weak var delegate: PluginDelegate?
    
    private var pluginFirstButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.tag = 1
        return view
    }()
    private var pluginFirstTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textColor = .white
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.2
        view.numberOfLines = 2
        return view
    }()
    private var removeFirstButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.tag = 1
        return view
    }()
    
    private var pluginSecondButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.tag = 2
        return view
    }()
    private var pluginSecondTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    private var removeSecondButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.tag = 2
        return view
    }()
    
    private var pluginThirdButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.tag = 3
        return view
    }()
    private var pluginThirdTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    private var removeThirdButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.tag = 3
        return view
    }()
    
    private var pluginFourthButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.tag = 4
        return view
    }()
    private var pluginFourthTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    private var removeFourthButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.tag = 4
        return view
    }()
    init() {
        super.init(frame: .zero)
        addSubview()
        setupeColor()
        setupeText()
        setupeButton()
        setupeData()
        setupeConstraints()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupeColor() {
        pluginFirstTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginSecondTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginThirdTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginFourthTitle.textColor = HomeConstants.HomeColor.colorWhite38
        
        pluginFirstButton.layer.borderColor = HomeConstants.HomeColor.customGrayColor?.cgColor
        pluginSecondButton.layer.borderColor = HomeConstants.HomeColor.customGrayColor?.cgColor
        pluginThirdButton.layer.borderColor = HomeConstants.HomeColor.customGrayColor?.cgColor
        pluginFourthButton.layer.borderColor = HomeConstants.HomeColor.customGrayColor?.cgColor
    }
    private func setupeText() {
        pluginFirstTitle.text = HomeConstants.HomeText.pluginFirstTitle.localized(LanguageConstant.appLaunguage)
        pluginSecondTitle.text = HomeConstants.HomeText.pluginSecondTitle.localized(LanguageConstant.appLaunguage)
        pluginThirdTitle.text = HomeConstants.HomeText.pluginThirdTitle.localized(LanguageConstant.appLaunguage)
        pluginFourthTitle.text = HomeConstants.HomeText.pluginFourthTitle.localized(LanguageConstant.appLaunguage)
    }
    private func setupeData() {
        removeFirstButton.setBackgroundImage(HomeConstants.HomeImage.remove,
                                             for: .normal)
        removeSecondButton.setBackgroundImage(HomeConstants.HomeImage.remove,
                                              for: .normal)
        removeThirdButton.setBackgroundImage(HomeConstants.HomeImage.remove,
                                             for: .normal)
        removeFourthButton.setBackgroundImage(HomeConstants.HomeImage.remove,
                                              for: .normal)
        
    }
    private func addSubview() {
        addSubview(pluginFirstButton)
        pluginFirstButton.addSubview(pluginFirstTitle)
        pluginFirstButton.addSubview(removeFirstButton)
        removeFirstButton.isHidden = true
        
        addSubview(pluginSecondButton)
        pluginSecondButton.addSubview(pluginSecondTitle)
        pluginSecondButton.addSubview(removeSecondButton)
        removeSecondButton.isHidden = true
        
        
        addSubview(pluginThirdButton)
        pluginThirdButton.addSubview(pluginThirdTitle)
        pluginThirdButton.addSubview(removeThirdButton)
        removeThirdButton.isHidden = true
        
        
        addSubview(pluginFourthButton)
        pluginFourthButton.addSubview(pluginFourthTitle)
        pluginFourthButton.addSubview(removeFourthButton)
        removeFourthButton.isHidden = true
    }
    private func setupeButton() {
        pluginFirstButton.addTarget(self,
                                    action: #selector(selectPlugin),
                                    for: .touchUpInside)
        pluginSecondButton.addTarget(self,
                                     action: #selector(selectPlugin),
                                     for: .touchUpInside)
        pluginThirdButton.addTarget(self,
                                    action: #selector(selectPlugin),
                                    for: .touchUpInside)
        pluginFourthButton.addTarget(self,
                                     action: #selector(selectPlugin),
                                     for: .touchUpInside)
        
        removeFirstButton.addTarget(self,
                                    action: #selector(removePlugin),
                                    for: .touchUpInside)
        removeSecondButton.addTarget(self,
                                     action: #selector(removePlugin),
                                     for: .touchUpInside)
        removeThirdButton.addTarget(self,
                                    action: #selector(removePlugin),
                                    for: .touchUpInside)
        removeFourthButton.addTarget(self,
                                     action: #selector(removePlugin),
                                     for: .touchUpInside)
    }
    @objc func selectPlugin(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            selectFirst()
            delegate?.selectPlugin(.basicWorkflows)
        case 2:
            selectSecond()
            delegate?.selectPlugin(.scriptToVideo)
        case 3:
            selectThird()
            delegate?.selectPlugin(.youtubeShorts)
        case 4:
            selectFourth()
            delegate?.selectPlugin(.instagramReels)
        default:
            break
        }
    }
    @objc func removePlugin(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            pluginFirstTitle.textColor = HomeConstants.HomeColor.colorWhite38
            pluginFirstButton.layer.borderWidth = 1
            pluginFirstButton.backgroundColor = .clear
            removeFirstButton.isHidden = true
            delegate?.removePlugin()
        case 2:
            pluginSecondTitle.textColor = HomeConstants.HomeColor.colorWhite38
            pluginSecondButton.layer.borderWidth = 1
            pluginSecondButton.backgroundColor = .clear
            removeSecondButton.isHidden = true
            delegate?.removePlugin()
        case 3:
            pluginThirdTitle.textColor = HomeConstants.HomeColor.colorWhite38
            pluginThirdButton.layer.borderWidth = 1
            pluginThirdButton.backgroundColor = .clear
            removeThirdButton.isHidden = true
            delegate?.removePlugin()
        case 4:
            pluginFourthTitle.textColor = HomeConstants.HomeColor.colorWhite38
            pluginFourthButton.layer.borderWidth = 1
            pluginFourthButton.backgroundColor = .clear
            removeFourthButton.isHidden = true
            delegate?.removePlugin()
        default:
            break
        }
    }
    func deselect() {
        pluginFirstTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginFirstButton.layer.borderWidth = 1
        pluginFirstButton.backgroundColor = .clear
        removeFirstButton.isHidden = true
        
        pluginSecondTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginSecondButton.layer.borderWidth = 1
        pluginSecondButton.backgroundColor = .clear
        removeSecondButton.isHidden = true
        
        pluginThirdTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginThirdButton.layer.borderWidth = 1
        pluginThirdButton.backgroundColor = .clear
        removeThirdButton.isHidden = true
        
        pluginFourthTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginFourthButton.layer.borderWidth = 1
        pluginFourthButton.backgroundColor = .clear
        removeFourthButton.isHidden = true
    }
    func selectFirst() {
        pluginFirstTitle.textColor = .white
        pluginFirstButton.layer.borderWidth = 0
        pluginFirstButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        removeFirstButton.isHidden = false
        
        pluginSecondTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginSecondButton.layer.borderWidth = 1
        pluginSecondButton.backgroundColor = .clear
        removeSecondButton.isHidden = true
        
        pluginThirdTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginThirdButton.layer.borderWidth = 1
        pluginThirdButton.backgroundColor = .clear
        removeThirdButton.isHidden = true
        
        pluginFourthTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginFourthButton.layer.borderWidth = 1
        pluginFourthButton.backgroundColor = .clear
        removeFourthButton.isHidden = true
    }
    func selectSecond() {
        pluginSecondTitle.textColor = .white
        pluginSecondButton.layer.borderWidth = 0
        pluginSecondButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        removeSecondButton.isHidden = false
        
        pluginFirstTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginFirstButton.layer.borderWidth = 1
        pluginFirstButton.backgroundColor = .clear
        removeFirstButton.isHidden = true
        
        pluginThirdTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginThirdButton.layer.borderWidth = 1
        pluginThirdButton.backgroundColor = .clear
        removeThirdButton.isHidden = true
        
        pluginFourthTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginFourthButton.layer.borderWidth = 1
        pluginFourthButton.backgroundColor = .clear
        removeFourthButton.isHidden = true
    }
    func selectThird() {
        pluginThirdTitle.textColor = .white
        pluginThirdButton.layer.borderWidth = 0
        pluginThirdButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        removeThirdButton.isHidden = false
        
        pluginFirstTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginFirstButton.layer.borderWidth = 1
        pluginFirstButton.backgroundColor = .clear
        removeFirstButton.isHidden = true
        
        pluginSecondTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginSecondButton.layer.borderWidth = 1
        pluginSecondButton.backgroundColor = .clear
        removeSecondButton.isHidden = true
        
        pluginFourthTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginFourthButton.layer.borderWidth = 1
        pluginFourthButton.backgroundColor = .clear
        removeFourthButton.isHidden = true
    }
    func selectFourth() {
        pluginFourthTitle.textColor = .white
        pluginFourthButton.layer.borderWidth = 0
        pluginFourthButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        removeFourthButton.isHidden = false
        
        pluginFirstTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginFirstButton.layer.borderWidth = 1
        pluginFirstButton.backgroundColor = .clear
        removeFirstButton.isHidden = true
        
        pluginSecondTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginSecondButton.layer.borderWidth = 1
        pluginSecondButton.backgroundColor = .clear
        removeSecondButton.isHidden = true
        
        pluginThirdTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginThirdButton.layer.borderWidth = 1
        pluginThirdButton.backgroundColor = .clear
        removeThirdButton.isHidden = true
    }
    
    private func setupeConstraints() {
        pluginFirstButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(41)
            make.right.equalTo(self.snp.centerX).offset(-10)
        }
        pluginFirstTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-25)
            make.height.equalTo(25)
        }
        removeFirstButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
            make.right.equalTo(-5)
        }
        
        pluginSecondButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.right.equalTo(-20)
            make.height.equalTo(41)
            make.left.equalTo(self.snp.centerX).offset(10)
        }
        pluginSecondTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(200)
        }
        removeSecondButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
            make.right.equalTo(-5)
        }
        
        pluginThirdButton.snp.makeConstraints { make in
            make.top.equalTo(pluginFirstButton.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.height.equalTo(41)
            make.right.equalTo(self.snp.centerX).offset(-10)
        }
        pluginThirdTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(200)
        }
        removeThirdButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
            make.right.equalTo(-5)
        }
        
        pluginFourthButton.snp.makeConstraints { make in
            make.top.equalTo(pluginSecondButton.snp.bottom).offset(15)
            make.right.equalTo(-20)
            make.height.equalTo(41)
            make.left.equalTo(self.snp.centerX).offset(10)
        }
        pluginFourthTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(200)
        }
        removeFourthButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
            make.right.equalTo(-5)
        }
    }
}
