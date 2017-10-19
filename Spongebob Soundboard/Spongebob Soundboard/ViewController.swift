//
//  ViewController.swift
//  Spongebob Soundboard
//
//  Created by Harsha Goli on 10/19/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import UIKit
import AVFoundation
var audioPlayer:AVAudioPlayer!

class ViewController: UIViewController {
    @IBAction func playButton(_ sender: Any) {
        print("Playing!")
        //playSound()
        if  audioPlayer.isPlaying{
            audioPlayer.pause()
        }else{
            audioPlayer.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Getting the file from local storage
        downloadTheShits()
//        let url = Bundle.main.url(forResource: "iPhone_5-Alarm", withExtension: "mp3")!
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            guard let player = audioPlayer else { return }
//
//            player.prepareToPlay()
//        } catch let error {
//            print(error.localizedDescription)
//        }
    }
    
    func downloadTheShits(){
        if let audioUrl = URL(string: "http://freetone.org/ring/stan/iPhone_5-Alarm.mp3") {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                let url = try! FileManager.default
                    .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("iPhone_5-Alarm")
                    .appendingPathExtension("mp3")
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    guard let player = audioPlayer else { return }
                    
                    player.prepareToPlay()
                } catch let error {
                    print(error.localizedDescription)
                }
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                        //let url = Bundle.main.url(forResource: "iPhone_5-Alarm", withExtension: "mp3")!
                        let url = try! FileManager.default
                            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                            .appendingPathComponent("iPhone_5-Alarm")
                            .appendingPathExtension("mp3")
                        do {
                            audioPlayer = try AVAudioPlayer(contentsOf: url)
                            guard let player = audioPlayer else { return }
                            
                            player.prepareToPlay()
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
            }
            
        }
        }
        
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class PlayButton: UIButton {
    var player: AVAudioPlayer?

    @IBAction func play(_ sender: Any) {
        
    }

    func playSound() {
        guard let url = Bundle.main.url(forResource: "Spongebob Laugh!", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)

            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}

