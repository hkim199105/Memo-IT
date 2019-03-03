//
//  TutorialContentVC.swift
//  MyMemory
//
//  Created by hkim on 2019. 3. 3..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

class TutorialContentVC: UIViewController {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgMain: UIImageView!
    
    var pageIndex: Int!
    var titleText: String!
    var imgName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = self.titleText
        self.lblTitle.sizeToFit()
        self.imgMain.image = UIImage(named: imgName)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
