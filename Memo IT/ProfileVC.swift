//
//  ProfileVC.swift
//  MyMemory
//
//  Created by hkim on 2019. 2. 5..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let imgProfile = UIImageView()
    let tv = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let btnBack = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close(_:)))
        self.navigationItem.leftBarButtonItem = btnBack
        self.navigationItem.title = "My Account"
        self.navigationController?.navigationBar.isHidden = true
        
        let imgBg = UIImageView(image: UIImage(named: "imgPen"))
        imgBg.frame.size = CGSize(width: imgBg.frame.size.width, height: imgBg.frame.size.height)
        imgBg.center = CGPoint(x: self.view.frame.width / 2, y: 40)
        imgBg.layer.cornerRadius = imgBg.frame.size.width / 2
        imgBg.layer.borderWidth = 0
        imgBg.layer.masksToBounds = true
        self.view.addSubview(imgBg)
        
        self.imgProfile.image = UIImage(named: "imgProfile.jpg")
        self.imgProfile.frame.size = CGSize(width: 100, height: 100)
        self.imgProfile.center = CGPoint(x: self.view.frame.width / 2, y: 270)
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.width / 2
        self.imgProfile.layer.borderWidth = 0
        self.imgProfile.layer.masksToBounds = true
        self.view.addSubview(self.imgProfile)
        
        self.tv.frame = CGRect(x: 0, y: self.imgProfile.frame.origin.y + self.imgProfile.frame.height + 20, width: self.view.frame.width, height: 100)
        self.tv.delegate = self
        self.tv.dataSource = self
        self.view.addSubview(tv)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = "hKim"
        case 1:
            cell.textLabel?.text = "Email"
            cell.detailTextLabel?.text = "hkim199105@gmail.com"
        default:
            ()
        }
        
        return cell
    }
    
    @objc func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
