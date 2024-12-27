//
//  ScriptToVideoPlugin.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 17.10.2024.
//

import UIKit
import SnapKit

class ScriptToVideoPlugin: UIViewController {
    
    var viewModel: HomeViewModelProtocol?
    weak var delegate: PluginDelegate?
    private var gesture = UITapGestureRecognizer()
    private var contentSize: CGSize {
        CGSize(width: view.frame.width,
               height: view.frame.height)
    }
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.backgroundColor = .clear
        view.contentSize = contentSize
        return view
    }()
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private var saveButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.titleLabel?.font = .systemFont(ofSize: 15,
                                            weight: .bold)
        view.setTitleColor(.white,
                           for: .normal)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "backgroundCustom")
        setupeSubview()
        setupeText()
        setupeColor()
        setupeData()
        addConstraints()
        setupeButton()
        
        
        
    }
    private func setupeSubview() {
        view.addSubview(scrollView)
        
        
        
        
        
        
        view.addSubview(saveButton)
        saveButton.isEnabled = false
        saveButton.alpha = 0.3
    }
    private func setupeText() {
        
        
        saveButton.setTitle(HomeConstants.HomeText.saveChanges,
                            for: .normal)
    }
    private func setupeColor() {
        
        
        
        saveButton.backgroundColor = HomeConstants.HomeColor.customBlueColor
    }
    private func setupeData() {
        
        
        
        
    }
    private func setupeButton() {

        
        
        
        
        
        saveButton.addTarget(self,
                             action: #selector(saveChanges),
                             for: .touchUpInside)
    }
    @objc func ttttt() {
        
        
      
        
        
    }
    @objc func saveChanges() {
        viewModel?.viewAnimate(view: saveButton,
                               duration: 0.2,
                               scale: 0.96)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
            self.dismiss(animated: true) {
                self.delegate?.addData()
            }
        }
    }
    private func addConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
       
        
        
        
        
        
        
        
        
        saveButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.height.equalTo(58)
            make.bottomMargin.equalToSuperview().inset(20)
        }
    }
}
