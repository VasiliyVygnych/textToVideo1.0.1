//
//  SettingsController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 14.10.2024.
//

import UIKit
import SnapKit

class SettingsController: UIViewController {
    
    var viewModel: SettingsViewModelProtocol?
    var alerts: AlertManagerProtocol?
    private var rateView = RateView()
    private var titleModel = ["Restore membership".localized(LanguageConstant.appLaunguage),
                              Constants.TextPaywall.privacyPolicy.localized(LanguageConstant.appLaunguage),
                              Constants.TextPaywall.termsOfUse.localized(LanguageConstant.appLaunguage),
                              SettingsConstants.SettingsText.rateApp.localized(LanguageConstant.appLaunguage),
                              SettingsConstants.SettingsText.giveUsFeedback.localized(LanguageConstant.appLaunguage),
                              SettingsConstants.SettingsText.shareApp.localized(LanguageConstant.appLaunguage)]
    private var buttonStackHeight = 0
    private var subscripeViewHeight = 220 // 100
    
    private var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var infoButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var addCreditsButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var subscripeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var titleSpecialSection: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
        return view
    }()
    private var totalCredits: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 60,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
        return view
    }()
    private var titleCredits: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .semibold)
        view.textAlignment = .left
       
        return view
    }()
    private var titlePlanSubscripe: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .semibold)
        view.textAlignment = .right
        return view
    }()
    private var upgradePlanButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        return view
    }()
    
    private var subscripeButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.titleLabel?.font = .systemFont(ofSize: 18,
                                            weight: .bold)
        view.titleLabel?.textAlignment = .left
        view.titleLabel?.textColor = .white
        return view
    }()
    
    private var arrowImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    private var titleGeneralSection: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
        return view
    }()
    private var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.spacing = 9
        view.distribution = .fillEqually
        view.axis = .vertical
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = SettingsConstants.SettingsColor.backgroundColor
        buttonStackHeight = titleModel.count * 60
        rateView.delegate = self
        addSubview()
        setupeText()
        setupeColor()
        setupeData()
        setupeConstraints()
        setupeButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupeAppData()
    }
    private func setupeAppData() {
        let data = viewModel?.getAppData()?.last
        let countCredits = Int(data?.creditsCount ?? 0)
        totalCredits.text = String(countCredits)
        let plan = "plan".localized(LanguageConstant.appLaunguage)
        titlePlanSubscripe.text = "(\(data?.subscripeType?.localized(LanguageConstant.appLaunguage) ?? "") \(plan))"
    }
    private func addSubview() {
        view.addSubview(backButton)
        view.addSubview(subscripeView)
        
        subscripeView.addSubview(titleSpecialSection)
        subscripeView.addSubview(infoButton)
        subscripeView.addSubview(totalCredits)
        subscripeView.addSubview(titlePlanSubscripe)
        subscripeView.addSubview(titleCredits)
        subscripeView.addSubview(upgradePlanButton)
        subscripeView.addSubview(addCreditsButton)
        
        subscripeView.addSubview(subscripeButton)
        subscripeButton.addSubview(arrowImage)
        subscripeButton.isHidden = true

        view.addSubview(titleGeneralSection)
        view.addSubview(buttonStackView)
        
        view.addSubview(rateView)
        rateView.view = self
        rateView.isHidden = true
    }
    private func hidesubscripeButton() {
        subscripeView.isHidden = true
        titleSpecialSection.isHidden = true
        
        
        subscripeButton.isHidden = true
        upgradePlanButton.isHidden = true
    }
    private func setupeText() {
        titleCredits.text = "credits reamaining".localized(LanguageConstant.appLaunguage)
        upgradePlanButton.setTitle("Upgrade plan".localized(LanguageConstant.appLaunguage),
                                   for: .normal)
        subscripeButton.setTitle(SettingsConstants.SettingsText.titleSubscripeButton.localized(LanguageConstant.appLaunguage),
                                 for: .normal)
        titleSpecialSection.text = SettingsConstants.SettingsText.titleSpecialSection.localized(LanguageConstant.appLaunguage)
        titleGeneralSection.text = SettingsConstants.SettingsText.titleGeneralSection.localized(LanguageConstant.appLaunguage)
    }
    private func setupeColor() {
        upgradePlanButton.setTitleColor(.white,
                                        for: .application)
        titlePlanSubscripe.textColor = UIColor(named: "colorWhite41")
        titleCredits.textColor = UIColor(named: "colorWhite41")
        upgradePlanButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        subscripeButton.backgroundColor = SettingsConstants.SettingsColor.viewCustomColor
    }
    private func setupeData() {
        addCreditsButton.setBackgroundImage(UIImage(named: "addCreditsImage"),
                                            for: .normal)
        backButton.setBackgroundImage(HomeConstants.HomeImage.arrowLeft,
                                      for: .normal)
        arrowImage.image = SettingsConstants.SettingsImages.chevronRight
        infoButton.setBackgroundImage(UIImage(named: "infoButtonImage"),
                                      for: .normal)
        titleModel.enumerated().forEach { index, title in
            let view = SettingsButtonBuild()
            view.delegate = self
            view.viewModel = viewModel
            view.alerts = alerts
            view.configure(title: title,
                           index: index)
            buttonStackView.addArrangedSubview(view)
        }
    }
    private func setupeButton() {
        subscripeButton.addTarget(self,
                                  action: #selector(opePayWall),
                                  for: .touchUpInside)
        backButton.addTarget(self,
                             action: #selector(popToView),
                             for: .touchUpInside)
        upgradePlanButton.addTarget(self,
                                    action: #selector(opePayWall),
                                    for: .touchUpInside)
        infoButton.addTarget(self,
                             action: #selector(showInfo),
                             for: .touchUpInside)
        addCreditsButton.addTarget(self,
                                   action: #selector(opeBuyCredits),
                                   for: .touchUpInside)
    }
    @objc func opeBuyCredits() {
        viewModel?.viewAnimate(view: addCreditsButton,
                               duration: 0.2,
                               scale: 0.97)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.viewModel?.openPaywallController(isAdd: true)
        }
    }
    @objc func showInfo() {
        viewModel?.showInfoCreditsView()
    }
    @objc func popToView() {
        navigationController?.popViewController(animated: true)
    }
    @objc func opePayWall() {
        viewModel?.viewAnimate(view: upgradePlanButton,
                               duration: 0.2,
                               scale: 0.97)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.viewModel?.openPaywallController(isAdd: false)
        }
    }
    private func setupeConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(65)
            make.left.equalTo(20)
            make.width.height.equalTo(36)
        }
        subscripeView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(15)
            make.width.equalToSuperview()
            make.height.equalTo(subscripeViewHeight)
        }
        titleSpecialSection.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.height.equalTo(20)
            make.width.equalToSuperview()
            make.top.equalTo(subscripeView.snp.top).offset(15)
        }
        infoButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalTo(titleSpecialSection.snp.centerY)
            make.width.height.equalTo(25)
        }
        totalCredits.snp.makeConstraints { make in
            make.top.equalTo(titleSpecialSection.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.height.lessThanOrEqualTo(65)
            make.width.greaterThanOrEqualTo(20)
        }
        addCreditsButton.snp.makeConstraints { make in
            make.left.equalTo(totalCredits.snp.right)
            make.width.height.equalTo(60)
            make.centerY.equalTo(totalCredits.snp.centerY)
        }
        titlePlanSubscripe.snp.makeConstraints { make in
            make.top.equalTo(totalCredits.snp.top).offset(15)
            make.right.equalTo(-20)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(60)
        }
        titleCredits.snp.makeConstraints { make in
            make.top.equalTo(totalCredits.snp.bottom)
            make.left.equalTo(20)
            make.height.equalTo(15)
            make.width.greaterThanOrEqualTo(60)
        }
        upgradePlanButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(53)
            make.bottom.equalToSuperview()
        }
        subscripeButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        subscripeButton.titleLabel?.snp.makeConstraints { make in
            make.left.equalTo(20)
        }
        arrowImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
            make.width.equalTo(23)
            make.height.equalTo(24)
        }
        titleGeneralSection.snp.makeConstraints { make in
            make.top.equalTo(subscripeView.snp.bottom).offset(30)
            make.width.equalToSuperview()
            make.left.equalTo(20)
            make.height.equalTo(20)
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(titleGeneralSection.snp.bottom).offset(20)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(buttonStackHeight)
        }
        rateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension SettingsController: CustomViewDelegate {
    func isHideTabBar(_ bool: Bool) {
        tabBarController?.tabBar.isHidden = bool
    }
    func showView() {
        rateView.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
}
