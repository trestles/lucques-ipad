//
//  Models.swift
//  lucques-ipad
//
//  Created by jonathan twaddell on 8/8/17.
//  Copyright © 2017 Trestles. All rights reserved.
//

import UIKit
import SwiftyJSON


struct MenuItem {
  let id: Int
  let header: String
  var detail: String = ""
  var price: String = ""

  init(json: JSON) {
    id = json["id"].intValue
    header = json["header"].stringValue
    detail = json["detail"].stringValue
    price  = json["price_formatted"].stringValue
  }
}

struct MenuHeader {
  let name: String
  var menuHeaders: [MenuHeader] = []
  var menuItems: [MenuItem] = []

  init(json: JSON) {
    name = json["name"].stringValue
    for (_, json) in json["menu_items"] {
      let menuItem = MenuItem(json: json)
      menuItems.append(menuItem)
    }
    
    for (_, json) in json["menu_headers"] {
      let menuHeader = MenuHeader(json: json)
      menuHeaders.append(menuHeader)
    }
  }
}

struct Menu{
  let id: Int
  var menuHeaders: [MenuHeader] = []
  var itemList: [Any] = []
  
  init(json: JSON) {
    id = json["menu"]["id"].intValue
    for (_, subJson) in json["menu"]["menu_headers"] {
      let menuHeader = MenuHeader(json: subJson)
      menuHeaders.append(menuHeader)
    }
  }
  
  mutating func buildAsItemList(menuHeaders: [MenuHeader]){
    for menuHeader in menuHeaders{
      self.itemList.append(menuHeader)
      if menuHeader.menuItems.count > 0 {
        for menuItem in menuHeader.menuItems {
          self.itemList.append(menuItem)
        }
      }
      if menuHeader.menuHeaders.count > 0 {
        buildAsItemList(menuHeaders: menuHeader.menuHeaders)
      }
    }
  }
}

struct BriefMenu{
  let id: Int
  let name: String

  init(json: JSON) {
    name = json["name"].stringValue
    id = json["id"].intValue
  }
}

struct Location {
  let name: String
  var briefMenus:[BriefMenu] = []
  init(json: JSON) {
    name = json["name"].stringValue

    for (_, subJson) in json["mobile_menus"] {
      let briefMenu = BriefMenu(json: subJson)
      briefMenus.append(briefMenu)
    }
  }
}

