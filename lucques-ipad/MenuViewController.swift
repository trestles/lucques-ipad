//
//  MenuViewController.swift
//  lucques-ipad
//
//  Created by jonathan twaddell on 8/8/17.
//  Copyright © 2017 Trestles. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


class MenuItemCell: BaseCell {
  var headerLabel:UILabel = {
    let header = UILabel()
    return header
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(headerLabel)
    headerLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class MenuHeaderCell: BaseCell {
  let nameLabel:UILabel = {
    let name = UILabel()
    return name
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(nameLabel)
    nameLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


class BaseCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class MenuViewController: UICollectionViewController,  UICollectionViewDelegateFlowLayout {

  var menuId:Int?
  var menu:Menu?
  var itemList: [Any]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = UIColor.yellow
      
    collectionView?.register(MenuItemCell.self, forCellWithReuseIdentifier: "itemCell")
    collectionView?.register(MenuHeaderCell.self, forCellWithReuseIdentifier: "headerCell")
      
    if let menuIdValue = menuId {
      Alamofire.request("http://localhost:3001/arc/api/v1/menus/\(menuIdValue)").responseJSON { response in
        if let data = response.result.value {
          var json = JSON(data)
          var menu = Menu(json: json)
          menu.buildAsItemList(menuHeaders: menu.menuHeaders)
          self.itemList = menu.itemList
          DispatchQueue.main.async{
            self.collectionView?.reloadData()
          }
        }
      }
    }
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let count = itemList?.count {
      return count
    }
    return 5
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath)
    if let item = itemList?[indexPath.item]{
      if type(of: item) == MenuItem.self {
        let menuItem = item as! MenuItem
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! MenuItemCell
        cell.headerLabel.text = menuItem.header
        cell.backgroundColor = UIColor.green
        return cell
      }
      if type(of: item) == MenuHeader.self {
        let menuHeader = item as! MenuHeader
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! MenuHeaderCell
        cell.nameLabel.text = menuHeader.name
        cell.backgroundColor = UIColor.blue
        return cell
      }
    }
    cell.backgroundColor = UIColor.red
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 100.0)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let item = itemList?[indexPath.item]{
      if type(of: item) == MenuItem.self {
        let menuItem = item as! MenuItem
        let menuItemVC = MenuItemViewController()
        menuItemVC.menuItem = menuItem
        navigationController?.pushViewController(menuItemVC, animated: true)
      }
      if type(of: item) == MenuHeader.self {
        let menuHeader = item as! MenuHeader
      }
    }
  }
}
