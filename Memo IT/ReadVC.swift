//
//  ReadVC.swift
//  MyMemory
//
//  Created by Administrator on 2019. 1. 15..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

class ReadVC: UIViewController {
    @IBOutlet var titleL: UILabel!
    @IBOutlet var contentL: UILabel!
    @IBOutlet var contentIV: UIImageView!
    var param: MemoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleL.text = param?.title
        self.contentL.text = param?.contents
        self.contentIV.image = param?.image
        let formatter = DateFormatter()
        formatter.dateFormat = "dd일 HH:mm분에 작성/수정됨"
        let mDateString = formatter.string(from: (param?.edtDate)!)
        self.navigationItem.title = mDateString
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
