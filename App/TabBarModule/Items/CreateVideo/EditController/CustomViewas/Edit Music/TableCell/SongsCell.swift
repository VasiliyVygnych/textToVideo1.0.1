//
//  SongsCell.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 14.11.2024.
//

import UIKit

class SongsCell: UITableViewCell {
    
    weak var delegate: SongViewDelegate?
    var tapButton = 0
    var selectIndex = Int()
    
    private var conteinerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    var playerPlayButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    var playButtonImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var nameTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                 weight: .bold)
        view.textColor = .white
        view.textAlignment = .left
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.2
        return view
    }()
    private var timeTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .semibold)
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }()
    private var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var descriptionTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .semibold)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .left
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.2
        return view
    }()
    private var selectImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = HomeConstants.HomeColor.backgroundColor
        addSubview()
        setupeColor()
        setupeConstraint()
        playButtonImage.image = HomeConstants.HomeImage.miniPlay
        selectImage.image = HomeConstants.HomeImage.selectImage
        playerPlayButton.addTarget(self,
                                   action: #selector(playCellMusic),
                                   for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func select() {
        selectImage.isHidden = false
        conteinerView.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(-40)
            make.height.equalTo(80)
        }
    }
    func deselect() {
        selectImage.isHidden = true
        conteinerView.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(0)
            make.width.equalToSuperview().inset(0)
            make.height.equalTo(80)
        }
    }
    func configuration() {
        nameTitle.text = "test test test"
        timeTitle.text = "3:32"
        descriptionTitle.text = "test test test test"
    }
    private func setupeColor() {
        playerPlayButton.backgroundColor = HomeConstants.HomeColor.editButtoncolor
        
        timeTitle.textColor = .lightGray
        separatorView.backgroundColor = .lightGray
        descriptionTitle.textColor = .lightGray
    }
    private func addSubview() {
        
        contentView.addSubview(conteinerView)
        
        
        conteinerView.addSubview(playerPlayButton)
        playerPlayButton.addSubview(playButtonImage)
        conteinerView.addSubview(nameTitle)
        conteinerView.addSubview(timeTitle)
        conteinerView.addSubview(separatorView)
        conteinerView.addSubview(descriptionTitle)
        conteinerView.addSubview(selectImage)
        selectImage.isHidden = true
    }
    @objc func playCellMusic(_ sender: UIButton) {
        tapButton += 1
        switch tapButton {
            case 1: // play
            delegate?.cellStart()
            delegate?.setIndexPath(IndexPath(row: sender.tag,
                                             section: 0))
            playButtonImage.image = HomeConstants.HomeImage.stopButton
            delegate?.showAndHidePlayers(false)
        case 2: // stop
            delegate?.cellPause()
            playButtonImage.image = HomeConstants.HomeImage.miniPlay
            delegate?.showAndHidePlayers(true)
            tapButton = 0
        default:
            break
        }
    }
    private func setupeConstraint() {
        conteinerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(0)
            make.width.equalToSuperview().inset(0)
            make.height.equalTo(80)
        }
        playerPlayButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.height.equalTo(50)
        }
        playButtonImage.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(27)
        }
        nameTitle.snp.makeConstraints { make in
            make.top.equalTo(playerPlayButton.snp.top)
            make.left.equalTo(playerPlayButton.snp.right).inset(-10)
            make.height.equalTo(20)
            make.right.equalTo(-20)
        }
        timeTitle.snp.makeConstraints { make in
            make.bottom.equalTo(playerPlayButton.snp.bottom)
            make.left.equalTo(playerPlayButton.snp.right).inset(-10)
            make.height.equalTo(17)
            make.width.lessThanOrEqualTo(70)
        }
        separatorView.snp.makeConstraints { make in
            make.centerY.equalTo(timeTitle.snp.centerY)
            make.left.equalTo(timeTitle.snp.right).inset(-5)
            make.width.equalTo(1)
            make.height.equalTo(13)
        }
        descriptionTitle.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.left.equalTo(separatorView.snp.right).inset(-5)
            make.height.equalTo(17)
            make.bottom.equalTo(playerPlayButton.snp.bottom)
        }
        selectImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(31)
            make.left.equalTo(conteinerView.snp.right).inset(-10)
        }
    }
}
