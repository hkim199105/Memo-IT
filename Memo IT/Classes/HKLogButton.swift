//
//  HKLogButton.swift
//  MyMemory
//
//  Created by hkim on 2019. 2. 3..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

public enum HKLogType: Int {
    case basic
    case title
    case tag
}

@IBDesignable
public class HKLogButton: UIButton {
    public var logType: HKLogType = .basic {
        didSet {
            
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setBackgroundImage(UIImage(named: "btnGreen"), for: .normal)
        self.tintColor = UIColor.white
        self.addTarget(self, action: #selector(logging(_:)), for: .touchUpInside)
    }
    
    @objc func logging(_ sender:UIButton) {
        switch self.logType {
        case .basic:
            NSLog("The Button is clicked.")
        case .title:
            let btnTitle = sender.titleLabel?.text ?? "untitled"
            NSLog("\(btnTitle) button is clicked.")
        case .tag:
            NSLog("\(sender.tag) button is clicked.")
        }
    }

}
