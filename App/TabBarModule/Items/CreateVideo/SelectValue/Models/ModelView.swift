//
//  ModelView.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 12.12.2024.
//

import UIKit
import SnapKit

final class ModelView: UIView {
    
    var viewModel: HomeViewModelProtocol?
    var views = UIViewController()
    weak var delegate: SelectModelDelgate?
    var modelSelect: String?
    
    private var headerTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .semibold)
        view.textAlignment = .left
        return view
    }()
    private var infoButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var modelView: UIButton = {
       let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        return view
    }()
    private var modelArrow: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    private var durationSeparatorView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var modelValue: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
        return view
    }()
    init() {
        super.init(frame: .zero)
        backgroundColor = HomeConstants.HomeColor.backgroundColor
        addSubview()
        setupeText()
        setupeColor()
        setupeImage()
        setupeConstraints()
        setupeAction()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addSubview() {
        addSubview(headerTitle)
        addSubview(infoButton)
        addSubview(modelView)
        modelView.addSubview(modelArrow)
        modelView.addSubview(durationSeparatorView)
        modelView.addSubview(modelValue)
    }
    func setupeText() {
        if modelSelect == nil {
            modelValue.text = "Natash"
        } else {
            modelValue.text = modelSelect
        }
        headerTitle.text = "Select Model".localized(LanguageConstant.appLaunguage)
    }
    private func setupeColor() {
        headerTitle.textColor = HomeConstants.HomeColor.colorWhite77
        modelView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        durationSeparatorView.backgroundColor = HomeConstants.HomeColor.colorGray14
    }
    private func setupeImage() {
        modelArrow.image = HomeConstants.HomeImage.arrowDown
        infoButton.setBackgroundImage(UIImage(named: "infoButtonImage"),
                                      for: .normal)
    }
    private func setupeAction() {
        modelView.addTarget(self,
                            action: #selector(openSeelctDuration),
                            for: .touchUpInside)
        infoButton.addTarget(self,
                             action: #selector(openInfo),
                             for: .touchUpInside)
    }
    @objc func openSeelctDuration() {
        delegate?.isShowView(true)
        UIView.animate(withDuration: 0.2) {
            self.modelArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {  [weak self] in
            guard let self else { return }
            if let value = modelValue.text {
                viewModel?.presentSelectModelController(delegate: self,
                                                        selectValue: value)
            }
        }
    }
    @objc func openInfo() {
        let vc = InfoModelView()
        views.present(vc, animated: true)
    }
    private func setupeConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(20)
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        infoButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.width.height.equalTo(28)
            make.bottom.equalTo(modelView.snp.top).inset(-15)
        }
        modelView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        modelArrow.snp.makeConstraints { make in
            make.centerY.equalTo(modelView)
            make.right.equalTo(-15)
            make.width.height.equalTo(24)
        }
        durationSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.right.equalTo(modelArrow.snp.left).inset(-15)
        }
        modelValue.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalTo(modelView)
            make.height.equalTo(20)
            make.right.equalTo(durationSeparatorView.snp.left).inset(-10)
        }
    }
}
extension ModelView: ParametersDelegate {
    func setDuration(value: String,
                     duration: DurationGenerate) {}
    
    func defaultArrow() {
        delegate?.isShowView(false)
        UIView.animate(withDuration: 0.2) {
            self.modelArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
        }
    }
    func setRatio(value: String) {}
    func setModel(model: ModelsToCreate) {
        delegate?.selectModel(model)
        modelValue.text = model.value
    }
}
