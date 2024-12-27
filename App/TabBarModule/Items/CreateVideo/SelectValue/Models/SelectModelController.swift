//
//  SelectModelController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 12.12.2024.
//

import UIKit
import SnapKit

class SelectModelController: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    weak var delegate: ParametersDelegate?
    var selectValue = String()
    var buttons: [UIButton] = []
    var selectedButton: UIButton?
    
    private var upView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 1
        return view
    }()
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
    private var selectButton: UIButton = {
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
        view.backgroundColor = UIColor(named: "customDarkColor")
        view.layer.cornerRadius = 25
        setupeSubview()
        setupeText()
        setupeColor()
        setupeData()
        setupeButton()
        addConstraints()
    }
    private func setupeSubview() {
        view.addSubview(upView)
        view.addSubview(headerTitle)
        view.addSubview(selectStackView)
        view.addSubview(selectButton)
    }
    private func setupeText() {
        headerTitle.text = "Select Model".localized(LanguageConstant.appLaunguage)
        selectButton.setTitle("Select".localized(LanguageConstant.appLaunguage),
                              for: .normal)
    }
    private func setupeColor() {
        upView.backgroundColor = UIColor(named: "upViewColor")
        headerTitle.textColor = .white
        selectButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
    }
    private func setupeData() {
        genModel.enumerated().forEach { index, value in
            let view = ModelBuilder()
            let select = genModel.firstIndex(where: { $0.title == selectValue })
            view.configure(name: value.title,
                           descripntion: genModel[index].subtitle,
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
        selectValue = genModel[sender.tag].title
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
        selectButton.addTarget(self,
                               action: #selector(saveSelect),
                               for: .touchUpInside)
    }
    @objc func saveSelect() {
        viewModel?.viewAnimate(view: selectButton,
                               duration: 0.2,
                               scale: 0.96)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            guard let self else { return }
            dismiss(animated: true)
            switch selectValue {
            case "Dinson Pro":
                delegate?.setModel(model: .dinsonPro)
            case "Dinson Standart":
                delegate?.setModel(model: .dinsonStandart)
            case "Natash":
                delegate?.setModel(model: .natash)
            default:
                break
            }
        }
    }
    deinit {
        delegate?.defaultArrow()
    }
    private func addConstraints() {
        upView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(3)
        }
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(35)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        selectStackView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(260)
        }
        selectButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.bottomMargin.equalToSuperview().inset(10)
        }
    }
}
