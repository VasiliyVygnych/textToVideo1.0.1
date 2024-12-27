//
//  CreateVideoController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 17.10.2024.
//

import UIKit
import SnapKit

import AVFoundation

class CreateBaseVideoController: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    var alerts: AlertManagerProtocol?
    private var pluginView = PluginView()
    private var loaderView = LoaderView()
    private var gesture = UITapGestureRecognizer()
    weak var delegate: TabBarDelegate?
    private var isEnaibleGenerate = true
    private var duration: Double?
    private var contentSize: CGSize {
        CGSize(width: view.frame.width,
               height: view.frame.height)
    }
    var model: BaseData?
    var recentActivity: IncompleteData?
    var firstOpenPlugin = true
    var generationStarted = false
    
    private var headerTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    private var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var deleteButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.backgroundColor = .clear
        view.contentSize = contentSize
        return view
    }()
   
    private var describeView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var pluginSelectTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textAlignment = .left
        return view
    }()
    private lazy var describeTextView: UITextView = {
        let view = UITextView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.isScrollEnabled = false
        view.scrollsToTop = false
        view.backgroundColor = .clear
        return view
    }()
    private var describePlaceholder: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textAlignment = .left
        return view
    }()
    private var countTextViewText: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 13,
                                weight: .light)
        view.textAlignment = .right
        return view
    }()
    private var generateButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        view.setTitleColor(.white,
                           for: .normal)
        return view
    }()
    
    private var pluginTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .regular)
        view.textColor = .white
        view.textAlignment = .left
        return view
    }()
    
    private var upgradeButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var upgradeTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    
    private var infoView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var infoTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .medium)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    private var infoImage: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = HomeConstants.HomeColor.backgroundColor
        viewModel?.pluginDelegate = self
        viewModel?.requestDelegate = self
        setupeSubview()
        setupeText()
        setupeColor()
        setupeData()
        addConstraints()
        setupeButton()
        checkSubscriptionRequirements()
        if let data = model {
            dataForVideoGeneration(data: data)
        }
        if recentActivity == nil {
            deleteButton.isHidden = true
        } else {
            deleteButton.isHidden = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    private func setupeSubview() {
        view.addSubview(headerTitle)
        view.addSubview(backButton)
        view.addSubview(deleteButton)
        deleteButton.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(describeView)
        describeView.addSubview(pluginSelectTitle)
        describeView.addSubview(describeTextView)
        describeTextView.delegate = self
        describeView.addSubview(describePlaceholder)
        describeView.addSubview(countTextViewText)
        
        scrollView.addSubview(generateButton)
        scrollView.addSubview(pluginTitle)
        scrollView.addSubview(pluginView)
        pluginView.delegate = self
        
        view.addSubview(upgradeButton)
        upgradeButton.addSubview(upgradeTitle)
        
        scrollView.addSubview(infoView)
        infoView.addSubview(infoTitle)
        infoView.addSubview(infoImage)
        
        view.addSubview(loaderView)
        loaderView.viewModel = viewModel
        loaderView.isHidden = true
        isEnaibleGenerateButton(false)
    }
    private func isEnaibleGenerateButton(_ bool: Bool) {
        if bool {
            generateButton.isEnabled = true
            generateButton.alpha = 1
        } else {
            generateButton.isEnabled = false
            generateButton.alpha = 0.3
        }
    }
    private func setupeText() {
        deleteButton.setTitle("delete".localized(LanguageConstant.appLaunguage),
                              for: .normal)
        headerTitle.text = "Advanced video".localized(LanguageConstant.appLaunguage)
        describePlaceholder.text = HomeConstants.HomeText.describePlaceholder.localized(LanguageConstant.appLaunguage)
        countTextViewText.text = "0\(HomeConstants.HomeText.countDescription)"
        generateButton.setTitle("Generate".localized(LanguageConstant.appLaunguage),
                                for: .normal)
        pluginTitle.text = HomeConstants.HomeText.pluginTitle.localized(LanguageConstant.appLaunguage)
        upgradeTitle.text = HomeConstants.HomeText.upgradeTitle.localized(LanguageConstant.appLaunguage)
        
    }
    private func setupeColor() {
        headerTitle.textColor = .white
        describeView.backgroundColor = HomeConstants.HomeColor.customGray15
        describePlaceholder.textColor = HomeConstants.HomeColor.colorWhite46
        countTextViewText.textColor = HomeConstants.HomeColor.colorWhite65
        generateButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        pluginTitle.textColor = HomeConstants.HomeColor.specialGrayColor
        infoView.backgroundColor = HomeConstants.HomeColor.viewCustomColor
        infoTitle.textColor = HomeConstants.HomeColor.colorWhite38
        pluginSelectTitle.textColor = HomeConstants.HomeColor.customBlueColor
        infoTitleDefaults()
        deleteButton.setTitleColor(HomeConstants.HomeColor.customBlueColor,
                                   for: .normal)
    }
    private func infoTitleDefaults() {
        let text = HomeConstants.HomeText.infoTitle.localized(LanguageConstant.appLaunguage)
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: HomeConstants.HomeText.infoTitleWhite.localized(LanguageConstant.appLaunguage))
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.white,
                                      range: range)
        infoTitle.attributedText = attributedString
    }
    private func setupeData() {
        backButton.setBackgroundImage(HomeConstants.HomeImage.arrowLeft,
                                      for: .normal)
        upgradeButton.setBackgroundImage(HomeConstants.HomeImage.upgradeButton,
                                         for: .normal)
        infoImage.image = HomeConstants.HomeImage.infoImage

        let data = viewModel?.getSavedVideos(true)
        if data?.count ?? 0 > 0  {
            infoView.isHidden = true
            infoTitle.isHidden = true
        }
    }
    private func setupeButton() {
        backButton.addTarget(self,
                             action: #selector(popToView),
                             for: .touchUpInside)
        generateButton.addTarget(self,
                                 action: #selector(generateVideo),
                                 for: .touchUpInside)
        upgradeButton.addTarget(self,
                                action: #selector(upgradeButtonTapped),
                                for: .touchUpInside)
        deleteButton.addTarget(self,
                               action: #selector(deleteIncomplete),
                               for: .touchUpInside)
        scrollView.addGestureRecognizer(gesture)
        gesture.addTarget(self,
                          action: #selector(tapScrollView))
    }
    @objc func deleteIncomplete() {
        if let data = recentActivity {
            viewModel?.removeIncompleteData(id: Int(data.id))
        }
        navigationController?.popViewController(animated: true)
    }
    @objc func tapScrollView() {
        scrollView.endEditing(true)
    }
    @objc func popToView() {
        navigationController?.popViewController(animated: true)
    }
    @objc func generateVideo() {
        viewModel?.viewAnimate(view: generateButton,
                               duration: 0.2,
                               scale: 0.96)
        scrollView.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            guard let self else { return }
            if let data = recentActivity {
                viewModel?.removeIncompleteData(id: Int(data.id))
            }
            
            if model == nil {
                let data = BaseData(id: nil,
                                     mode: .scriptToVideo,
                                     duration: nil,
                                     ratio: nil,
                                     description: describeTextView.text,
                                     descriptionAI: nil,
                                     music: nil)
                model = data
            }
            if let textForGenerate = describeTextView.text {
                isLoader(true)
                if let mode = model?.mode {
                    viewModel?.postRequest(text: textForGenerate,
                                           type: setupeType(mode))
                }
            }
        }
    }
    func setupeType(_ mode: PluginMode) -> GenerationType {
        switch mode {
        case .basicWorkflows:
            return .any
        case .instagramReels:
                return .instagram
        case .scriptToVideo:
            return .any
        case .youtubeShorts:
            return .youtube
        case .none:
            return .any
        }
    }
    private func removeRecent() {
        if let id = viewModel?.getIncompleteData(true)?.last?.id {
            if id == Int16(model?.id ?? 0) {
                viewModel?.removeIncompleteData(id: Int(id))
            }
        }
    }
    func checkTime(value: String) {
        let duration = viewModel?.contains(in: value)
        self.duration = duration
        generationStarted = true
        checkSubscriptionRequirements()
    }
    func isLoader(_ bool: Bool) {
        if bool == true {
            loaderView.loading = true
            loaderView.selector = .base
            loaderView.isHidden = false
            loaderView.model = model
            loaderView.startAnimating()
            tabBarController?.tabBar.isHidden = true
        } else {
            loaderView.loading = false
            loaderView.isHidden = true
            loaderView.model = nil
            loaderView.stopAnimating()
            tabBarController?.tabBar.isHidden = false
        }
    }
    @objc func upgradeButtonTapped() {
        viewModel?.viewAnimate(view: upgradeButton,
                               duration: 0.2,
                               scale: 0.98)
        viewModel?.openPaywallController()
    }
    private func addConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.centerY.equalTo( backButton.snp.centerY)
            make.height.equalTo(20)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.left.equalTo(20)
            make.width.height.equalTo(36)
        }
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalTo(backButton.snp.centerY)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(100)
        }
       
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
        describeView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalTo(headerTitle.snp.right)
            make.left.equalTo(15)
            make.height.greaterThanOrEqualTo(150)
        }
        pluginSelectTitle.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(15)
        }
        describeTextView.snp.makeConstraints { make in
            make.top.equalTo(9)
            make.left.equalTo(18)
            make.width.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
        describePlaceholder.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        countTextViewText.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.width.lessThanOrEqualTo(100)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(10)
        }
        generateButton.snp.makeConstraints { make in
            make.top.equalTo(describeView.snp.bottom).offset(20)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
        }
        
        pluginTitle.snp.makeConstraints { make in
            make.top.equalTo(generateButton.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        pluginView.snp.makeConstraints { make in
            make.top.equalTo(pluginTitle.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(150)
        }
        
        upgradeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pluginView.snp.bottom).offset(30)
            make.width.greaterThanOrEqualTo(50)
            make.height.equalTo(35)
        }
        upgradeTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.left.equalTo(40)
        }
        infoView.snp.makeConstraints { make in
            make.top.equalTo(upgradeButton.snp.bottom).offset(50)
            make.height.equalTo(95)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(15)
        }
        infoTitle.snp.makeConstraints { make in
            make.edges.equalTo(infoView).inset(15)
        }
        infoImage.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.right.equalTo(-5)
            make.width.height.equalTo(20)
        }
        
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension CreateBaseVideoController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        describeTextView.text = textView.text
        if textView.text.isEmpty {
            describePlaceholder.isHidden = false
            isEnaibleGenerateButton(false)
        } else {
            describePlaceholder.isHidden = true
            checkTime(value: textView.text)
            isEnaibleGenerateButton(true)
        }
        if isEnaibleGenerate == false {
            isEnaibleGenerateButton(false)
        }
    }
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let newText = (describeTextView.text as NSString).replacingCharacters(in: range,
                                                                              with: text)
        countTextViewText.text = "\(newText.count)\(HomeConstants.HomeText.countDescription)"
        let numberOfChars = newText.count
        return numberOfChars < HomeConstants.HomeIntegerValue.maxTextCount
    }
}
extension CreateBaseVideoController: PluginDelegate {
    func selectPlugin(_ mode: PluginMode) {
        if firstOpenPlugin == true {
            model = nil
            isEnaibleGenerateButton(false)
        }
        switch mode {
        case .none:
            break
        case .basicWorkflows:
            firstOpenPlugin = false
            viewModel?.presentBasicWorkflowsPlugin(pluginMode: .basicWorkflows,
                                                   model: model)
        case .scriptToVideo:
            firstOpenPlugin = false
            viewModel?.presentScriptToVideoPlugin(model: model)
        case .youtubeShorts:
            firstOpenPlugin = false
            viewModel?.presentBasicWorkflowsPlugin(pluginMode: .youtubeShorts,
                                                   model: model)
        case .instagramReels:
            firstOpenPlugin = false
            viewModel?.presentBasicWorkflowsPlugin(pluginMode: .instagramReels,
                                                   model: model)
        }
    }
    func removePlugin() {
        infoTitleDefaults()
        firstOpenPlugin = true
        countTextViewText.text = "0\(HomeConstants.HomeText.countDescription)"
        describePlaceholder.isHidden = false
        pluginSelectTitle.text = nil
        describeTextView.text = nil
        describeTextView.snp.updateConstraints { make in
            make.top.equalTo(10)
        }
        model = nil
        isEnaibleGenerateButton(false)
    }
    func dataForVideoGeneration(data: BaseData) {
        if data.description == "" {
            pluginView.deselect()
        } else {
            model = data
            switch data.mode {
            case .none:
                pluginSelectTitle.text = nil
                
            case .basicWorkflows:
                pluginSelectTitle.text = HomeConstants.HomeText.selectFirstPlugin.localized(LanguageConstant.appLaunguage)
                pluginView.selectFirst()
            case .scriptToVideo:
                pluginSelectTitle.text = HomeConstants.HomeText.selectSecondPlugin.localized(LanguageConstant.appLaunguage)
                pluginView.selectSecond()
            case .youtubeShorts:
                pluginSelectTitle.text = HomeConstants.HomeText.selectThirgPlugin.localized(LanguageConstant.appLaunguage)
                pluginView.selectThird()
            case .instagramReels:
                pluginSelectTitle.text = HomeConstants.HomeText.selectFourthPlugin.localized(LanguageConstant.appLaunguage)
                pluginView.selectFourth()
            }
            describeTextView.snp.updateConstraints { make in
                make.top.equalTo(20)
            }
            isEnaibleGenerateButton(true)
            describePlaceholder.isHidden = true
            if data.duration == nil || data.ratio == nil || data.music == nil {
                describeTextView.text = data.description
            } else {
//                let descriptionVideo = String(format: "%@ %@, %@, %@ %@, %@ %@",
//                                              HomeConstants.HomeText.patternDuration.localized(LanguageConstant.appLaunguage),
//                                              data.duration ?? "",
//                                              data.description ?? "",
//                                              HomeConstants.HomeText.patternRatio.localized(LanguageConstant.appLaunguage),
//                                              data.ratio ?? "",
//                                              data.music ?? "",
//                                              HomeConstants.HomeText.patternMusic.localized(LanguageConstant.appLaunguage))
                let descriptionVideo = String(format: "%@, %@ %@",
                                              data.description ?? "",
                                              HomeConstants.HomeText.patternRatio.localized(LanguageConstant.appLaunguage),
                                              data.ratio ?? "")
                describeTextView.text = descriptionVideo
                checkTime(value: descriptionVideo)
            }
            let countText = describeTextView.text.count
            countTextViewText.text = "\(countText)\(HomeConstants.HomeText.countDescription.localized(LanguageConstant.appLaunguage))"
        }
    }
}
extension CreateBaseVideoController: RequestDelegate {
    func getResultTextToVideo(_ data: TextToImageResponse?) {}
    func getResultVideoToVideo() {}
    func getResult(data: ResponseData?) {
        isLoader(false)
        if data == nil {
            errorGenefation()
        } else {
            if let strUrl = data?.assets.urls.first,
               let url = URL(string: strUrl) {
                viewModel?.downloadVideo(url,
                                         completion: { docUrl in
                    DispatchQueue.main.async { [weak self] in
                        self?.viewModel?.openResultViewController(baseModel: self?.model,
                                                                  tToVModel: nil,
                                                                  vToVmodel: nil,
                                                                  data: data,
                                                                  fileURL: docUrl,
                                                                  selector: .base)
                    }
                })
            }
        }
    }
    func getAIText(data: ScriptData?) {}
    func error() {
        errorGenefation()
    }
    func errorGenefation() {
        let action = UIAlertAction(title: "Ok",
                                   style: .cancel) { _ in
            self.isLoader(false)
        }
        if let errorAlert = alerts?.requestError(title: HomeConstants.HomeText.errorTitle.localized(LanguageConstant.appLaunguage),
                                                 message: HomeConstants.HomeText.errorMessage.localized(LanguageConstant.appLaunguage),
                                                 action: action) {
            present(errorAlert,
                    animated: true)
        }
    }
}
extension CreateBaseVideoController {
    func checkSubscriptionRequirements() {
        let data = viewModel?.getAppData()
        data?.forEach({ model in
            if model.freeIsActive == true {
                print("free in create video")
                if viewModel?.getSavedVideos(true)?.count ?? 0 >= 3 {
                    viewModel?.cancellationFreeSubscription()
                    isEnaibleGenerateButton(false)
                    infoView.isHidden = false
                    infoTitle.isHidden = false
                    infoTitle.text = HomeConstants.HomeText.limitGenerationThree.localized(LanguageConstant.appLaunguage)
                }
                if model.freeGenerationTime < duration ?? 0 {
                    isEnaibleGenerateButton(false)
                    infoView.isHidden = false
                    infoTitle.isHidden = false
                    infoTitle.text = HomeConstants.HomeText.limitGenerationTime.localized(LanguageConstant.appLaunguage)
                }
                if generationStarted == true {
                    if let duration = duration {
                        viewModel?.editFreeAITime(time: duration)
                    }
                }
            }
            if model.plusYearlyActive || model.plusMounthlyActive == true {
                print("plus in create video")
                upgradeTitle.text = HomeConstants.HomeText.upgradeTitleActive.localized(LanguageConstant.appLaunguage)
                if viewModel?.getSavedVideos(true)?.count ?? 0 >= 10 {
                    viewModel?.cancellationPlusSubscription()
                    isEnaibleGenerateButton(false)
                    infoView.isHidden = false
                    infoTitle.isHidden = false
                    infoTitle.text = HomeConstants.HomeText.limitGenerationTen.localized(LanguageConstant.appLaunguage)
                }
                if model.plusGenerationTime < duration ?? 0 {
                    isEnaibleGenerateButton(false)
                    infoView.isHidden = false
                    infoTitle.isHidden = false
                    infoTitle.text = HomeConstants.HomeText.limitGenerationTime.localized(LanguageConstant.appLaunguage)
                }
                if generationStarted == true {
                    if let duration = duration {
                        viewModel?.editPlusAITime(time: duration)
                    }
                }
            }
            if model.ultraYearlyActive || model.ultraMounthlyActive == true {
                upgradeTitle.text = HomeConstants.HomeText.upgradeTitleActive.localized(LanguageConstant.appLaunguage)
                print("ultra in create video")
            }
        })
    }
}
