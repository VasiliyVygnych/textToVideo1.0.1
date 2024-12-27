//
//  CategoryViewController.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 09.12.2024.
//

import UIKit
import SnapKit

class CategoryViewController: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    private var cellIdentifier = "categoryCell"
    weak var delegate: CategoryViewDelegate?
    
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
        layout.scrollDirection = .vertical
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
       let view = UICollectionView(frame: .zero,
                                             collectionViewLayout: self.layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
   }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = HomeConstants.HomeColor.customDarkColor
        setupeSubview()
        setupecollectionView()
        setupeText()
        setupeColor()
        addConstraints()
    }
    private func setupeSubview() {
        view.addSubview(headerTitle)
        view.addSubview(collectionView)
    }
    private func setupecollectionView() {
        collectionView.register(CategoryCell.self,
                                forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func setupeText() {
        headerTitle.text = "Select a category".localized(LanguageConstant.appLaunguage)
    }
    private func setupeColor() {
        headerTitle.textColor = .white
        collectionView.backgroundColor = .clear
    }
    private func addConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.bottom.equalToSuperview()
        }
    }
}
extension CategoryViewController: UICollectionViewDataSource,
                              UICollectionViewDelegate,
                              UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        categoriesModel.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                            for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        let model = categoriesModel[indexPath.item]
        cell.configureData(model)
        cell.viewModel = viewModel
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let collectionView = self.collectionView.cellForItem(at: indexPath) {
            let model = categoriesModel[indexPath.item]
            viewModel?.viewAnimate(view: collectionView,
                                   duration: 0.2,
                                   scale: 0.96)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
                self?.delegate?.didSelectCategory(model.name,
                                                  image: model.image)
                self?.dismiss(animated: true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 20) / 2
        return CGSize(width: width,
                      height: 202)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,
                            left: 0,
                            bottom: 10,
                            right: 0)
    }
}
