//
//  MainViewController.swift
//  lucques-ipad
//
//  Created by jonathan twaddell on 8/8/17.
//  Copyright © 2017 Trestles. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class mainView: UIView {
  
}

class MainViewController: UIViewController {

    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
  
    override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = UIColor.orange
      
      Alamofire.request("http://localhost:3001/arc/api/v1/locations/37/mobile").responseJSON { response in
        if let data = response.result.value {
          var json = JSON(data)
          let location = Location(json: json)
          var mainView = UIView()
          self.view.addSubview(mainView)
          mainView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
          mainView.backgroundColor = UIColor.blue
          
          Alamofire.request("http://localhost:3001/images/537/2f538d547ddeecf9dba0fa2f6d658a3e-original.jpg?1502235483").responseImage { response in
            
            if let image = response.result.value {
              var background = UIImageView(image: image)
              mainView.addSubview(background)
              mainView.sendSubview(toBack: background)
              background.frame = CGRect(x: 0, y: 0, width: mainView.bounds.width, height: mainView.bounds.height)
            }
          }
          
          if(location.briefMenus.count > 0){
            var adjustedIndex = 1
            for (index, briefMenu) in location.briefMenus.enumerated(){
              adjustedIndex += 1
              let menuLabel = UILabel()
              menuLabel.text = briefMenu.name
              
              let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapMenuLabel))
              menuLabel.isUserInteractionEnabled = true
              menuLabel.tag = briefMenu.id
              menuLabel.addGestureRecognizer(tap)
              mainView.addSubview(menuLabel)
              menuLabel.frame = CGRect(x: 20, y: (100 * adjustedIndex), width: 200, height: 20)
            }
          }
        }
      }
    }
  
  func tapMenuLabel(sender:UITapGestureRecognizer){
    let flowLayout = UICollectionViewFlowLayout()
    let menuVC = MenuViewController(collectionViewLayout: flowLayout)
    menuVC.menuId = sender.view?.tag
    navigationController?.pushViewController(menuVC, animated: true)
  }
}
