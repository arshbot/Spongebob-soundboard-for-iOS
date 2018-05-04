//
//  SpongeCell.swift
//  SpongeBoard
//
//  Created by Dylan Welch on 4/5/18.
//  Copyright © 2018 Dylan Welch. All rights reserved.
//

import UIKit
import AVFoundation

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
}

class SpongeCell: BaseCell, AVAudioSessionDelegate {
    
    var spongeModel: SpongeModel? {
        didSet {
            guard let model = spongeModel else { return }
            setupCell(model: model)
        }
    }
    
    var player: AVAudioPlayer?
    var isPlaying:Bool = false

    var timer: Timer?
    
    var currentSoundLength:Double = 0
    var soundLength:Double = 0
    
    func setupCell (model: SpongeModel) {
        DispatchQueue.main.async {
            self.quoteLabel.text = model.quoteName
            self.characterImageView.image = model.picture
        }
    }
    
    @objc func handleTap() {

        guard let model = spongeModel else { return }
        startStopAudioPlayer(model)
    }
    
    @objc func updateProgress() {
        
        if let isPlaying = player?.isPlaying{
            if !isPlaying{
                timer?.invalidate()
                DispatchQueue.main.async {
                    self.progressView.setProgress(1, animated: true)
                    if self.currentSoundLength == 0 {
                        self.progressView.isHidden = true
                    } else {
                        self.progressView.isHidden = false
                    }
                }
            }
        }
        
    
        if let currentLength = player?.currentTime, let duration = player?.duration {
            currentSoundLength = currentLength
            soundLength = duration
            print(currentLength, soundLength)
  
        }
        
        let progress = Float(currentSoundLength/soundLength)
        
        DispatchQueue.main.async {
            self.progressView.setProgress(progress, animated: true)
        }
    }
    
    var progressView: UIProgressView = {
        let pv = UIProgressView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.progressTintColor = .blue
        pv.progress = 0
        return pv
    }()
    
    lazy var characterImageView: UIImageView = {
        [weak self] in
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 40
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        return imageView
    }()
    
    let quoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func setupViews() {
        
        backgroundColor = .white
        layer.cornerRadius = 5
        
        addSubview(characterImageView)
        characterImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        characterImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        characterImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        characterImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
    
        addSubview(quoteLabel)
        quoteLabel.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16).isActive = true
        quoteLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        quoteLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2).isActive = true
        quoteLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    
        addSubview(progressView)
        self.progressView.isHidden = true
        progressView.leftAnchor.constraint(equalTo: characterImageView.rightAnchor, constant: 16).isActive = true
        progressView.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 25).isActive = true
        progressView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
    }
    
    // MARK: Play Sound
    func playSound(_ model: SpongeModel) {
        guard let url = Bundle.main.url(forResource: model.soundFile, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Toggle Sound
    func startStopAudioPlayer(_ model: SpongeModel){
        if isPlaying {
            player?.stop()
            isPlaying = false
            progressView.isHidden = true
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
            playSound(model)
            isPlaying = true
            progressView.isHidden = false
  
//        } else {
//            progressView.isHidden = false
//        }
        }
        
    }
    
    
    
}
