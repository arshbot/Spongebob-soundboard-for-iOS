//
//  SpongeModel.swift
//  SpongeBoard
//
//  Created by Dylan Welch on 4/5/18.
//  Copyright © 2018 Dylan Welch. All rights reserved.
//

import UIKit

class SpongeModel: NSObject {
    
    var quoteName: String
    var picture: UIImage
    var soundFile: String
    
    init(_ name: String, pic: UIImage, sound: String) {
        quoteName = name
        picture = pic
        soundFile = sound
    }
    
}
