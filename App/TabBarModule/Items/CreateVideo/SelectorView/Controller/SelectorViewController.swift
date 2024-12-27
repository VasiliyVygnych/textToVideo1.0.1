//
//  SelectorViewController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 05.12.2024.
//

import UIKit
import SnapKit

class SelectorViewController: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    private let collectionIdentifier = "selectCell"
    weak var delegate: SelectorDelegate?
    
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
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
       let view = UICollectionView(frame: .zero,
                                             collectionViewLayout: self.layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        return view
   }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "customDarkColor")
        view.layer.cornerRadius = 15
        setupeSubview()
        setupeCollection()
        setupeText()
        setupeColor()
        addConstraints()
    }
    private func setupeSubview() {
        view.addSubview(upView)
        view.addSubview(headerTitle)
        view.addSubview(collectionView)
    }
    private func setupeCollection() {
        collectionView.register(SelectCell.self,
                                forCellWithReuseIdentifier: collectionIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func setupeText() {
        headerTitle.text = "Select a category".localized(LanguageConstant.appLaunguage)
    }
    private func setupeColor() {
        upView.backgroundColor = UIColor(named: "upViewColor")
        headerTitle.textColor = .white
        collectionView.backgroundColor = .clear
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
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
    }
}
extension SelectorViewController: UICollectionViewDelegate,
                                  UICollectionViewDataSource,
                                  UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        selectorModel.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionIdentifier,
                                                            for: indexPath) as? SelectCell else { return UICollectionViewCell() }
        let model = selectorModel[indexPath.row]
        cell.configure(model)
        cell.createButton.tag = indexPath.row
        cell.createButton.addTarget(self,
                                    action: #selector(openCreateVideo),
                                    for: .touchUpInside)
        if indexPath.row == 1 {
            cell.previewImage.alpha = 0.2
            cell.soonView.isHidden = false
        }
        return cell
    }
    @objc func openCreateVideo(_ sender: UIButton) {
        let model = selectorModel[sender.tag]
        viewModel?.viewAnimate(view: sender,
                               duration: 0.3,
                               scale: 0.95)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            switch model.selector {
            case .textImageToVideo:
                self?.delegate?.openView(.textImageToVideo)
                self?.dismiss(animated: true)
            case .videoToVideo:
//                self?.delegate?.openView(.videoToVideo)
//                self?.dismiss(animated: true)
                break
            case .base:
                self?.delegate?.openView(.base)
                self?.dismiss(animated: true)
            case .none:
                break
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (collectionView.bounds.height)
        let width = (collectionView.bounds.width - 50) / 2
        return CGSize(width: width,
                      height: height)
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,
                            left: 20,
                            bottom: 10,
                            right: 20)
    }
}
