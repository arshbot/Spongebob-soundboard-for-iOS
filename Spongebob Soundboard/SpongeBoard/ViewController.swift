//
//  ViewController.swift
//  SpongeBoard
//
//  Created by Dylan Welch on 4/5/18.
//  Copyright © 2018 Dylan Welch. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var objects = [SpongeModel("I'm ready", pic: #imageLiteral(resourceName: "sponge-imready"), sound: "Im ready"), SpongeModel("All in the technique", pic: #imageLiteral(resourceName: "sponge-technique"), sound: "All in the technique"), SpongeModel("Ripped my pants", pic: #imageLiteral(resourceName: "sponge-rip"), sound: "Ripped my pants")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavbar()
        setupView()
        setupCollectionView()
    }
    
    func setupNavbar () {
        self.navigationItem.title = "SpongeBoard"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "AmericanTypewriter-Bold", size: 24)!,NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red:1.00, green:0.91, blue:0.20, alpha:1.00)
        let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-menu"), style: .plain, target: self, action: #selector(menuButtonTapped))
        menuButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    @objc func menuButtonTapped () {
        print("menuButtonTapped")
        
    }
    
    func setupView () {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupCollectionView () {
        collectionView.register(SpongeCell.self, forCellWithReuseIdentifier: "cellID")
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        var cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsetsMake(6, 0, 6, 0)
        cv.backgroundColor = .brown
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true 
        return cv
    }()

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! SpongeCell
        cell.spongeModel = objects[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 16, height: 100)
    }
}
