//
//  MenuItemViewController.swift
//  lucques-ipad
//
//  Created by jonathan twaddell on 8/8/17.
//  Copyright © 2017 Trestles. All rights reserved.
//

import UIKit

class MenuItemViewController: UIViewController {
  
    var menuItem: MenuItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        if let item = menuItem {
          print("menuItem: \(item.header)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
