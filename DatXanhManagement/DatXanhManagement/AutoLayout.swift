//
//  AutoLayout.swift
//  DatXanhManagement
//
//  Created by ivc on 8/22/19.
//  Copyright © 2019 Trong Tran. All rights reserved.
//

import UIKit

class AutoLayout {
    public static let shared = AutoLayout()
    
    func getTopLeftBottomRightConstraint(currentView: UIView, destinationView: UIView, constant: [CGFloat]) -> [NSLayoutConstraint] {
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .left, .bottom, .right]
        var arrConstraint: [NSLayoutConstraint] = []
        for i in 0..<attributes.count {
            arrConstraint.append(NSLayoutConstraint(item: currentView, attribute: attributes[i], relatedBy: .equal, toItem: destinationView, attribute: attributes[i], multiplier: 1.0, constant: constant[i]))
        }
        return arrConstraint
    }
    
    func getLeftRightConstraint(currentView: UIView, destinationView: UIView, constant: [CGFloat]) -> [NSLayoutConstraint] {
        let attributes: [NSLayoutConstraint.Attribute] = [.left, .right]
        var arrConstraint: [NSLayoutConstraint] = []
        for i in 0..<attributes.count {
            arrConstraint.append(NSLayoutConstraint(item: currentView, attribute: attributes[i], relatedBy: .equal, toItem: destinationView, attribute: attributes[i], multiplier: 1.0, constant: constant[i]))
        }
        return arrConstraint
    }
    
    func getTopConstraint(from currentView: UIView, toBottomOf destinationView: UIView, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: currentView, attribute: .top, relatedBy: .equal, toItem: destinationView, attribute: .bottom, multiplier: 1.0, constant: constant)
    }
    
    func getBottomConstraint(from currentView: UIView, toTopOf destinationView: UIView, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: currentView, attribute: .bottom, relatedBy: .equal, toItem: destinationView, attribute: .top, multiplier: 1.0, constant: constant)
    }
    
    func get3NeedsTopConstraint(currentView: UIView, destinationView: UIView, constant: [CGFloat]) -> [NSLayoutConstraint] {
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .left, .right]
        var arrConstraint: [NSLayoutConstraint] = []
        for i in 0..<attributes.count {
            arrConstraint.append(NSLayoutConstraint(item: currentView, attribute: attributes[i], relatedBy: .equal, toItem: destinationView, attribute: attributes[i], multiplier: 1.0, constant: constant[i]))
        }
        return arrConstraint
    }
    
    func get3NeedsBottomConstraint(currentView: UIView, destinationView: UIView, constant: [CGFloat]) -> [NSLayoutConstraint] {
        let attributes: [NSLayoutConstraint.Attribute] = [.bottom, .left, .right]
        var arrConstraint: [NSLayoutConstraint] = []
        for i in 0..<attributes.count {
            arrConstraint.append(NSLayoutConstraint(item: currentView, attribute: attributes[i], relatedBy: .equal, toItem: destinationView, attribute: attributes[i], multiplier: 1.0, constant: constant[i]))
        }
        return arrConstraint
    }
}
