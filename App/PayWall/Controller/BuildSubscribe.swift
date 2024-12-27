//
//  BuildSubscribe.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 23.12.2024.
//

import UIKit
import SnapKit

class BuildSubscribe: UIView {
    
    private var stackView: UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.backgroundColor = .clear
        return view
    }()
    private var nameTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .semibold)
        view.textAlignment = .left
        view.numberOfLines = 0
         return view
    }()
    private var selectImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    init() {
        super.init(frame: .zero)
        addSubview()
        setupeConstraints()
        selectImageView.image = UIImage(named: "selectImage")
        nameTitle.textColor = .white
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(data: PayWallDescription) {
        nameTitle.text = data.description
        if data.included == false {
            stackView.alpha = 0.2
        }
    }
    private func addSubview() {
        self.addSubview(stackView)
        stackView.addSubview(selectImageView)
        stackView.addSubview(nameTitle)
    }
    private func setupeConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        selectImageView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        nameTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.equalTo(selectImageView.snp.right).inset(-15)
            make.right.equalTo(-20)
            make.height.greaterThanOrEqualTo(20)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
