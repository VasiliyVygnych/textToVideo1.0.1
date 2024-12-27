//
//  EditVideoController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 09.11.2024.
//

import UIKit
import SnapKit

class EditVideoController: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    private let editMedia = EditMedia()
    private let contentEditor = ContentEditor()
    private var editMusic = EditMusic()
    private let cellIdentifier = "editors"
    var selectedIndexPath: IndexPath?
    private var model = ["Edit Media", "Edit Script", "Edit Music"]
    
    
    private var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    lazy var collectionEditors: UICollectionView = {
       let view = UICollectionView(frame: .zero,
                                   collectionViewLayout: self.layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        return view
   }()
    
    private var discardButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        view.layer.cornerRadius = 12
        view.tag = 1
        return view
    }()
    private var applyButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        view.layer.cornerRadius = 12
        view.tag = 2
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = HomeConstants.HomeColor.backgroundColor
        setupeSubview()
        setupeText()
        setupeColor()
        setupeData()
        addEditor()
        setupeCollection()
        addConstraints()
        setupeButton()
    }
    private func setupeCollection() {
        collectionEditors.register(EditorsCell.self,
                                forCellWithReuseIdentifier: cellIdentifier)
        collectionEditors.delegate = self
        collectionEditors.dataSource = self
    }
    private func setupeSubview() {
        view.addSubview(backButton)
        
        view.addSubview(collectionEditors)
        editMedia.isHidden = true
        contentEditor.isHidden = true
        
        view.addSubview(editMusic)
        editMusic.viewModel = viewModel
        editMusic.isHidden = true

        view.addSubview(discardButton)
        view.addSubview(applyButton)
        
        isEnabledApply(false)
    }
    private func addEditor() {
        view.addSubview(editMedia)
        editMedia.viewModel = viewModel
//        editMedia.setupeText()
        view.addSubview(contentEditor)
//        contentEditor.setupeText()
        contentEditor.viewModel = viewModel
    }
    private func isEnabledApply(_ bool: Bool) {
        if bool {
            applyButton.isEnabled = bool
            applyButton.alpha = 1
        } else {
            applyButton.isEnabled = bool
            applyButton.alpha = 0.3
        }
    }
    private func setupeText() {
        discardButton.setTitle(HomeConstants.HomeText.discardTitle.localized(LanguageConstant.appLaunguage),
                               for: .normal)
        applyButton.setTitle(HomeConstants.HomeText.applyTitle.localized(LanguageConstant.appLaunguage),
                             for: .normal)
    }
    private func setupeColor() {
        discardButton.backgroundColor = HomeConstants.HomeColor.editButtoncolor
        applyButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
    }
    private func setupeData() {
        backButton.setBackgroundImage(HomeConstants.HomeImage.arrowLeft,
                                      for: .normal)
    }
    private func setupeButton() {
        backButton.addTarget(self,
                             action: #selector(popToView),
                             for: .touchUpInside)
        discardButton.addTarget(self,
                                action: #selector(tapBuutonEdit),
                                for: .touchUpInside)
        applyButton.addTarget(self,
                              action: #selector(tapBuutonEdit),
                              for: .touchUpInside)
    }
    @objc func tapBuutonEdit(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            viewModel?.viewAnimate(view: discardButton,
                                   duration: 0.2,
                                   scale: 0.96)
            
        case 2:
            viewModel?.viewAnimate(view: applyButton,
                                   duration: 0.2,
                                   scale: 0.96)
        default:
            break
        }
    }
    @objc func popToView() {
        navigationController?.popViewController(animated: true)
    }
    private func addConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.left.equalTo(20)
            make.width.height.equalTo(36)
        }

        collectionEditors.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.left.equalTo(backButton.snp.right).inset(-10)
            make.right.equalTo(-20)
            make.height.equalTo(50)
        }
        
        
        contentEditor.snp.makeConstraints { make in
            make.top.equalTo(collectionEditors.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(153)
        }
        editMedia.snp.makeConstraints { make in
            make.top.equalTo(contentEditor.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(discardButton.snp.top).inset(-15)
        }
        editMusic.snp.makeConstraints { make in
            make.top.equalTo(collectionEditors.snp.bottom)
            make.width.equalToSuperview()
//            make.bottom.equalTo(discardButton.snp.top).inset(-15)
            make.bottom.equalToSuperview()
        }
        
        
        
        
        
        
        
        discardButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.right.equalTo(view.snp.centerX).offset(-5)
            make.bottomMargin.equalToSuperview().inset(20)
        }
        applyButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.height.equalTo(58)
            make.left.equalTo(view.snp.centerX).offset(5)
            make.bottomMargin.equalToSuperview().inset(20)
        }
    }
}
extension EditVideoController: UICollectionViewDelegate,
                               UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        model.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                            for: indexPath) as? EditorsCell else { return UICollectionViewCell() }
        cell.nameTitle.text = model[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        switch indexPath.row {
        case 0:
            editMusic.isHidden = true
            editMedia.isHidden = false
            contentEditor.isHidden = false
            addEditor()
        case 1:
            editMusic.isHidden = true
            editMedia.isHidden = true
            contentEditor.isHidden = true
        case 2:
            editMusic.isHidden = false
            editMedia.isHidden = true
            contentEditor.isHidden = true
        default:
            break
        }
        let index = max(0, indexPath.item - 1)
        let indexToScroll = IndexPath(item: index,
                                      section: indexPath.section)
        collectionView.scrollToItem(at: indexToScroll,
                                    at: .left,
                                    animated: true)
    }
}
