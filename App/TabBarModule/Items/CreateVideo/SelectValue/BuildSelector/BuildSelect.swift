//
//  AspectRatioSelect.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 17.10.2024.
//

import UIKit
import SnapKit

class BuildSelect: UIView {
    
    var stackButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    private var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var nameTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .systemFont(ofSize: 16,
                                weight: .semibold)
        view.textAlignment = .left
        view.textColor = .white
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
    init() {
        super.init(frame: .zero)
        addSubview()
        setupeConstraints()
        self.isUserInteractionEnabled = true
        stackButton.addTarget(self,
                              action: #selector(selectStackTapped),
                              for: .touchUpInside)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(name: String,
                   index: Int,
                   selcect: Int?) {
        stackButton.tag = index
        selectView.tag = index
        if index == selcect {
            selectView.setImage(HomeConstants.HomeImage.selectImage,
                                for: .normal)
        }
        selectView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        separatorView.backgroundColor = HomeConstants.HomeColor.colorGray14
        nameTitle.text = name
    }
    @objc func selectStackTapped(_ sender: UIButton) {
        selectView.sendActions(for: .touchUpInside)
    }
    private func addSubview() {
        self.addSubview(stackView)
        stackView.addSubview(stackButton)
        stackView.addSubview(selectView)
        stackButton.addSubview(separatorView)
        stackButton.addSubview(nameTitle)
    }
    private func setupeConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
        stackButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        separatorView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        nameTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.left.equalTo(20)
            make.height.equalTo(27)
        }
        selectView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(29)
            make.right.equalTo(-20)
        }
    }
}
