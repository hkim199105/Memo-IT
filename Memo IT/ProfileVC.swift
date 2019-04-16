//
//  ProfileVC.swift
//  MyMemory
//
//  Created by hkim on 2019. 2. 5..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imgProfile = UIImageView()
    let tv = UITableView()
    
    // elements in tv
    let tfName = UITextField()
    let tfAccount = UITextField()
    let pickerAccount = UIPickerView()
    let segGender = UISegmentedControl()
    let switchMartial = UISwitch()
    let defaultMartial = false
    let defaultGender = 0   //0: male, 1:neutral, 2:female
    
    // data
    var accountsSaved = [String]()
    var defaultPList : NSDictionary!
    
    let mUserInfoManager = UserInfoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // draw UI
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
        
//        self.imgProfile.image = UIImage(named: "imgProfile.jpg")
        self.imgProfile.image = self.mUserInfoManager.profile
        self.imgProfile.frame.size = CGSize(width: 100, height: 100)
        self.imgProfile.center = CGPoint(x: self.view.frame.width / 2, y: 270)
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.width / 2
        self.imgProfile.layer.borderWidth = 0
        self.imgProfile.layer.masksToBounds = true
        self.view.addSubview(self.imgProfile)
        
        let tabProfile = UITapGestureRecognizer(target: self, action: #selector(profile(_:)))
        self.imgProfile.addGestureRecognizer(tabProfile)
        self.imgProfile.isUserInteractionEnabled = true
        
        self.tv.frame = CGRect(x: 0, y: self.imgProfile.frame.origin.y + self.imgProfile.frame.height + 20, width: self.view.frame.width, height: 200)
        self.tv.delegate = self
        self.tv.dataSource = self
        self.view.addSubview(tv)
        
        self.tfAccount.delegate = self
        self.tfAccount.inputView = pickerAccount
        self.pickerAccount.delegate = self
        self.tfName.isEnabled = false
        
        let toolbarAccount = UIToolbar()
        toolbarAccount.frame = CGRect(x: 0, y: 0, width: 0, height: 35)     //x, y, width is rendered when shown up, so do not care now.
        toolbarAccount.tintColor = UIColor.lightGray
        self.tfAccount.inputAccessoryView = toolbarAccount
        
        let btnNewAccount = UIBarButtonItem()
        btnNewAccount.title = NSLocalizedString("Add", comment: "")
        btnNewAccount.target = self
        btnNewAccount.action = #selector(addAccount)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btnSelectAccount = UIBarButtonItem()
        btnSelectAccount.title = "Done"
        btnSelectAccount.target = self
        btnSelectAccount.action = #selector(selectAccount)
        toolbarAccount.setItems([btnNewAccount, flexSpace, btnSelectAccount], animated: true)
        
        self.drawBtnSign()
        
        // set UserDefaults
        let plist = UserDefaults.standard
        self.accountsSaved = plist.array(forKey: "accountsSaved") as? [String] ?? [String]()
        if let mAccount = plist.string(forKey: "accountSelected") {
            self.tfAccount.text = mAccount
            
            let customPlist = "\(mAccount).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: clist)
            
            self.tfName.text = data?["name"] as? String
            self.segGender.selectedSegmentIndex = data?["gender"] as? Int ?? self.defaultGender
            self.switchMartial.isOn = data?["married"] as? Bool ?? self.defaultMartial

        } else {
            self.tfAccount.placeholder = "No Signed Account"
            self.segGender.isEnabled = false
            self.switchMartial.isEnabled = false
        }
        
        if let defaultPListPath = Bundle.main.path(forResource: "UserTemplate", ofType: "plist") {
            self.defaultPList = NSDictionary(contentsOfFile: defaultPListPath)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let plist = UserDefaults.standard
        if let lblName = self.tv.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel {
            lblName.text = plist.string(forKey: "name")
        }
        self.segGender.selectedSegmentIndex = plist.integer(forKey: "gender")
        self.switchMartial.isOn = plist.bool(forKey: "martial")
        
        super.viewDidAppear(animated)
    }
    
    // MARK: - methods for UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDefault = UITableViewCell(style: .default, reuseIdentifier: "cellDefault")
        cellDefault.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        switch indexPath.row {
        case 0:
            cellDefault.textLabel?.text = "Name"
            
            let tfWidth:CGFloat = CGFloat(200)
            tfName.frame = CGRect(x: self.view.frame.width - tfWidth - 8, y: 8, width: tfWidth, height: cellDefault.contentView.bounds.height - 16)
            tfName.borderStyle = .none
            tfName.textAlignment = .right
            tfName.text = self.mUserInfoManager.name ?? "Sign In, Please."
            cellDefault.addSubview(tfName)
            
        case 1:
            cellDefault.textLabel?.text = "Email"
            
            let tfWidth:CGFloat = CGFloat(200)
            tfAccount.frame = CGRect(x: self.view.frame.width - tfWidth - 8, y: 8, width: tfWidth, height: cellDefault.contentView.bounds.height - 16)
            tfAccount.borderStyle = .none
            tfAccount.textAlignment = .right
            tfAccount.text = self.mUserInfoManager.account ?? "Sign In, Please."
            cellDefault.addSubview(tfAccount)
            
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
            
        case 3:
            cellDefault.textLabel?.text = "Martial Status"
            
            let switchWidth:CGFloat = CGFloat(50)
            switchMartial.frame = CGRect(x: self.view.frame.width - switchWidth - 8, y: 8, width: switchWidth, height: cellDefault.contentView.bounds.height - 16)
            switchMartial.addTarget(self, action: #selector(changeMartial(_:)), for: .valueChanged)
            cellDefault.addSubview(switchMartial)
            
        default:
            ()
        }
        
        return cellDefault
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.mUserInfoManager.isSigned {
            self.doSignIn(self.tv)
        }
        
        if (self.tfAccount.text?.isEmpty)! {
            return
        }
        
        switch indexPath.row {
        case 0:
            let alert = UIAlertController(title: nil, message: "Your name, please.", preferredStyle: .alert)
            alert.addTextField() {
                if let tmpName = self.tfName.text {
                    $0.text = tmpName
                }
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                let value = alert.textFields?[0].text
                
                // replace UserDefaults to CustomPlist
//                let plist = UserDefaults.standard
//                plist.set(value, forKey: "name")
//                plist.synchronize()
                
                let customPlist = "\(self.tfAccount.text!).plist"
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] as NSString
                let plist = path.strings(byAppendingPaths: [customPlist]).first!
                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPList)
                data.setValue(value, forKey: "name")
                data.write(toFile: plist, atomically: true)
                
                self.tfName.text = value
            })
            self.present(alert, animated: true, completion: nil)
            
        default:
            ()
        }
    }
    
    
    // MARK: - methods for UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.accountsSaved.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.accountsSaved[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let accountSelected = self.accountsSaved[row]
        
        let plist = UserDefaults.standard
        plist.set(accountSelected, forKey:"accountSelected")
        plist.synchronize()
        
        let customPlist = "\(accountSelected).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let clist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSDictionary(contentsOfFile: clist)
        
        self.tfName.text = data?["name"] as? String
        self.segGender.selectedSegmentIndex = data?["gender"] as? Int ?? self.defaultGender
        self.switchMartial.isOn = data?["martial"] as? Bool ?? self.defaultMartial
        
        self.tfAccount.text = accountSelected
    }
    
    // MARK: - methods for UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfAccount {
            if (self.accountsSaved.count < 1) {
                self.addAccount(textField)
            }
        }
    }
    
    // MARK: - methods for UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.mUserInfoManager.profile = img
            self.imgProfile.image = img
        }
        
        picker.dismiss(animated: true)
    }
    
    // MARK: - methods
    @objc func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex
        
        // replace UserDefaults to CustomPlist
