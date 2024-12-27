//
//  DurationView.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 05.12.2024.
//

import UIKit
import SnapKit

class DurationView: UIView {
    
    var viewModel: HomeViewModelProtocol?
    var views = UIViewController()
    weak var delegate: DurationDelegate?
    var duration: String?
    
    
    private var durationTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .semibold)
        view.textAlignment = .left
        return view
    }()
    private var durationView: UIButton = {
       let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        return view
    }()
    private var durationArrow: UIImageView = {
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
    private var durationValue: UILabel = {
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
        addSubview(durationTitle)
        addSubview(durationView)
        durationView.addSubview(durationArrow)
        durationView.addSubview(durationSeparatorView)
        durationView.addSubview(durationValue)
    }
    func setupeText() {
        if duration == nil {
            durationValue.text = "5 \(HomeConstants.HomeText.secondsTitle.localized(LanguageConstant.appLaunguage))"
        } else {
            durationValue.text = duration
        }
        durationTitle.text = HomeConstants.HomeText.headerTitleDyration.localized(LanguageConstant.appLaunguage)
    }
    private func setupeColor() {
        durationTitle.textColor = HomeConstants.HomeColor.colorWhite77
        durationView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        durationSeparatorView.backgroundColor = HomeConstants.HomeColor.colorGray14
    }
    private func setupeImage() {
        durationArrow.image = HomeConstants.HomeImage.arrowDown
        
    }
    private func setupeAction() {
        durationView.addTarget(self,
                               action: #selector(openSeelctDuration),
                               for: .touchUpInside)
    }
    @objc func openSeelctDuration() {
        delegate?.isShowView(true)
        UIView.animate(withDuration: 0.2) {
            self.durationArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {  [weak self] in
            guard let self else { return }
            if let value = durationValue.text {
                viewModel?.openSelectDurationController(view: views,
                                                        selectValue: value,
                                                        pluginMode: .none,
                                                        delegate: self)
            }
        }
    }
    private func setupeConstraints() {
        durationTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(20)
            make.height.equalTo(20)
            make.width.equalToSuperview()
        }
        durationView.snp.makeConstraints { make in
            make.top.equalTo(durationTitle.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        durationArrow.snp.makeConstraints { make in
            make.centerY.equalTo(durationView)
            make.right.equalTo(-15)
            make.width.height.equalTo(24)
        }
        durationSeparatorView.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.right.equalTo(durationArrow.snp.left).inset(-15)
        }
        durationValue.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalTo(durationView)
            make.height.equalTo(20)
            make.right.equalTo(durationSeparatorView.snp.left).inset(-10)
        }
    }
}
extension DurationView: ParametersDelegate {
    func defaultArrow() {
        delegate?.isShowView(false)
        UIView.animate(withDuration: 0.2) {
            self.durationArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
        }
    }
    func setRatio(value: String) {}
    func setModel(model: ModelsToCreate) {}
    
    func setDuration(value: String,
                     duration: DurationGenerate) {
        durationValue.text = value
        delegate?.setValue(value: value,
                           duration: duration)
    }
}
