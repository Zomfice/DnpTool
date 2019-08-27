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
        UserDefaults.standard.set(DnpRulerManager.shareInstance.isShowing, forKey: "\(DnpRulerController.self)")
        if UserDefaults.standard.bool(forKey: "\(DnpRulerController.self)") {
            self.switchView.isOn = UserDefaults.standard.bool(forKey: "\(DnpRulerController.self)")
        }
    }
    
    override func switchAction(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "\(DnpRulerController.self)")
        if sender.isOn{
            DnpRulerManager.shareInstance.show()
        }else{
            DnpRulerManager.shareInstance.hidden()
        }
        DnpToolHomeWindow.shareInstance.hide()
    }
}
