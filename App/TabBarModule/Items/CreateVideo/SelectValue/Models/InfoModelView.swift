//
//  InfoModelView.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 12.12.2024.
//

import UIKit
import SnapKit

class InfoModelView: UIViewController {
    
    var viewModel: HomeViewModelProtocol?

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
        view.textAlignment = .center
        return view
    }()
    private var infoStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.axis = .vertical
        view.layer.cornerRadius = 16
        return view
    }()
    private var backgroundView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "customDarkColor")
        setupeSubview()
        setupeText()
        setupeColor()
        setupeData()
        addConstraints()
    }
    private func setupeSubview() {
        view.addSubview(upView)
        view.addSubview(headerTitle)
        view.addSubview(backgroundView)
        backgroundView.isHidden = true
        view.addSubview(infoStackView)
    }
    private func setupeText() {
        headerTitle.text = "Info about models".localized(LanguageConstant.appLaunguage)
    }
    private func setupeColor() {
        upView.backgroundColor = UIColor(named: "upViewColor")
        headerTitle.textColor = .white
        backgroundView.backgroundColor = HomeConstants.HomeColor.customGrayColor
    }
    private func setupeData() {
        genModel.enumerated().forEach { index, value in
            let view = ModelBuilder()
            view.stackView.backgroundColor = .clear
            view.constraintsInfoView()
            view.separatorView.isHidden = false
            view.noSelectView.isHidden = true
            view.selectView.isHidden = true
            view.showInfo = true
            view.stackButton.backgroundColor = UIColor(named: "infoModelView")
            view.configure(name: value.title,
                           descripntion: genModel[index].descriptions,
                           index: index,
                           selcect: nil)
            infoStackView.addArrangedSubview(view)
        }
    }
    private func addConstraints() {
        upView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(3)
        }
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(35)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
        }
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.bottom.equalTo(infoStackView.snp.bottom)
        }
    }
}
