//
//  SideMenuVC.swift
//  MyMemory
//
//  Created by hkim on 2019. 2. 3..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

class SideMenuVC: UITableViewController {
    let titles = [
        "New Memo",
        "Friend's Memo",
        "Calendar",
        "Notice",
        "Statistics",
        "My Account"
    ]
    
    let icons = [
        UIImage(named: "icoMenu01"),
        UIImage(named: "icoMenu02"),
        UIImage(named: "icoMenu03"),
        UIImage(named: "icoMenu04"),
        UIImage(named: "icoMenu05"),
        UIImage(named: "icoMenu05")
    ]
    
    let lblName = UILabel()
    let lblEmail = UILabel()
    let imgProfile = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewHeader = UIView()
        viewHeader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70)
        viewHeader.backgroundColor = UIColor.brown
        self.tableView.tableHeaderView = viewHeader
        
        self.lblName.text = "hkim"
        self.lblName.frame = CGRect(x: 70, y: 15, width: 100, height: 30)
        self.lblName.textColor = UIColor.white
        self.lblName.font = UIFont.boldSystemFont(ofSize: 15)
        self.lblName.backgroundColor = UIColor.clear
        self.lblName.sizeToFit()
        viewHeader.addSubview(self.lblName)
        
        self.lblEmail.text = "hkim199105@gmail.com"
        self.lblEmail.frame = CGRect(x: 70, y: 30, width: 100, height: 30)
        self.lblEmail.textColor = UIColor.white
        self.lblEmail.font = UIFont.systemFont(ofSize: 11)
        self.lblEmail.backgroundColor = UIColor.clear
        self.lblEmail.sizeToFit()
        viewHeader.addSubview(self.lblEmail)
        
        self.imgProfile.image = UIImage(named: "imgProfile.jpg")
        self.imgProfile.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.width / 2
        self.imgProfile.layer.borderWidth = 0
        self.imgProfile.layer.masksToBounds = true
        viewHeader.addSubview(self.imgProfile)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "cellMenu"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {     // new memo
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "MemoVC")
            if let parent = self.parent as? HKRevealViewController {
                let target = parent.contentVC as! UINavigationController
                target.pushViewController(uv!, animated: true)
                parent.closeSideBar(nil)
            }
        } else if indexPath.row == 5 {   // my account
            let uv = self.storyboard?.instantiateViewController(withIdentifier: "_ProfileVC")
            self.present(uv!, animated: true){
                if let parent = self.parent as? HKRevealViewController {
                    parent.closeSideBar(nil)
                }
            }
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
