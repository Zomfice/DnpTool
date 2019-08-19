//
//  DnpShadowView.swift
//  DnpTool
//
//  Created by Zomfice on 2019/8/19.
//

import UIKit

internal class DnpShadowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 10
        self.layer.shadowColor = UIColor.dnp_colorWithHex(hex: 0xC8C8C8, alpha: 0.5).cgColor
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
