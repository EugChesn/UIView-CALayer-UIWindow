//
//  CustomView.swift
//  UIVIew+CALayer_Mentoring
//
//  Created by EvgeniiChistyakov on 01.03.2021.
//

import UIKit

class CustomView: UIView {
    
    init(backgroundColor: UIColor, text: String?, shadow: Bool = false) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        baseConfigure(color: backgroundColor, isShadow: shadow)
        addLabel(text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func baseConfigure(color: UIColor, isShadow: Bool) {
        layer.backgroundColor = color.cgColor
        layer.cornerRadius = 20
        if isShadow {
            setupShadow()
        }
    }
    
    func addLabel(text: String?) {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = UIFont (name: "Helvetica Neue", size: 20)
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     label.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
    }
}

extension CustomView {
    func setupShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 30
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.5
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
