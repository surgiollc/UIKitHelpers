//
//  ScrollingStackView.swift
//  UIKitHelpers
//
//  Created by Chandler De Angelis on 5/30/18.
//  Copyright © 2018 Chandler De Angelis. All rights reserved.
//

import UIKit

public final class ScrollingStackView: UIView {

    // MARK: - Properties
    
    let scrollView: UIScrollView
    let stackView: UIStackView
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        self.scrollView = UIScrollView.autolayoutView()
        self.stackView = UIStackView.autolayoutView()
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setup() {
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)
        
        self.stackView.distribution = .fillProportionally
        self.stackView.axis = .vertical
        
        self.stackView.activateAllSideAnchors()
        self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
    }
    
}
