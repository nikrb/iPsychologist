//
//  FaceView.swift
//  iHappiness
//
//  Created by Nick Scott on 29/01/2016.
//  Copyright © 2016 Nick Scott. All rights reserved.
//

import UIKit

// could be FaceViewDelegate, but we're only using it for data
// if protocol isn't restricted to class, we get an error weak cannot be applied to non-class type
// when we declare the pointer as weak var dataSource:FaceViewDataSource below
protocol FaceViewDataSource: class {
    func smilinessForFaceView( sender: FaceView) -> Double?
}

// draw in storyboard designer!
@IBDesignable
class FaceView: UIView {
    // by default rotating the view "scale to fill" will draw an ellipse :(
    // to stop the scale to fill, select view then change view attribute view mode to "redraw" from "scale to fill"
    // observe change to spark redraw
    // @IBInspectable puts a property into the design view attribute inspector
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet{ setNeedsDisplay()}}
    @IBInspectable
    var colour: UIColor = UIColor.blueColor() {didSet{ setNeedsDisplay()}}
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay()}}
    
    var faceCentre : CGPoint{
        // for a read only prop we don't need the get {}, just return 'only' get {
        return convertPoint(center, fromView: superview)
    }
    var faceRadius: CGFloat{
        return min(bounds.size.width, bounds.size.height)/2 * scale
    }
    
    // using the protocol
    // weak because this and caller reference each other giving circular dependency to will never leave memory
    // it means the pointer should not be used to keep it in memory
    weak var dataSource: FaceViewDataSource?
    
    func scale( gesture: UIPinchGestureRecognizer){
        if gesture.state == .Changed {
            scale *= gesture.scale
            // only get the scale change each time
            gesture.scale = 1
        }
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCentre, radius: faceRadius, startAngle: 0, endAngle: CGFloat( 2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        colour.set() // sets fill and stroke
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        // ?? notation: if the lhs is not nil else use 0.0
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }
    
    private enum Eye { case Left, Right }
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private func bezierPathForEye( whichEye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCentre = faceCentre
        eyeCentre.y -= eyeVerticalOffset
        switch whichEye{
        case .Left: eyeCentre.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCentre.x += eyeHorizontalSeparation / 2
        }
        
        let path = UIBezierPath(arcCenter: eyeCentre, radius: eyeRadius, startAngle: 0, endAngle: CGFloat( 2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func bezierPathForSmile( fractionOfMaxSmile: Double) -> UIBezierPath{
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat( max( min( fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint( x: faceCentre.x - mouthWidth / 2, y: faceCentre.y + mouthVerticalOffset)
        let end = CGPoint( x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint( x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint( x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
}
