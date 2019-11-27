//
//  PlayerOverlay.swift
//  vidStream
//
//  Created by Anupriya HEY on 27/11/2019.
//  Copyright © 2019 Anupriya Soman. All rights reserved.
//

import UIKit

class PlayerOverlay: UIView {

 @IBOutlet weak var listButton: UIButton!
    
    class func getScreen() -> PlayerOverlay {
        let xib = Bundle.main.loadNibNamed(String(describing :self), owner: self, options: nil)
        let screen = xib![0] as! PlayerOverlay
        return screen
    }
    
}
