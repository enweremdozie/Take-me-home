//
//  infoWindow.swift
//  Take me home
//
//  Created by Dozie Enwerem on 2018-02-21.
//  Copyright © 2018 Dozie Enwerem. All rights reserved.
//

import Foundation
import UIKit

/*protocol MapMarkerDelegate: class {
 func didTapInfoButton(data: NSDictionary)
 }*/

class infoWindow: UIView{
    @IBOutlet weak var transitType: UILabel!
    @IBOutlet weak var transitName: UILabel!
    @IBOutlet weak var stopName: UILabel!
    @IBOutlet weak var depTime: UILabel!
    @IBOutlet weak var arrTime: UILabel!
    
    //weak var delegate: MapMarkerDelegate?
    //var spotData: NSDictionary?
    
    
    
    /*class func instanceFromNib() -> UIView {
        return UINib(nibName: "infoWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }*/
}
