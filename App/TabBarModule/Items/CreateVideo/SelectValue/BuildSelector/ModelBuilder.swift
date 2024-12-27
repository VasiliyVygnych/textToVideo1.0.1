//
//  ModelBuilder.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 12.12.2024.
//

import UIKit
import SnapKit

class ModelBuilder: UIView {
    
    var showInfo = false
    var stackButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    var nameTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
         return view
    }()
    var descripntionTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .systemFont(ofSize: 15,
                                weight: .medium)
        view.textAlignment = .left
        view.textColor = .lightGray
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.2
        view.numberOfLines = 0
         return view
    }()
    var selectView: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 29/2
        view.clipsToBounds = false
        return view
    }()
    var stackView: UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.layer.cornerRadius = 21
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    var noSelectView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(named: "colorWhite8")
        view.layer.cornerRadius = 29/2
        return view
    }()
    var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(named: "colorBlack24")
        return view
    }()
    init() {
        super.init(frame: .zero)
        addSubview()
        setupeConstraints()
        stackButton.backgroundColor = HomeConstants.HomeColor.customGrayColor
        self.isUserInteractionEnabled = true
        stackButton.addTarget(self,
                              action: #selector(selectStackTapped),
                              for: .touchUpInside)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(name: String,
                   descripntion: String,
                   index: Int,
                   selcect: Int?) {
        stackButton.tag = index
        selectView.tag = index
        if index == selcect {
            selectView.setImage(HomeConstants.HomeImage.selectImage,
                                for: .normal)
        }
        selectView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        nameTitle.text = name
        descripntionTitle.text = descripntion
        if showInfo {
            let attributedString = NSMutableAttributedString(string: descripntion)
            let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                attributedString.addAttribute(.paragraphStyle,
                                              value: paragraphStyle,
                                              range: NSRange(location: 0,
                                                             length: attributedString.length))
            descripntionTitle.attributedText = attributedString
        }
    }
    @objc func selectStackTapped(_ sender: UIButton) {
        selectView.sendActions(for: .touchUpInside)
    }
    private func addSubview() {
        self.addSubview(stackView)
        stackView.addSubview(stackButton)
        stackView.addSubview(separatorView)
        separatorView.isHidden = true
        stackView.addSubview(selectView)
        stackView.addSubview(noSelectView)
        stackButton.addSubview(nameTitle)
        stackButton.addSubview(descripntionTitle)
    }
    func constraintsInfoView() {
        descripntionTitle.snp.updateConstraints { make in
            make.top.equalTo(nameTitle.snp.bottom).offset(30)
            make.right.equalTo(selectView.snp.left).inset(-10)
            make.left.equalTo(20)
            make.height.greaterThanOrEqualTo(17)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    private func setupeConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.greaterThanOrEqualTo(69)
            make.bottom.equalToSuperview()
        }
        stackButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        nameTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.right.equalTo(selectView.snp.left).inset(-10)
            make.left.equalTo(20)
            make.height.equalTo(20)
        }
        separatorView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(descripntionTitle.snp.top).inset(-15)
        }
        descripntionTitle.snp.makeConstraints { make in
            make.top.equalTo(nameTitle.snp.bottom).offset(5)
            make.right.equalTo(selectView.snp.left).inset(-10)
            make.left.equalTo(20)
            make.height.greaterThanOrEqualTo(17)
            make.bottom.equalToSuperview().inset(15)
        }
        selectView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(29)
            make.right.equalTo(-20)
        }
        noSelectView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(29)
            make.right.equalTo(-20)
        }
    }
}
