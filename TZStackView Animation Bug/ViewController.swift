//
//  ViewController.swift
//  TZStackView Animation Bug
//
//  Created by Ryan Zulkoski on 11/1/15.
//  Copyright © 2015 RZGamer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let outerStackView = TZStackView()
    let leftInnerStackView = TZStackView()
    let middleInnerStackView = TZStackView()
    let rightInnerStackView = TZStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init Outer StackView
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.axis = .Horizontal
        outerStackView.distribution = .FillEqually
        outerStackView.spacing = 10
        outerStackView.backgroundColor = .blackColor()
        view.addSubview(outerStackView)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[outerStackView]|", options: .AlignAllCenterX, metrics: nil, views: ["outerStackView": outerStackView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[outerStackView]|", options: .AlignAllCenterX, metrics: nil, views: ["outerStackView": outerStackView]))
        
        // Init Left Inner StackView
        leftInnerStackView.translatesAutoresizingMaskIntoConstraints = false
        leftInnerStackView.axis = .Vertical
        leftInnerStackView.backgroundColor = .redColor()
        outerStackView.addArrangedSubview(leftInnerStackView)
        
        // Init Middle Inner StackView
        middleInnerStackView.translatesAutoresizingMaskIntoConstraints = false
        middleInnerStackView.axis = .Vertical
        middleInnerStackView.backgroundColor = .greenColor()
        middleInnerStackView.hidden = (viewOrientationForSize(UIScreen.mainScreen().bounds.size) == .Portrait)
        outerStackView.addArrangedSubview(middleInnerStackView)
        
        // Init Right Inner StackView
        rightInnerStackView.translatesAutoresizingMaskIntoConstraints = false
        rightInnerStackView.axis = .Vertical
        rightInnerStackView.backgroundColor = .blueColor()
        outerStackView.addArrangedSubview(rightInnerStackView)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition(
            { context in
                
                // On rotation hide the middleInnerStackView if moving to Portrait or show the middleInnerStackView if moving to Landscape.
                self.middleInnerStackView.hidden = (self.viewOrientationForSize(size) == .Portrait)
                
                /*
                ** Notice that after the first rotation the app stops recognizing or listening for when rotation occurs. This is due
                ** to TZStackView setting itself as the animation delegate on line 117 of TZStackView.swift.
                **
                ** If you comment out lines 116-120 and line 122 (leaving just the didFinishSettingHiddenValue call) everything appears
                ** to work fine EXCEPT when animating the middleInnerStackView to hidden = true as the view is instantly hidden while
                ** leftInnerStackView and rightInnerStackView appropriately animate to fill the empty space. It does however work as expected
                ** when animating the middleInnerStackView to hidden = false.
                **
                ** Note: Using an actual UIStackView and targetting iOS 9 does not produce this issue and everything works fine.
                */
            }, completion:nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

enum ViewOrientation {
    case Portrait
    case Landscape
}

extension UIViewController {
    
    func viewOrientationForSize(size: CGSize) -> ViewOrientation {
        return (size.width > size.height) ? .Landscape : .Portrait
    }
}