//
//  DnpToolBaseController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/7/30.
//

import UIKit

class DnpToolBaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let appWindow = UIApplication.shared.delegate?.window
        let keyWindow = UIApplication.shared.keyWindow
        if let m_appWindow = appWindow,let m_keyWindow = keyWindow,m_appWindow != m_keyWindow{
            m_appWindow?.makeKey()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
