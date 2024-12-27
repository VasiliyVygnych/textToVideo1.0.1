//
//  SelectDurationController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 17.10.2024.
//

import UIKit
import SnapKit

class SelectDurationController: UIViewController {
    
    var pluginMode = PluginMode.none
    var viewModel: HomeViewModelProtocol?
    weak var delegate: ParametersDelegate?
    lazy var model = [DurationGenerate.seconds5,
                      DurationGenerate.seconds10]
    
//    var shortsModel = [HomeConstants.HomeText.firstShortsDurationValue.localized(LanguageConstant.appLaunguage),
//                       HomeConstants.HomeText.secondShortsDuratinValue.localized(LanguageConstant.appLaunguage),
//                       HomeConstants.HomeText.thirdShortsDurationValue.localized(LanguageConstant.appLaunguage)]
    var durationModel: [DurationGenerate] = []
    var buttons: [UIButton] = []
    var selectedButton: UIButton?
    var selectValue = String()
    var selectDuration = DurationGenerate.none
    var sheck: String?
    
    private var headerTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textAlignment = .center
        return view
    }()
    private var selectStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        view.axis = .vertical
        return view
    }()
    
    private var otherTimeView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .clear
        return view
    }()
    private var otherTimeTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .semibold)
        view.textColor = .white
        view.textAlignment = .left
        return view
    }()
    private var minuteView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var minuteTextField: UITextField = {
       let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .left
        view.keyboardType = .numberPad
        return view
    }()
    private var minutePlaceholder: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
        return view
    }()
    private var minuteUnit: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
        return view
    }()
    private var secondsView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var secondsTextField: UITextField = {
       let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .left
        view.keyboardType = .numberPad
        return view
    }()
    private var secondsPlaceholder: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
        return view
    }()
    private var secondsUnit: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
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
        view.backgroundColor = HomeConstants.HomeColor.backgroundColor
        checkSubscriptionRequirements()
        setupeSubview()
        setupeText()
        setupeColor()
        addConstraints()
        setupeButton()
        setupeData()
    }
    private func setupeSubview() {
        view.addSubview(headerTitle)
        view.addSubview(selectStackView)
        
        view.addSubview(otherTimeView)
        otherTimeView.addSubview(otherTimeTitle)
        otherTimeView.addSubview(minuteView)
        otherTimeView.isHidden = true
        
        minuteView.addSubview(minuteTextField)
        minuteTextField.delegate = self
        minuteView.addSubview(minutePlaceholder)
        minuteView.addSubview(minuteUnit)
        minuteUnit.isHidden = true
        
        otherTimeView.addSubview(secondsView)
        secondsView.addSubview(secondsTextField)
        secondsTextField.delegate = self
        secondsView.addSubview(secondsPlaceholder)
        secondsView.addSubview(secondsUnit)
        
        view.addSubview(saveButton)
    }
    private func setupeText() {
        headerTitle.text = HomeConstants.HomeText.headerTitleDyration.localized(LanguageConstant.appLaunguage)
        saveButton.setTitle(HomeConstants.HomeText.saveChanges.localized(LanguageConstant.appLaunguage),
                            for: .normal)
        otherTimeTitle.text = HomeConstants.HomeText.otherTimeTitle.localized(LanguageConstant.appLaunguage)
        minutePlaceholder.text = HomeConstants.HomeText.minutePlaceholder.localized(LanguageConstant.appLaunguage)
        secondsPlaceholder.text = HomeConstants.HomeText.secondsPlaceholder.localized(LanguageConstant.appLaunguage)
        minuteUnit.text = HomeConstants.HomeText.minuteUnit.localized(LanguageConstant.appLaunguage)
        secondsUnit.text = HomeConstants.HomeText.secondsUnit.localized(LanguageConstant.appLaunguage)
    }
    private func setupeColor() {
        headerTitle.textColor = .white
        saveButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        minuteView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        secondsView.backgroundColor = HomeConstants.HomeColor.customGrayColor
    }
    private func setupeData() {
        switch pluginMode {
        case .none, .basicWorkflows, .scriptToVideo:
            durationModel.append(contentsOf: model)
            selectStackView.snp.updateConstraints { make in
                make.height.equalTo(durationModel.count * 60)
            }
        case .youtubeShorts:
            otherTimeView.isHidden = true
//            durationModel.append(contentsOf: shortsModel) // переделать модель на enum
            selectStackView.snp.updateConstraints { make in
                make.height.equalTo(durationModel.count * 60)
            }
        case .instagramReels:
            durationModel.append(contentsOf: model)
        }
        durationModel.enumerated().forEach { index, value in
            let view = BuildSelect()
            let select = model.firstIndex(of: selectDuration)
            view.configure(name: value.value,
                           index: index,
                           selcect: select ?? 0)
            view.selectView.addTarget(self,
                                      action: #selector(selectButtonTapped),
                                      for: .touchUpInside)
            buttons.append(view.selectView)
            selectStackView.addArrangedSubview(view)
        }
    }
    private func setupeButton() {
        saveButton.addTarget(self,
                             action: #selector(saveDuration),
                             for: .touchUpInside)
    }
    @objc func selectButtonTapped(_ sender: UIButton) {
        selectValue = durationModel[sender.tag].value
        selectDuration = durationModel[sender.tag]
        
        for button in buttons {
            button.isSelected = false
            button.setImage(nil,
                            for: .normal)
        }
        sender.isSelected = true
        sender.setImage(HomeConstants.HomeImage.selectImage,
                        for: .normal)
        selectedButton = sender
    }
    @objc func saveDuration() {
        viewModel?.viewAnimate(view: saveButton,
                               duration: 0.2,
                               scale: 0.96)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            guard let self else { return }
            dismiss(animated: true)
            delegate?.setDuration(value: selectValue,
                                  duration: selectDuration)
        }
    }
    deinit {
        delegate?.defaultArrow()
    }
    private func addConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.height.equalTo(20)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        selectStackView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(30)
            make.width.equalToSuperview()
            make.height.equalTo(120)
        }
        
        otherTimeView.snp.makeConstraints { make in
            make.top.equalTo(selectStackView.snp.bottom).offset(30)
            make.width.equalToSuperview()
            make.height.equalTo(100)
        }
        otherTimeTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(20)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        minuteView.snp.makeConstraints { make in
            make.top.equalTo(otherTimeTitle.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.height.equalTo(50)
            make.right.equalTo(otherTimeView.snp.centerX).offset(-10)
        }
        minuteTextField.snp.makeConstraints { make in
            make.centerY.equalTo(minuteView)
            make.left.equalTo(15)
            make.width.greaterThanOrEqualTo(100)
            make.height.equalTo(30)
        }
        minutePlaceholder.snp.makeConstraints { make in
            make.centerY.equalTo(minuteView)
            make.left.equalTo(15)
            make.width.lessThanOrEqualTo(100)
            make.height.equalTo(30)
        }
        minuteUnit.snp.makeConstraints { make in
            make.centerY.equalTo(minuteView)
            make.width.lessThanOrEqualTo(50)
            make.height.equalTo(30)
            make.left.equalTo(minuteTextField.snp.right).inset(-5)
        }
        
        secondsView.snp.makeConstraints { make in
            make.top.equalTo(otherTimeTitle.snp.bottom).offset(15)
            make.right.equalTo(-20)
            make.height.equalTo(50)
            make.left.equalTo(otherTimeView.snp.centerX).offset(10)
        }
        secondsTextField.snp.makeConstraints { make in
            make.centerY.equalTo(secondsView)
            make.left.equalTo(15)
            make.width.greaterThanOrEqualTo(100)
            make.height.equalTo(30)
        }
        secondsPlaceholder.snp.makeConstraints { make in
            make.centerY.equalTo(secondsView)
            make.left.equalTo(15)
            make.width.lessThanOrEqualTo(100)
            make.height.equalTo(30)
        }
        secondsUnit.snp.makeConstraints { make in
            make.centerY.equalTo(minuteView)
            make.width.lessThanOrEqualTo(50)
            make.height.equalTo(30)
            make.left.equalTo(secondsTextField.snp.right).inset(-5)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.bottomMargin.equalToSuperview().inset(20)
        }
    }
}
extension SelectDurationController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range,
                                                               with: string)
        if textField == minuteTextField {
            minuteTextField.text = newString
            minuteTextField.snp.updateConstraints { make in
                make.width.greaterThanOrEqualTo(15)
            }
            if newString.isEmpty {
                minuteUnit.isHidden = true
                minutePlaceholder.isHidden = false
            } else {
                minuteUnit.isHidden = false
                minutePlaceholder.isHidden = true
            }
        }
        if textField == secondsTextField {
            secondsTextField.text = newString
            secondsTextField.snp.updateConstraints { make in
                make.width.greaterThanOrEqualTo(15)
            }
            if newString.isEmpty {
                secondsUnit.isHidden = true
                secondsPlaceholder.isHidden = false
            } else {
                secondsPlaceholder.isHidden = true
                secondsUnit.isHidden = false
            }
        }
        let duration = String(format: "%@ \(HomeConstants.HomeText.minuteTitle.localized(LanguageConstant.appLaunguage)) %@ \(HomeConstants.HomeText.secondsTitle.localized(LanguageConstant.appLaunguage))",
                              minuteTextField.text ?? "",
                              secondsTextField.text ?? "")
        selectValue = duration
        return false
    }
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension SelectDurationController {
    func checkSubscriptionRequirements() {
        let data = viewModel?.getAppData()
        data?.forEach({ model in
            if model.plusYearlyActive || model.plusMounthlyActive || model.freeIsActive == true {
                self.model.removeLast()
            }
        })
    }
}
