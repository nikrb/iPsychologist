//
//  HappinessViewController.swift
//  iHappiness
//
//  Created by Nick Scott on 29/01/2016.
//  Copyright © 2016 Nick Scott. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {
    
    var happiness: Int = 100 { // 0= very sad, 100- ecstatic
        didSet{
            happiness = min( max( happiness, 0), 100)
            print("happiness = \(happiness)")
            updateUI()
        }
    }
    private struct Constants {
        static let HappinessGestureScale: CGFloat = 4
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            // note the colon after action param
            faceView.addGestureRecognizer( UIPinchGestureRecognizer(target: faceView, action: "scale:"))
            // one way to add the pan gesture, note target self as controller handles change to model
            // faceView.addGestureRecognizer( UIPanGestureRecognizer(target: self, action: "changeHappiness:"))
            // the other way, from storyboard is below
        }
    }
    
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int( translation.y / Constants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default: break
        }
    }
    
    private func updateUI(){
        // the ? here is an optional saying, if it's nil ignore the rest. This happens because
        // we're called here from a segue prepare and the outlets aren't set yet
        faceView?.setNeedsDisplay()
        title = "\(happiness)"
    }
    // implement protocol (interpret model for the view)
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50)/50
    }
}
