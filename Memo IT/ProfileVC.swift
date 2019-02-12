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
    let segGender = UISegmentedControl()
    let switchMartial = UISwitch()
    
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
        
        self.tv.frame = CGRect(x: 0, y: self.imgProfile.frame.origin.y + self.imgProfile.frame.height + 20, width: self.view.frame.width, height: 500)
        self.tv.delegate = self
        self.tv.dataSource = self
        self.view.addSubview(tv)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let plist = UserDefaults.standard
        if let lblName = self.tv.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel {
            lblName.text = plist.string(forKey: "name")
        }
        
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
//        cell.accessoryType = .disclosureIndicator
        
        let cellDefault = UITableViewCell(style: .default, reuseIdentifier: "cellDefault")
        cellDefault.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = "hKim"
            
            return cell
        case 1:
            cell.textLabel?.text = "Email"
            cell.detailTextLabel?.text = "hkim199105@gmail.com"
            
            return cell
        case 2:
            cellDefault.textLabel?.text = "Gender"
            
            // warning!! contentView's width would not be determined now.
            // Its default value is 320.
            // It is determined right before the cell inserts to the table.
            //
            // solution!! UITableView calls layoutSubviews, so use the listener method "viewDidLayoutSubviews()"
            let segWidth:CGFloat = CGFloat(200)
            segGender.frame = CGRect(x: self.view.frame.width - segWidth - 8, y: 8, width: segWidth, height: cellDefault.contentView.bounds.height - 16)
            segGender.insertSegment(withTitle: "Male", at: 0, animated: false)
            segGender.insertSegment(withTitle: "Neutral", at: 1, animated: false)
            segGender.insertSegment(withTitle: "Female", at: 2, animated: false)
            segGender.addTarget(self, action: #selector(changeGender(_:)), for: .valueChanged)
            cellDefault.addSubview(segGender)
            
            return cellDefault
            
        case 3:
            cellDefault.textLabel?.text = "Martial Status"
            
            let switchWidth:CGFloat = CGFloat(50)
            switchMartial.frame = CGRect(x: self.view.frame.width - switchWidth - 8, y: 8, width: switchWidth, height: cellDefault.contentView.bounds.height - 16)
            switchMartial.addTarget(self, action: #selector(changeMartial(_:)), for: .valueChanged)
            cellDefault.addSubview(switchMartial)
            
            return cellDefault
            
        default:
            ()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let alert = UIAlertController(title: nil, message: "Your name, please.", preferredStyle: .alert)
            alert.addTextField() {
                if let tmpName = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text {
                    $0.text = tmpName
                }
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                let value = alert.textFields?[0].text
                let plist = UserDefaults.standard
                plist.set(value, forKey: "name")
                plist.synchronize()
                if let labelName = tableView.cellForRow(at: indexPath)?.detailTextLabel {
                    labelName.text = value
                }
            })
            self.present(alert, animated: true, completion: nil)
            
        default:
            ()
        }
    }
    
    @objc func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex
        let plist = UserDefaults.standard
        plist.set(value, forKey: "gender")
        plist.synchronize()
    }
    
    @objc func changeMartial(_ sender: UISwitch) {
        let value = sender.isOn
        let plist = UserDefaults.standard
        plist.set(value, forKey: "martial")
        plist.synchronize()
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
