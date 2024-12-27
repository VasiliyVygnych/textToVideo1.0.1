//
//  InfoCreditBuilder.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 26.12.2024.
//

import UIKit
import SnapKit

class InfoCreditBuilder: UIView {

   private var stackView: UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.layer.cornerRadius = 21
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    private var nameTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .systemFont(ofSize: 16,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
         return view
    }()
    private var descripntionTitle: UILabel = {
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
    init() {
        super.init(frame: .zero)
        addSubview()
        setupeConstraints()
        self.isUserInteractionEnabled = true
        stackView.backgroundColor =  UIColor(named: "payWallColorView")
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(name: String,
                   descripntion: String) {
        nameTitle.text = name
        descripntionTitle.text = descripntion
    }
    private func addSubview() {
        self.addSubview(stackView)
        stackView.addSubview(nameTitle)
        stackView.addSubview(descripntionTitle)
    }
    private func setupeConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.bottom.equalToSuperview()
        }
        nameTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.right.equalTo(-20)
            make.left.equalTo(20)
            make.height.equalTo(20)
        }
        descripntionTitle.snp.makeConstraints { make in
            make.top.equalTo(nameTitle.snp.bottom).offset(5)
            make.right.equalTo(-20)
            make.left.equalTo(20)
            make.height.greaterThanOrEqualTo(17)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
