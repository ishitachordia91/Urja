//
//  CardView.swift
//  Urja
//
//  Created by Ishita Chordia on 3/12/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

import UIKit

class CardView: UIView {

    override func drawRect(rect: CGRect){
        let path = UIBezierPath()
        path.lineWidth = 2.0
        UIColor.greenColor().setFill()
        
        //create the left hand side of the card
        path.moveToPoint(CGPoint(x: 0.2 * bounds.size.width, y: 0.2 * bounds.size.height))
        path.addLineToPoint(CGPoint(x: 0.2 * bounds.size.width, y: 0.8 * bounds.size.height))
        path.addLineToPoint(CGPoint(x: 0.5 * bounds.size.width, y: 0.75 * bounds.size.height))
        path.addLineToPoint(CGPoint(x: 0.5 * bounds.size.width, y: 0.25 * bounds.size.height))
        path.closePath()
        
        //create the right hand side of the card
        path.moveToPoint(CGPoint(x: 0.5 * bounds.size.width, y: 0.25 * bounds.size.height))
        path.addLineToPoint(CGPoint(x: 0.8 * bounds.size.width, y: 0.2 * bounds.size.height))
        path.addLineToPoint(CGPoint(x: 0.8 * bounds.size.width, y: 0.8 * bounds.size.height))
        path.addLineToPoint(CGPoint(x: 0.5 * bounds.size.width, y: 0.75 * bounds.size.height))
        
        //adds color
        path.stroke()
        path.fill()
        
        //adds image
        //   let image: UIImage? = UIImage(named: "foo")
        //   image?.drawAtPoint(<#T##point: CGPoint##CGPoint#>)
    }

}
