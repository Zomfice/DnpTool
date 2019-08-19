//
//  DnpToolSwitchController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/19.
//

import UIKit

class DnpToolSwitchController: DnpToolBaseController {

    lazy var contentView: DnpShadowView = {
        let m_contentView = DnpShadowView(frame: CGRect(x: 10, y: navigationHeight + 20, width: screenwidth - 20, height: 80))
        return m_contentView
    }()
    
    lazy var switchView: UISwitch = {
        let m_switchView = UISwitch(frame: CGRect(x: screenwidth - 85, y: 25, width: 60, height: 30))
        m_switchView.addTarget(self, action: #selector(switchAction(sender:)), for: .touchUpInside)
        return m_switchView
    }()
    
    lazy var titleView: UILabel = {
        let m_title = UILabel(frame: CGRect(x: 10, y: 30, width: screenwidth - 95, height: 20))
        return m_title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleView.text = "功能描述:"
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.titleView)
        self.contentView.addSubview(self.switchView)
    }
    
    var descTitle: String{
        get{ return self.titleView.text ?? "" }
        set{
            self.titleView.text = newValue
        }
    }
    
    @objc open func switchAction(sender: UISwitch) {
        
    }
    
}
