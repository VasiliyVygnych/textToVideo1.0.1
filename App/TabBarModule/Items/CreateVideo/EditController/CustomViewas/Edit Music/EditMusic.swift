//
//  EditMusic.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 14.11.2024.
//

import UIKit
import SnapKit
import MediaPlayer
import AVFoundation

class EditMusic: UIView {
    
    var viewModel: HomeViewModelProtocol?
    private let tableIdentifier = "songs"
    private var selectIndexPath: IndexPath?
    private var selectMusicIndexPath: IndexPath?
    private var player: AVPlayer?
    private var playerItems: AVPlayerItem?
    private var isPlaySoungCell = true
    private var songDefault = false
    private var timeObserver: Any?
    
    private var editorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var musicView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var playButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var defaultNameMusic: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
        return view
    }()
    private var defaultTitleMusic: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .semibold)
        view.textAlignment = .left
        return view
    }()
    
    
    
    
    
    private var searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    private var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 0.5
        return view
    }()
    private var searchImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    private var searchTextField: UITextField = {
       let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .semibold)
        view.textColor = .white
        view.textAlignment = .left
        view.keyboardType = .default
        return view
    }()
    private var placeholderSearch: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 14,
                                weight: .medium)
        view.textAlignment = .left
        return view
    }()
    
    private var premiumButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        return view
    }()
    private var premiumTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 16,
                                weight: .regular)
        view.textAlignment = .left
        view.textColor = .white
        return view
    }()
    private var premiumImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorColor = .clear
        view.backgroundColor = HomeConstants.HomeColor.backgroundColor
        return view
    }()
    
    
    private var musicPlayerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var playerPlayButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    private var playButtonImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private var nameMusic: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15,
                                weight: .bold)
        view.textAlignment = .left
        view.textColor = .white
        return view
    }()
    private var timeTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 13,
                                weight: .regular)
        view.textAlignment = .right
        return view
    }()
    private let progressBar: UISlider = {
        let view = UISlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumTrackTintColor = .white
        return view
    }()
    
    private var downView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        addSubview()
        setupTableView()
        setupeColor()
        setupeData()
        setupeText()
        setupeAction()
        setupeConstraints()
        
        if let url = UserDefaults.standard.url(forKey: "musicURL") {
            setMusic(url)
        }
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    func setupeSongTime() {
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1,
                                                                           preferredTimescale: 1),
                                                       queue: DispatchQueue.main,
                                                       using: { time in
            if let duration = self.player?.currentItem?.duration.seconds {
                let timer = duration - time.seconds
                self.setTimeTitle(timer)
                if timer <= 0.0 {
                    self.stopPlayback()
                }
                self.progressBar.value = Float(time.seconds)
                self.progressBar.maximumValue = Float(duration)
            }
        })
    }
    func setTimeTitle(_ second: Double?) {
        if let seconds = second {
            if seconds.isFinite && !seconds.isNaN {
                let intSecond = Int(seconds)
                let minutes = intSecond / 60
                let remainingSeconds = intSecond % 60
                timeTitle.text = String(format: "%d:%02d",
                                        minutes,
                                        remainingSeconds)
            }
        }
    }
    
    private func changeMusic(_ url: URL) {
        playerItems = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: playerItems)
    }
    
    private func setMusic(_ url: URL) {
        playerItems = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItems)
        setupeSongTime()
    }
    private func startPlayback() {
        player?.play()
    }
    private func pausePlayback() {
        player?.pause()
    }
    deinit {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    private func stopPlayback() {
        if songDefault {
            playButton.tag = 0
            playButton.setBackgroundImage(HomeConstants.HomeImage.miniPlay,
                                          for: .normal)
            playButtonImage.image = HomeConstants.HomeImage.miniPlay
        } else {
            playerPlayButton.tag = 0
            playButtonImage.image = HomeConstants.HomeImage.miniPlay
            selectIndexPath = nil
            tableView.reloadData()
        }
    }
    
    
    
    
    private func setupTableView() {
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SongsCell.self,
                           forCellReuseIdentifier: tableIdentifier)
    }
    func setupeText() {
        placeholderSearch.text = "Search for stock music"
        premiumTitle.text = "Include Premium Music"
        
        
        nameMusic.text = "test test test"
        defaultNameMusic.text = "test test"
        defaultTitleMusic.text = "test test test"
        timeTitle.text = "0:00"
    }
    private func setupeColor() {
        editorView.backgroundColor = UIColor(named: "customGrayColor56")
        
        searchView.backgroundColor = HomeConstants.HomeColor.customGrayColor
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = HomeConstants.HomeColor.customGrayC4?.cgColor
        separatorView.backgroundColor = HomeConstants.HomeColor.customGrayC4
        placeholderSearch.textColor = HomeConstants.HomeColor.customGrayC4
        
        premiumButton.backgroundColor = HomeConstants.HomeColor.editButtoncolor
        
        musicView.backgroundColor = UIColor(named: "customGrayColor100")
        musicView.layer.borderWidth = 2
        musicView.layer.borderColor = HomeConstants.HomeColor.customBlueColor?.cgColor
        
        
        
        musicPlayerView.backgroundColor = UIColor(named: "customGrayColor100")
        playerPlayButton.backgroundColor = HomeConstants.HomeColor.editButtoncolor
        
        
        defaultTitleMusic.textColor = .lightGray
        
        timeTitle.textColor = .lightGray
        
        
        
        downView.backgroundColor = UIColor(named: "customGrayColor100")
    }
    private func setupeData() {
        searchImage.image = HomeConstants.HomeImage.searchImage
        premiumImage.image = HomeConstants.HomeImage.premiumImage
        playButton.setBackgroundImage(HomeConstants.HomeImage.miniPlay,
                                      for: .normal)
        progressBar.setThumbImage(HomeConstants.HomeImage.sliderMusik,
                                  for: .normal)
    }
    private func setupeAction() {
        premiumButton.addTarget(self,
                                action: #selector(shoisePremium),
                                for: .touchUpInside)
        playButton.addTarget(self,
                             action: #selector(playMusic),
                             for: .touchUpInside)
        playerPlayButton.addTarget(self,
                                   action: #selector(musicPlayer),
                                   for: .touchUpInside)
        progressBar.addTarget(self,
                              action: #selector(valueChanged),
                              for: .valueChanged)
    }
    @objc func valueChanged(sender: UISlider) {
        player?.seek(to: CMTime(seconds: Double(progressBar.value),
                                preferredTimescale: 1000))
    }
    @objc func shoisePremium(_ sender: UIButton) {
        sender.tag += 1
        switch sender.tag {
            case 1:
            premiumButton.setBackgroundImage(HomeConstants.HomeImage.selectButton,
                                             for: .normal)
        case 2:
            premiumButton.setBackgroundImage(nil,
                                             for: .normal)
            sender.tag = 0
        default:
            break
        }
    }
    @objc func playMusic(_ sender: UIButton) {
        isPlaySoungCell = false
        tableView.reloadData()
        sender.tag += 1
        switch sender.tag {
            case 1:
            startPlayback()
            songDefault = true
            musicPlayerView.isHidden = false
            playerPlayButton.tag = 1
            playButtonImage.image = HomeConstants.HomeImage.stopButton
            playButton.setBackgroundImage(HomeConstants.HomeImage.stopButton,
                                          for: .normal)
        case 2:
            playerPlayButton.tag = 0
            playButtonImage.image = HomeConstants.HomeImage.miniPlay
            playButton.setBackgroundImage(HomeConstants.HomeImage.miniPlay,
                                          for: .normal)
            songDefault = false
            sender.tag = 0
            pausePlayback()
        default:
            break
        }
    }
    @objc func musicPlayer(_ sender: UIButton) {
        sender.tag += 1
        switch sender.tag {
            case 1:
            if songDefault {
                playButton.tag = 1
                playButton.setBackgroundImage(HomeConstants.HomeImage.stopButton,
                                              for: .normal)
            } else {
                isPlaySoungCell = true
            }
            if isPlaySoungCell {
                isPlaySoungCell = true
                tableView.reloadData()
            }
            playButtonImage.image = HomeConstants.HomeImage.stopButton
            player?.play()
        case 2:
            if songDefault {
                playButton.tag = 0
                playButton.setBackgroundImage(HomeConstants.HomeImage.miniPlay,
                                              for: .normal)
            }
            if isPlaySoungCell {
                isPlaySoungCell = false
                tableView.reloadData()
            }
            playButtonImage.image = HomeConstants.HomeImage.miniPlay
            pausePlayback()
            sender.tag = 0
        default:
            break
        }
    }
    private func addSubview() {
        addSubview(editorView)
        editorView.addSubview(musicView)
        musicView.addSubview(playButton)
        musicView.addSubview(defaultNameMusic)
        musicView.addSubview(defaultTitleMusic)
        
        addSubview(searchView)
        searchView.addSubview(searchImage)
        searchView.addSubview(separatorView)
        searchView.addSubview(searchTextField)
        searchTextField.delegate = self
        searchView.addSubview(placeholderSearch)
        
        addSubview(premiumButton)
        addSubview(premiumTitle)
        addSubview(premiumImage)
        
        addSubview(tableView)
        
        addSubview(musicPlayerView)
        musicPlayerView.isHidden = true
        musicPlayerView.addSubview(playerPlayButton)
        playerPlayButton.addSubview(playButtonImage)
        musicPlayerView.addSubview(nameMusic)
        musicPlayerView.addSubview(progressBar)
        musicPlayerView.addSubview(timeTitle)
        
        addSubview(downView)
    }
    private func setupeConstraints() {
        editorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(153)
        }
        
        musicView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.equalTo(213)
            make.height.equalToSuperview().inset(25)
        }
        playButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.right.equalTo(-5)
            make.width.height.equalTo(24)
        }
        defaultNameMusic.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.right.equalTo(playButton.snp.left).inset(-5)
            make.height.equalTo(17)
        }
        defaultTitleMusic.snp.makeConstraints { make in
            make.top.equalTo(defaultNameMusic.snp.bottom).offset(10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(17)
        }
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(editorView.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(53)
        }
        separatorView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.left.equalTo(searchImage.snp.left).inset(-15)
        }
        searchImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.width.height.equalTo(20)
        }
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(separatorView.snp.left).inset(-5)
        }
        placeholderSearch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(separatorView.snp.left).inset(-5)
        }
        
        premiumButton.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.width.height.equalTo(27)
        }
        premiumTitle.snp.makeConstraints { make in
            make.centerY.equalTo(premiumButton.snp.centerY)
            make.left.equalTo(premiumButton.snp.right).inset(-10)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(60)
        }
        premiumImage.snp.makeConstraints { make in
            make.centerY.equalTo(premiumButton.snp.centerY)
            make.left.equalTo(premiumTitle.snp.right).inset(-10)
            make.height.width.equalTo(19)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(premiumButton.snp.bottom).offset(15)
            make.width.equalToSuperview()
            make.bottom.equalTo(downView.snp.top).inset(0)
        }
        
        musicPlayerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(80)
            make.bottom.equalTo(downView.snp.top)
        }
        playerPlayButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.height.equalTo(50)
        }
        playButtonImage.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(29)
        }
        nameMusic.snp.makeConstraints { make in
            make.top.equalTo(playerPlayButton.snp.top)
            make.height.equalTo(20)
            make.left.equalTo(playerPlayButton.snp.right).inset(-15)
            make.right.equalTo(-15)
        }
        progressBar.snp.makeConstraints { make in
            make.bottom.equalTo(playerPlayButton.snp.bottom)
            make.height.equalTo(10)
            make.left.equalTo(playerPlayButton.snp.right).inset(-15)
            make.right.equalTo(timeTitle.snp.left).inset(-5)
        }
        timeTitle.snp.makeConstraints { make in
            make.centerY.equalTo(progressBar.snp.centerY)
            make.right.equalTo(-20)
            make.height.equalTo(17)
            make.width.equalTo(30)
        }
        
        downView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(120)
        }
    }
}
extension EditMusic: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField,
                  shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range,
                                                               with: string)
        if textField == searchTextField {
            searchTextField.text = newString
            if newString.isEmpty {
                placeholderSearch.isHidden = false
            } else {
                placeholderSearch.isHidden = true
            }
        }
       return false
    }
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        endEditing(true)
    }
}
extension EditMusic: UITableViewDataSource,
                        UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        5
    }
    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier,
                                                      for: indexPath) as? SongsCell else { return UITableViewCell() }
        cell.configuration()
        cell.playerPlayButton.tag = indexPath.row
        cell.delegate = self
        
        if selectIndexPath == indexPath {
            if isPlaySoungCell == true {
                cell.tapButton = 1
                cell.playButtonImage.image = HomeConstants.HomeImage.stopButton
            } else {
                cell.tapButton = 0
                cell.playButtonImage.image = HomeConstants.HomeImage.miniPlay
            }
        } else {
            cell.tapButton = 0
            cell.playButtonImage.image = HomeConstants.HomeImage.miniPlay
        }
        if selectMusicIndexPath == indexPath {
            cell.select()
        } else {
            cell.deselect()
        }
        return cell
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPath = selectMusicIndexPath {
            if selectedIndexPath == indexPath {
                self.selectMusicIndexPath = nil
            } else {
                self.selectMusicIndexPath = indexPath
            }
        } else {
            self.selectMusicIndexPath = indexPath
        }
        tableView.reloadData()
    }
}
extension EditMusic: SongViewDelegate {
    func showAndHidePlayers(_ bool: Bool) {
        isPlaySoungCell = true
        songDefault = false
        playButtonImage.image = HomeConstants.HomeImage.stopButton
        playerPlayButton.tag = 1
        musicPlayerView.isHidden = bool
    }
    func setIndexPath(_ indexPath: IndexPath) {
        playButton.tag = 0
        playButton.setBackgroundImage(HomeConstants.HomeImage.miniPlay,
                                      for: .normal)
        selectIndexPath = indexPath
        tableView.reloadData()
    }
    func cellStart() {
        if let url = UserDefaults.standard.url(forKey: "musicURL") {
            changeMusic(url)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.startPlayback()
        }
    }
    func cellPause() {
        pausePlayback()
    }
}
