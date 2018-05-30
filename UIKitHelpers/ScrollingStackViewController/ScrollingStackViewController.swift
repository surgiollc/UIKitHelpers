//
//  ScrollingStackViewController.swift
//  UIKitHelpers
//
//  Created by Chandler De Angelis on 5/30/18.
//  Copyright © 2018 Chandler De Angelis. All rights reserved.
//

import UIKit

open class ScrollingStackViewController: UIViewController {

    // MARK: - Properties
    
    public var headerView: UIView? {
        get {
            return self.scrollView.headerView
        }
        set {
            self.scrollView.headerView = newValue
        }
    }
    
    public var scrollView: ScrollingStackView {
        return self.view as! ScrollingStackView
    }

    // MARK: - View Lifecycle
    
    open override func loadView() {
        self.view = ScrollingStackView()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
