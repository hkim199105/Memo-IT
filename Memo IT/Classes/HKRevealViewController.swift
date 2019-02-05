//
//  HKRevealViewController.swift
//  MyMemory
//
//  Created by hkim on 2019. 2. 3..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

class HKRevealViewController: UIViewController {

    var contentVC: UIViewController?
    var menuVC: UIViewController?
    var isMenuShowing = false
    let SLIDE_TIME = 0.3
    let MENU_WIDTH: CGFloat = 260
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
// MARK: - init View
    func setupView() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_front") as? UINavigationController {
            self.contentVC = vc
            self.addChild(vc)
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)
            
            let frontVC = vc.viewControllers[0] as? ListVC
            frontVC?.delegate = self
        }
    }
    
// MARK: - set Side View
    func getSideView() {
        if self.menuVC == nil {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_rear") {
                self.menuVC = vc
                self.addChild(vc)
                self.view.addSubview(vc.view)
                vc.didMove(toParent: self)
                self.view.bringSubviewToFront((self.contentVC?.view)!)
            }
        }
    }
    
    func openSideBar(_ complete: ( () -> Void )? ) {
        self.getSideView()
        self.setShadowEffect(shadow: true, offset: -2)
        
        UIView.animate(
            withDuration: TimeInterval(self.SLIDE_TIME),
            delay: TimeInterval(0),
            options: UIView.AnimationOptions([.curveEaseInOut, .beginFromCurrentState]),
            animations: {
                self.contentVC?.view.frame = CGRect(x: self.MENU_WIDTH, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            },
            completion: {
                if $0 {
                    self.isMenuShowing = true
                    complete?()
                }
            }
        )
    }
    
    func closeSideBar(_ complete: ( () -> Void )? ) {
        UIView.animate(
            withDuration: TimeInterval(self.SLIDE_TIME),
            delay: TimeInterval(0),
            options: UIView.AnimationOptions([.curveEaseInOut, .beginFromCurrentState]),
            animations: {
                self.contentVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            },
            completion: {
                if $0 {
                    self.menuVC?.view.removeFromSuperview()
                    self.menuVC = nil
                    self.isMenuShowing = false
                    self.setShadowEffect(shadow: false, offset: 0)
                    complete?()
                }
            }
        )
    }

    func setShadowEffect(shadow: Bool, offset: CGFloat) {
        if (shadow == true) {
            self.contentVC?.view.layer.cornerRadius = 10
            self.contentVC?.view.layer.shadowOpacity = 0.8
            self.contentVC?.view.layer.shadowColor = UIColor.black.cgColor
            self.contentVC?.view.layer.shadowOffset = CGSize(width: offset, height: offset)
        } else {
            self.contentVC?.view.layer.cornerRadius = 0.0
            self.contentVC?.view.layer.shadowOffset = CGSize.zero
        }
    }
}
