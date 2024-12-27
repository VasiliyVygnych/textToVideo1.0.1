//
//  AllVideoComtroller.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit
import SnapKit

class AllVideoComtroller: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    private let cellIdentifier = "allVideo"
    var modelVideo: [SavedVideos]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var headerTitle: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 18,
                                weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    private var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.separatorColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = HomeConstants.HomeColor.backgroundColor
        setupeSubview()
        setupeTableView()
        setupeData()
        setupeButton()
        addConstraints()
    }
    private func setupeTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.rowHeight = 190
        tableView.register(SavedVideoCell.self,
                           forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func setupeSubview() {
        view.addSubview(headerTitle)
        view.addSubview(backButton)
        view.addSubview(tableView)
    }
    private func setupeData() {
        headerTitle.text = HomeConstants.HomeText.headerTitle.localized(LanguageConstant.appLaunguage)
        backButton.setBackgroundImage(HomeConstants.HomeImage.arrowLeft,
                                      for: .normal)
        modelVideo = viewModel?.getSavedVideos(true)
    }
    private func setupeButton() {
        backButton.addTarget(self,
                             action: #selector(popToView),
                             for: .touchUpInside)
    }
    @objc func popToView() {
        navigationController?.popViewController(animated: true)
    }
    private func addConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview().inset(80)
            make.height.equalTo(20)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.left.equalTo(20)
            make.width.height.equalTo(36)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
    }
}
extension AllVideoComtroller: UITableViewDataSource,
                                UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        modelVideo?.count ?? 0
    }
    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? SavedVideoCell,
        let model = modelVideo?[indexPath.row] else { return UITableViewCell() }
        cell.viewModel = viewModel
        cell.configure(model,
                       view: self)
        return cell
    }
    func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SavedVideoCell {
            let model = modelVideo?[indexPath.row]
            viewModel?.viewAnimate(view: cell,
                                   duration: 0.2,
                                   scale: 0.97)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
                self?.viewModel?.openDetailVideoController(savedVideos: model,
                                                           albumContents: nil)
            }
        }
    }
}
