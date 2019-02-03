//
//  MemoVC.swift
//  MyMemory
//
//  Created by Administrator on 2019. 1. 15..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

class MemoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    @IBOutlet var contentTV: UITextView!
    @IBOutlet var contentIV: UIImageView!
    var mTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bgImage = UIImage(named: "imgMemo")!
        self.view.backgroundColor = UIColor(patternImage: bgImage)

        self.contentTV.delegate = self
        self.contentTV.layer.borderColor = UIColor.clear.cgColor
        self.contentTV.layer.borderWidth = 0
        self.contentTV.backgroundColor = UIColor.clear
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 9
        self.contentTV.attributedText = NSAttributedString(string: " ", attributes: [NSAttributedString.Key.paragraphStyle: style])
        self.contentTV.text = ""
    }
    
    // MARK: - Bar icon actions
    @IBAction func openGallery(_ sender: Any) {
        // define and set UIImagePickerController instance
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true     // whether edit controller shows up after selecting a photo
        
        // show UIImagePickerController instance
        self.present(picker, animated: true)
    }
    
    @IBAction func saveMemo(_ sender: Any) {
        // No contents? Warn out
        guard self.contentTV.text?.isEmpty == false else {
            let alertV = UIViewController()
            let iconImage = UIImage(named: "icoWarning")
            alertV.view = UIImageView(image: iconImage)
            alertV.preferredContentSize = iconImage?.size ?? CGSize.zero
            
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))      // each "addAction" adds a button for the alert
            alert.setValue(alertV, forKey: "contentViewController")
            self.present(alert, animated: true)
            return
        }
        
        // Contents? Create instance and set it
        let data = MemoData()
        data.title = self.mTitle
        data.contents = self.contentTV.text
        data.image = self.contentIV.image
        data.regDate = Date()
        data.edtDate = Date()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memoList.append(data)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITextViewDelegate methods
    func textViewDidChange(_ textView: UITextView) {
        let contents = textView.text as NSString
        let length = ((contents.length > 15) ? 15 : contents.length)
        self.mTitle = contents.substring(with: NSRange(location: 0, length: length))
        
        self.navigationItem.title = mTitle
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: TimeInterval(0.3)) { (self.navigationController?.navigationBar)?.alpha = 0 }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: TimeInterval(0.3)) { (self.navigationController?.navigationBar)?.alpha = 1 }
    }
    
    // MARK: - UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.contentIV.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        picker.dismiss(animated: true)
    }
    
    // MARK: - UINavigationControllerDelegate methods
}
