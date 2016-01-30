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
    var diagnosticHistory = [Int]()
    
    private struct History {
        static let SegueIdentifier = "Show Diagnostic History"
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
