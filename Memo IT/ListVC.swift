//
//  ListVC.swift
//  MyMemory
//
//  Created by Administrator on 2019. 1. 15..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

class ListVC: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var delegate: HKRevealViewController?
    
//    @IBOutlet var btnMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // replace external library with self-made library
//        if let revealVC = self.revealViewController() {
//            self.btnMenu.target = revealVC
//            self.btnMenu.action = #selector(revealVC.revealToggle(_:))
//            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
//        }
        
        let btnMenu = UIBarButtonItem(image: UIImage(named: "icoMenu"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(openMenu(_:)))
        self.navigationItem.leftBarButtonItem = btnMenu
        
        let dragLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(openMenu(_:)))
        dragLeft.edges = UIRectEdge.left
        self.view.addGestureRecognizer(dragLeft)
        
        let dragRight = UISwipeGestureRecognizer(target: self, action: #selector(openMenu(_:)))
        dragRight.direction = .left
        self.view.addGestureRecognizer(dragRight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let memoCount = self.appDelegate.memoList.count
        
        return memoCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mRow = self.appDelegate.memoList[indexPath.row]
        let mCellId = mRow.image == nil ? "memoCell" : "memoCellWithImage"
        let mCell = tableView.dequeueReusableCell(withIdentifier: mCellId) as! ListCell
        mCell.contentL?.text = mRow.contents
        mCell.titleL?.text = mRow.title
        mCell.contentIV?.image = mRow.image
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        mCell.dateL?.text = formatter.string(from: mRow.edtDate!)

        return mCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mRow = self.appDelegate.memoList[indexPath.row]
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? ReadVC else {
            return
        }
        
        vc.param = mRow
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openMenu(_ sender:Any) {
        if sender is UIScreenEdgePanGestureRecognizer {
            self.delegate?.openSideBar(nil)
        } else if sender is UISwipeGestureRecognizer {
            self.delegate?.closeSideBar(nil)
        } else if self.delegate?.isMenuShowing == false {
            self.delegate?.openSideBar(nil)
        } else {
            self.delegate?.closeSideBar(nil)
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
