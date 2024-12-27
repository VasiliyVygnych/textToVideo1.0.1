//
//  ScriptToVideoPlugin.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 17.10.2024.
//

import UIKit
import SnapKit

class ScriptToVideoPlugin: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    weak var delegate: PluginDelegate?
    var alerts: AlertManagerProtocol?
    private var gesture = UITapGestureRecognizer()
    private var activityIndicator = UIActivityIndicatorView()
    private var selector = true
    private var contentSize: CGSize {
        CGSize(width: view.frame.width,
               height: view.frame.height)
    }
    var model: BaseData?
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.backgroundColor = .clear
        view.contentSize = contentSize
        return view
    }()
   
    private var descriptionTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .semibold)
        view.textAlignment = .left
        return view
    }()
    
    private var descriptionView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var descriptionTextView: UITextView = {
        let view = UITextView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.isScrollEnabled = false
        view.scrollsToTop = false
        view.backgroundColor = .clear
        view.keyboardType = .default
        return view
    }()
    private var descriptionPlaceholder: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()
    
    private var AIdescriptionTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .semibold)
        view.textAlignment = .left
        return view
    }()
    private var imageCrown: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    private var AISwitch: UISwitch = {
       let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.isOn = false
        return view
    }()
    
    private var AIdescriptionView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var AIdescriptionTextView: UITextView = {
        let view = UITextView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.isScrollEnabled = false
        view.scrollsToTop = false
        view.backgroundColor = .clear
        view.keyboardType = .default
        return view
    }()
    private var AIdescriptionPlaceholder: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()
    private var saveButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        view.setTitleColor(.white,
                           for: .normal)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "backgroundCustom")
        setupeSubview()
        setupeText()
        setupeColor()
        setupeData()
        addConstraints()
        setupeButton()
        if model?.description?.isEmpty == false {
            setupeEditData(model)
            saveButton.isEnabled = true
            saveButton.alpha = 1
        }
        viewModel?.requestDelegate = self
        checkSubscriptionRequirements()
        addToolbar()
    }
    func setupeEditData(_ data: BaseData?) {
        descriptionTextView.text = data?.description
        descriptionPlaceholder.isHidden = true
            
        if data?.descriptionAI != "" {
            AISwitch.isOn = true
            AIdescriptionTextView.text = data?.descriptionAI
            AIdescriptionPlaceholder.isHidden = true
            AIdescriptionView.isHidden = false
        }
    }
    private func setupeSubview() {
        view.addSubview(scrollView)
        scrollView.addSubview(descriptionTitle)
        scrollView.addSubview(descriptionView)
        descriptionView.addSubview(descriptionTextView)
        descriptionTextView.delegate = self
        descriptionView.addSubview(descriptionPlaceholder)
        
        scrollView.addSubview(AIdescriptionTitle)
        scrollView.addSubview(imageCrown)
        scrollView.addSubview(AISwitch)
        
        scrollView.addSubview(activityIndicator)
        
        scrollView.addSubview(AIdescriptionView)
        AIdescriptionView.isHidden = true
        AIdescriptionView.addSubview(AIdescriptionTextView)
        AIdescriptionTextView.delegate = self
        AIdescriptionView.addSubview(AIdescriptionPlaceholder)
        
        view.addSubview(saveButton)
        enableSaveButton(false)
    }
    func enableSaveButton(_ bool: Bool) {
        switch bool {
        case true:
            saveButton.isEnabled = true
            saveButton.alpha = 1
        case false:
            saveButton.isEnabled = false
            saveButton.alpha = 0.3
        }
    }
    private func setupeText() {
        descriptionTitle.text = HomeConstants.HomeText.titleSkriptToVideo.localized(LanguageConstant.appLaunguage)
        descriptionPlaceholder.text = HomeConstants.HomeText.descSkriptToVideo.localized(LanguageConstant.appLaunguage)
        AIdescriptionTitle.text = HomeConstants.HomeText.AIdescriptionTitle.localized(LanguageConstant.appLaunguage)
        AIdescriptionPlaceholder.text = HomeConstants.HomeText.AIdescriptionPlaceholder.localized(LanguageConstant.appLaunguage)
        
        saveButton.setTitle(HomeConstants.HomeText.saveChanges.localized(LanguageConstant.appLaunguage),
                            for: .normal)
    }
    private func setupeColor() {
        descriptionTitle.textColor = HomeConstants.HomeColor.colorWhite77
        descriptionView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        descriptionPlaceholder.textColor = HomeConstants.HomeColor.colorWhite46
        AISwitch.backgroundColor = HomeConstants.HomeColor.colorWhite38
        AISwitch.onTintColor = HomeConstants.HomeColor.customBlueColor
        AIdescriptionTitle.textColor = HomeConstants.HomeColor.colorWhite77
        AIdescriptionView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        AIdescriptionPlaceholder.textColor = HomeConstants.HomeColor.colorWhite46
        activityIndicator.color = HomeConstants.HomeColor.customBlueColor
        
        saveButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
    }
    private func setupeData() {
        imageCrown.image = HomeConstants.HomeImage.whiteCrown
    }
    private func setupeButton() {
        AISwitch.addTarget(self,
                           action: #selector(selectSwitch),
                           for: .valueChanged)
        saveButton.addTarget(self,
                             action: #selector(saveChanges),
                             for: .touchUpInside)
        scrollView.addGestureRecognizer(gesture)
        gesture.addTarget(self,
                          action: #selector(tapScrollView))
        
    }
    @objc func tapScrollView() {
        scrollView.endEditing(true)
    }
    @objc func selectSwitch(sender: UISwitch) {
        switch sender.isOn {
        case true:
            AIdescriptionView.isHidden = false
        case false:
            descriptionPlaceholder.isHidden = false
            descriptionTextView.text = nil
            AIdescriptionView.isHidden = true
            AIdescriptionTextView.text = nil
            AIdescriptionPlaceholder.isHidden = false
        }
    }
    @objc func saveChanges() {
        viewModel?.viewAnimate(view: saveButton,
                               duration: 0.2,
                               scale: 0.96)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            self?.dismiss(animated: true) 
        }
    }
    deinit {
        let data = BaseData(id: nil,
                             mode: .scriptToVideo,
                             duration: nil,
                             ratio: nil,
                             description: descriptionTextView.text,
                             descriptionAI: AIdescriptionTextView.text,
                             music: nil)
        delegate?.dataForVideoGeneration(data: data)
    }
    private func addToolbar() {
        selector = false
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: HomeConstants.HomeText.doneTitle,
                                         style: .done,
                                         target: self,
                                         action: #selector(requestAI))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        toolbar.items = [flexibleSpace, doneButton]
        AIdescriptionTextView.inputAccessoryView = toolbar
    }
    @objc func requestAI() {
        activityIndicator.startAnimating()
        viewModel?.sendScript(text: AIdescriptionTextView.text)
        AIdescriptionTextView.resignFirstResponder()
    }
    private func addConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
        descriptionTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitle.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(200)
        }
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.width.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
        descriptionPlaceholder.snp.makeConstraints { make in
            make.top.equalTo(18)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(20)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(AIdescriptionTitle.snp.centerY)
            make.left.equalTo(imageCrown.snp.right).inset(-10)
        }
        
        AIdescriptionTitle.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.width.greaterThanOrEqualTo(50)
            make.height.equalTo(20)
        }
        imageCrown.snp.makeConstraints { make in
            make.centerY.equalTo(AIdescriptionTitle.snp.centerY)
            make.width.height.equalTo(20)
            make.left.equalTo(AIdescriptionTitle.snp.right).inset(-10)
        }
        AISwitch.snp.makeConstraints { make in
            make.centerY.equalTo(AIdescriptionTitle.snp.centerY)
            make.right.equalTo(descriptionView.snp.right)
        }
        
        AIdescriptionView.snp.makeConstraints { make in
            make.top.equalTo(AIdescriptionTitle.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(170)
        }
        AIdescriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.width.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
        AIdescriptionPlaceholder.snp.makeConstraints { make in
            make.top.equalTo(18)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.bottomMargin.equalToSuperview().inset(20)
        }
    }
}
extension ScriptToVideoPlugin: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == descriptionTextView {
            descriptionTextView.text = textView.text
            if textView.text.isEmpty {
                descriptionPlaceholder.isHidden = false
                enableSaveButton(false)
            } else {
                descriptionPlaceholder.isHidden = true
                enableSaveButton(true)
            }
        }
        if textView == AIdescriptionTextView {
            AIdescriptionTextView.text = textView.text
            if textView.text.isEmpty {
                AIdescriptionPlaceholder.isHidden = false
            } else {
                AIdescriptionPlaceholder.isHidden = true
            }
        }
    }
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if textView == AIdescriptionTextView {
            if AIdescriptionTextView.text.isEmpty == false {
                choiceWriter(text)
            }
        }
        return true
    }
    private func choiceWriter(_ text: String) {
        if selector == true {
            if text == "\n" {
                activityIndicator.startAnimating()
                viewModel?.sendScript(text: text)
            }
        }
    }
}
extension ScriptToVideoPlugin {
    func checkSubscriptionRequirements() {
        let data = viewModel?.getAppData()
        data?.forEach({ model in
            if model.freeIsActive == true {
                print("free in ScriptToVideo")
                AIdescriptionPlaceholder.text = HomeConstants.HomeText.limitationsScript.localized(LanguageConstant.appLaunguage)
                AIdescriptionTextView.isUserInteractionEnabled = false
            }
            if model.plusYearlyActive || model.plusMounthlyActive == true {
                print("plus in ScriptToVideo")
                AIdescriptionPlaceholder.text = HomeConstants.HomeText.limitationsScript.localized(LanguageConstant.appLaunguage)
                AIdescriptionTextView.isUserInteractionEnabled = false
            }
        })
    }
}
extension ScriptToVideoPlugin: RequestDelegate {
    func getResultVideoToVideo() {}
    func getResultTextToVideo(_ data: TextToImageResponse?) {}
    func getResult(data: ResponseData?) {}
    func getAIText(data: ScriptData?) {
        descriptionPlaceholder.isHidden = true
        activityIndicator.stopAnimating()
        descriptionTextView.text = data?.gptResult.prompt
        enableSaveButton(true)
    }
    func error() {
        activityIndicator.stopAnimating()
        errorGenefation()
    }
    func errorGenefation() {
        let action = UIAlertAction(title: "Ok",
                                   style: .cancel) { _ in
            
        }
        if let errorAlert = alerts?.requestError(title: HomeConstants.HomeText.errorTitle.localized(LanguageConstant.appLaunguage),
                                                 message: HomeConstants.HomeText.errorMessage.localized(LanguageConstant.appLaunguage),
                                                 action: action) {
            present(errorAlert,
                    animated: true)
        }
    }
}
