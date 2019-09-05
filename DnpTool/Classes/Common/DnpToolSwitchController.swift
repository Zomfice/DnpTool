//
//  DnpToolSwitchController.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/19.
//

import UIKit

class DnpToolSwitchController: DnpToolBaseController {
    
    lazy var switchView: DnpToolSwitchView = {
        let m_switchView = DnpToolSwitchView()
        m_switchView.switchView.addTarget(self, action: #selector(switchAction(sender:)), for: .touchUpInside)
        return m_switchView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.switchView.title = "功能描述:"
        self.layout()
    }
    
    func layout() {
        self.view.addSubview(self.switchView)
        self.switchView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: self.switchView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.switchView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.switchView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: self.switchView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100).isActive = true
        
    }
    
    var descTitle: String{
        get{ return self.switchView.title }
        set{
            self.switchView.title = newValue
        }
    }
    
    @objc open func switchAction(sender: UISwitch) {
        
    }
    
}

/// 带有阴影的Switch Inset: 10
class DnpToolSwitchView: UIView {
    
    lazy var contentView: DnpShadowView = {
        let m_contentView = DnpShadowView(frame: CGRect(x: 0, y: 0 , width: screenwidth - 20, height: 80))
        return m_contentView
    }()
    
    lazy var switchView: UISwitch = {
        let m_switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        return m_switchView
    }()
    
    lazy var titleView: UILabel = {
        let m_title = UILabel(frame: CGRect(x: 0, y: 0, width: screenwidth - 95, height: 20))
        return m_title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleView.text = "功能描述:"
        
        self.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.contentView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: self.contentView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -10).isActive = true
        NSLayoutConstraint(item: self.contentView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: self.contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -10).isActive = true
        
        self.contentView.addSubview(self.titleView)
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.titleView, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.titleView, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1.0, constant: 10).isActive = true
        
        self.contentView.addSubview(self.switchView)
        self.switchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.switchView, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.switchView, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1.0, constant: -10).isActive = true
        NSLayoutConstraint(item: self.switchView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30).isActive = true
        NSLayoutConstraint(item: self.switchView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60).isActive = true
    }
    
    var isOn: Bool{
        get{ return self.switchView.isOn }
        set{
            self.switchView.isOn = newValue
        }
    }
    
    var title: String{
        get{ return self.titleView.text ?? "" }
        set{
            self.titleView.text = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
