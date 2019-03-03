//
//  Util.swift
//  MyMemory
//
//  Created by hkim on 2019. 3. 3..
//  Copyright © 2019년 hkim. All rights reserved.
//

import Foundation

extension UIViewController {
    var sbTutorial: UIStoryboard {
        return UIStoryboard(name: "Tutorial", bundle: Bundle.main)
    }
    func instanceSbTutorial(name: String) -> UIViewController? {
        return self.sbTutorial.instantiateInitialViewController(withIdentifier: name)
    }
}
