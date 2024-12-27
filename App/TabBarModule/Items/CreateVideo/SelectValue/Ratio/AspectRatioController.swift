//
//  AspectRatioController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 17.10.2024.
//

import UIKit
import SnapKit

class AspectRatioController: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    weak var delegate: ParametersDelegate?
    private var heightStack = 0
    var model = ["9:16", "16:9", "3:4", "4:3", "2:1"]
    var buttons: [UIButton] = []
    var selectedButton: UIButton?
    var selectValue = String()

    private var headerTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textColor = .white
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
    private var saveButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
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
        heightStack = model.count * 60
        setupeSubview()
        setupeText()
        setupeColor()
        setupeData()
        addConstraints()
        setupeButton()
    }
    private func setupeSubview() {
        view.addSubview(headerTitle)
        view.addSubview(selectStackView)
        view.addSubview(saveButton)
    }
    private func setupeText() {
        headerTitle.text = HomeConstants.HomeText.headerTitleAspect.localized(LanguageConstant.appLaunguage)
        saveButton.setTitle(HomeConstants.HomeText.saveChanges.localized(LanguageConstant.appLaunguage),
                            for: .normal)
    }
    private func setupeColor() {
        saveButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
        
    }
    private func setupeData() {
        model.enumerated().forEach { index, value in
            let view = BuildSelect()
            let select = model.firstIndex(of: selectValue)
            view.configure(name: value,
                           index: index,
                           selcect: select ?? 0)
            view.selectView.addTarget(self,
                                      action: #selector(selectButtonTapped),
                                      for: .touchUpInside)
            buttons.append(view.selectView)
            selectStackView.addArrangedSubview(view)
        }
    }
    @objc func selectButtonTapped(_ sender: UIButton) {
        selectValue = model[sender.tag]
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
    private func setupeButton() {
        saveButton.addTarget(self,
                             action: #selector(saveRatio),
                             for: .touchUpInside)
    }
    @objc func saveRatio() {
        viewModel?.viewAnimate(view: saveButton,
                               duration: 0.2,
                               scale: 0.96)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegate?.setRatio(value: self?.selectValue ?? "")
            }
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
            make.height.equalTo(heightStack)
        }
        saveButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.bottomMargin.equalToSuperview().inset(20)
        }
    }
}
