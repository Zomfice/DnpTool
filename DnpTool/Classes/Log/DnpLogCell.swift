//
//  DnpLogCell.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/22.
//

import UIKit

class DnpLogCell: UITableViewCell {
    
    lazy var title: UILabel = {
        let m_title = UILabel(frame: .zero)
        m_title.font = UIFont.systemFont(ofSize: 15)
        m_title.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        m_title.numberOfLines = 0
        m_title.textAlignment = .left
        m_title.lineBreakMode = .byCharWrapping
        return m_title
    }()
    
    lazy var line: UIView = {
        let m_line = UIView()
        m_line.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        return m_line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        layout()
    }
    
    func layout() {
        self.contentView.addSubview(self.title)
        self.title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.title, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: self.title, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1.0, constant: -10).isActive = true
        NSLayoutConstraint(item: self.title, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: self.title, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: -10).isActive = true
        
        self.contentView.addSubview(self.line)
        self.line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.line, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.line, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.line, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
