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
    
    private var stackViewTopConstraint: NSLayoutConstraint?
    private var headerConstraints: [NSLayoutConstraint] = []
    
    public var headerView: UIView? {
        didSet {
            if let newHeaderView: UIView = self.headerView {
                self.stackViewTopConstraint?.isActive = false
                self.scrollView.addSubview(newHeaderView)
                self.headerConstraints = [
                    newHeaderView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
                    newHeaderView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
                    newHeaderView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
                    newHeaderView.bottomAnchor.constraint(equalTo: self.stackView.topAnchor),
                    newHeaderView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
                ]
                NSLayoutConstraint.activate(self.headerConstraints)
            } else {
                self.headerView?.removeFromSuperview()
                self.headerConstraints.forEach({ $0.isActive = false })
                self.stackViewTopConstraint?.isActive = true
            }
        }
    }
    
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
        
        self.scrollView.alwaysBounceVertical = true
        
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                self.scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                self.scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
                self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        
        self.stackView.distribution = .fillProportionally
        self.stackView.axis = .vertical
        
        self.stackViewTopConstraint = self.stackView.topAnchor.constraint(equalTo: self.topAnchor)
        NSLayoutConstraint.activate([
            self.stackViewTopConstraint!,
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.stackView.bottomAnchor.constraint(greaterThanOrEqualTo: self.scrollView.bottomAnchor)
        ])
        self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
    }
    
}
