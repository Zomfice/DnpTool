//
//  DnpRulerController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/19.
//

import UIKit

class DnpRulerController: DnpToolSwitchController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.descTitle = "开启坐标尺"
        if UserDefaults.standard.bool(forKey: "\(DnpRulerController.self)") {
            self.switchView.isOn = UserDefaults.standard.bool(forKey: "\(DnpRulerController.self)")
        }
    }
    
    override func switchAction(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "\(DnpRulerController.self)")
        
        DnpToolHomeWindow.shareInstance.hide()
    }
}
