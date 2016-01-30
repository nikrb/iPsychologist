//
//  ViewController.swift
//  Psychologist
//
//  Created by Nick Scott on 30/01/2016.
//  Copyright © 2016 Nick Scott. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {
    // segue in code, in case view depends on something else
    @IBAction func nothing(sender: UIButton) {
        // we still have to do the prepare for segue below (added to switch)
        performSegueWithIdentifier("nothing", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // when we embed the happiness controller in a navigation controller (to get the title at the top)
        // hvc below is no longer a HappinessViewController, but a Navigation controller
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        
        
        // if let hvc = segue.destinationViewController as? HappinessViewController {
        // original above becomes ...
        if let hvc = destination as? HappinessViewController {
            if let identifier = segue.identifier {
                switch identifier {
                    case "sad": hvc.happiness = 0
                    case "happy": hvc.happiness = 100
                    case "nothing": hvc.happiness = 25
                    default: hvc.happiness = 50
                }
            }
        }
    }
}

