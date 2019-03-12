//
//  PageVC.swift
//  TestApp
//
//  Created by Bastien Beurier on 3/12/19.
//  Copyright © 2019 Bastien Beurier. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {

    var detailVCs: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...3 {
            detailVCs.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageDetailVC\(i)"))
        }
        
        dataSource = self
        
        if let firstVC = detailVCs.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

}

extension PageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = detailVCs.firstIndex(of:viewController)!
        return detailVCs[currentIndex == 0 ? detailVCs.count - 1 : currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = detailVCs.firstIndex(of:viewController)!
        return detailVCs[currentIndex == detailVCs.count - 1 ? 0 : currentIndex + 1]
    }
    
}
