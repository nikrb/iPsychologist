//
//  TextViewController.swift
//  Psychologist
//
//  Created by Nick Scott on 30/01/2016.
//  Copyright © 2016 Nick Scott. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = text
        }
    }
    
    var text:String = "" {
        didSet {
            // ? in case it's used during prepare segue
            textView?.text = text
        }
    }
    
    override var preferredContentSize: CGSize {
        get {
            // presentingViewController comes from UIViewController
            // set only when view is presenting
            if textView != nil && presentingViewController != nil {
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            } else {
                return super.preferredContentSize
            }
        }
        set { super.preferredContentSize = newValue }
    }
}
