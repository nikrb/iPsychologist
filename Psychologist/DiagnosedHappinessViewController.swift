//
//  DiagnosedHappinessViewController.swift
//  Psychologist
//
//  Created by Nick Scott on 30/01/2016.
//  Copyright © 2016 Nick Scott. All rights reserved.
//

// import Foundation
import UIKit

class DiagnosedHappinessViewController: HappinessViewController {
    override var happiness: Int {
        // property overrides do both didSet's
        didSet {
            diagnosticHistory += [happiness]
        }
    }
    // get a new instance every time we navigate here, so this won't do
    // var diagnosticHistory = [Int]()
    var diagnosticHistory: [Int] {
        get{ return defaults.objectForKey(History.DefaultsKey) as? [Int] ?? []}
        set{ defaults.setObject(newValue, forKey: History.DefaultsKey)}
    }
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private struct History {
        static let SegueIdentifier = "Show Diagnostic History"
        static let DefaultsKey = "DiagnosedHappinessViewController.History"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case History.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController {
                    tvc.text = "\(diagnosticHistory)"
                }
            default:break
            }
        }
    }
}