//        let plist = UserDefaults.standard
//        plist.set(value, forKey: "gender")
//        plist.synchronize()
        
        let customPlist = "\(self.tfAccount.text!).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPList)
        data.setValue(value, forKey: "gender")
        data.write(toFile: plist, atomically: true)
    }
    
    @objc func changeMartial(_ sender: UISwitch) {
        let value = sender.isOn
        
        // replace UserDefaults to CustomPlist
//        let plist = UserDefaults.standard
//        plist.set(value, forKey: "martial")
//        plist.synchronize()
        let customPlist = "\(self.tfAccount.text!).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPList)
        data.setValue(value, forKey: "martial")
        data.write(toFile: plist, atomically: true)
    }
    
    @objc func selectAccount(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @objc func addAccount(_ sender: Any) {
        self.view.endEditing(true)
        
        let alertAddAccount = UIAlertController(title: "Your account, please.", message: nil, preferredStyle: .alert)
        alertAddAccount.addTextField() {
            $0.placeholder = "ex) abcdef@zxy.com"
        }
        alertAddAccount.addAction(UIAlertAction(title: "OK", style: .default) {(_) in
            if let mAccount = alertAddAccount.textFields?[0].text {
                if mAccount.isEmpty {
                    let alert = UIAlertController(title: nil, message:"The account must contain at least 1 character.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    self.accountsSaved.append(mAccount)
                    
                    let plist = UserDefaults.standard
                    plist.set(self.accountsSaved, forKey: "accountsSaved")
                    plist.set(mAccount, forKey:"accountSelected")
                    plist.synchronize()
                    
                    self.tfAccount.text = mAccount
                    self.tfName.text = ""
                    self.segGender.isEnabled = true
                    self.segGender.selectedSegmentIndex = self.defaultGender
                    self.switchMartial.isEnabled = true
                    self.switchMartial.isOn = self.defaultMartial
                }
            }
        })
        alertAddAccount.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertAddAccount, animated: true, completion: nil)
    }
    
    func imgProfilePicker(_ source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    @objc func profile(_ sender: UIButton) {
        guard self.mUserInfoManager.account != nil else {
            self.doSignIn(self)
            return
        }
        
        let alert = UIAlertController(title: nil, message: "From which device?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default){ (_) in
                self.imgProfilePicker(.camera)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            alert.addAction(UIAlertAction(title: "Album", style: .default){ (_) in
                self.imgProfilePicker(.savedPhotosAlbum)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default){ (_) in
                self.imgProfilePicker(.photoLibrary)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Login/Logoutmethods
    @objc func doSignIn(_ sender: Any) {
        let alertSignIn = UIAlertController(title: "LOGIN", message: nil, preferredStyle: .alert)
        
        alertSignIn.addTextField() { (tf) in
            tf.placeholder = "Your Account"
        }
        alertSignIn.addTextField() { (tf) in
            tf.placeholder = "Password"
            tf.isSecureTextEntry = true
        }
        alertSignIn.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertSignIn.addAction(UIAlertAction(title: "Login", style: .destructive) {(_) in
            let account = alertSignIn.textFields?[0].text ?? ""
            let passwd = alertSignIn.textFields?[1].text ?? ""
            
            if self.mUserInfoManager.signIn(account: account, passwd: passwd) {
                // Sign-In succeeded
                self.tv.reloadData()
                self.imgProfile.image = self.mUserInfoManager.profile
                self.drawBtnSign()
                
            } else {
                let msg = "Wrong Account or Password.\nPlease check your account."
                let alertSignInFailed = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
                alertSignInFailed.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alertSignInFailed, animated: true)
            }
        })
        
        self.present(alertSignIn, animated: true)
    }
    
    @objc func doSignOut(_ sender: Any) {
        let msg = "Sign out?"
        let alertSignOut = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        alertSignOut.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertSignOut.addAction(UIAlertAction(title: "Sign Out", style: .destructive){(_) in
            if self.mUserInfoManager.signOut() {
                self.tv.reloadData()
                self.imgProfile.image = self.mUserInfoManager.profile
                self.drawBtnSign()
            }
        })
        
        self.present(alertSignOut, animated: true)
    }
    
    func drawBtnSign() {
        let vSign = UIView()
        vSign.frame.size.width = self.view.frame.width
        vSign.frame.size.height = 40
        vSign.frame.origin.x = 0
        vSign.frame.origin.y = self.tv.frame.origin.y + self.tv.frame.height
        vSign.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        self.view.addSubview(vSign)
        
        let btnSign = UIButton()
        btnSign.frame.size.width = 100
        btnSign.frame.size.height = 30
        btnSign.center.x = vSign.frame.size.width / 2
        btnSign.center.y = vSign.frame.size.height / 2
        
        if self.mUserInfoManager.isSigned {
            btnSign.setTitle("Sign Out", for: .normal)
            btnSign.addTarget(self, action: #selector(doSignOut(_:)), for: .touchUpInside)
        } else {
            btnSign.setTitle("Sign In", for: .normal)
            btnSign.addTarget(self, action: #selector(doSignIn(_:)), for: .touchUpInside)
        }
        vSign.addSubview(btnSign)
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
