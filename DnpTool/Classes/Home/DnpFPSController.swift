//
//  DnpFPSController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/28.
//

import UIKit

class DnpFPSController: DnpToolSwitchController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.descTitle = "开启FPS检测"
        UserDefaults.standard.set(DnpFpsManager.shareInstance.isShowing, forKey: "\(DnpFPSController.self)")
        if UserDefaults.standard.bool(forKey: "\(DnpFPSController.self)") {
            self.switchView.isOn = UserDefaults.standard.bool(forKey: "\(DnpFPSController.self)")
        }
    }
    
    override func switchAction(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "\(DnpFPSController.self)")
        if sender.isOn{
            DnpFpsManager.shareInstance.show()
        }else{
            DnpFpsManager.shareInstance.hidden()
        }
        DnpToolHomeWindow.shareInstance.hide()
    }

}
