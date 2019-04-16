//
//  TutorialMasterVC.swift
//  MyMemory
//
//  Created by hkim on 2019. 3. 3..
//  Copyright © 2019년 hkim. All rights reserved.
//

import UIKit

class TutorialMasterVC: UIViewController, UIPageViewControllerDataSource {
    var pageVC: UIPageViewController!
    
    var contentTitles = ["STEP 1", "STEP 2", "STEP 3", "STEP 4"]
    var contentImages = ["Page0", "Page1", "Page2", "Page3"]
    
    @IBAction func clickBtnStart(_ sender: Any) {
        let ud = UserDefaults.standard
        ud.set(true, forKey: UserInfoKey.tutorial)
        ud.synchronize()
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageVC = self.instanceSbTutorial(name: "PageVC") as! UIPageViewController
        self.pageVC.dataSource = self
        
        let startContentVC = self.getContentVC(atIndex: 0)!     // initial View Controller
        self.pageVC.setViewControllers([startContentVC], direction: .forward, animated: true)
        
        self.pageVC.view.frame.origin = CGPoint(x: 0, y: 0)
        self.pageVC.view.frame.size.width = self.view.frame.width
        self.pageVC.view.frame.size.height = self.view.frame.height - 200
        
        self.addChild(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParent: self)
    }
    
    func getContentVC(atIndex idx: Int) -> UIViewController? {
        guard self.contentTitles.count >= idx && self.contentTitles.count > 0 else {
            return nil
        }
        
        guard let cvc = self.instanceSbTutorial(name: "ContentVC") as? TutorialContentVC else {
            return nil
        }
        
        cvc.titleText = self.contentTitles[idx]
        cvc.imgName = self.contentImages[idx]
        cvc.pageIndex = idx
        
        return cvc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as! TutorialContentVC).pageIndex else {
            return nil
        }
        
        guard index > 0 else {
            return nil
        }
        
        index -= 1
        
        return self.getContentVC(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as! TutorialContentVC).pageIndex else {
            return nil
        }
        
        index += 1
        
        guard index < self.contentTitles.count else {
            return nil
        }
        
        return self.getContentVC(atIndex: index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.contentTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
