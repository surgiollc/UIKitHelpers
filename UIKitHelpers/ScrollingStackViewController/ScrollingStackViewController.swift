//
//  ScrollingStackViewController.swift
//  UIKitHelpers
//
//  Created by Chandler De Angelis on 5/30/18.
//  Copyright © 2018 Chandler De Angelis. All rights reserved.
//

import UIKit

open class ScrollingStackViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Properties
    
    private let scrollView: UIScrollView = UIScrollView.autolayoutView()
    private let stackView: UIStackView = UIStackView.autolayoutView()
    
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
    
    public var spacing: CGFloat {
        get {
            return self.stackView.spacing
        }
        set {
            self.stackView.spacing = newValue
        }
    }
    
    private var pinnedHeaderView: UIView? {
        willSet {
            self.pinnedHeaderView?.removeFromSuperview()
        }
    }
    
    private var pinnedParentView: UIView? {
        didSet {
            self.pinnedParentView?.removeFromSuperview()
        }
    }
    
    private var pinnedHeaderViewBottomConstraint: NSLayoutConstraint? {
        willSet {
            self.pinnedHeaderViewBottomConstraint?.isActive = false
        }
    }

    // MARK: - View Lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)

        self.scrollView.alwaysBounceVertical = true
        
        self.scrollView.activateAllSideAnchors()
        
        self.stackView.distribution = .fillProportionally
        self.stackView.axis = .vertical
        
        self.stackViewTopConstraint = self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor)
        NSLayoutConstraint.activate([
            self.stackViewTopConstraint!,
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
    
    // MARK: - Public
    
    public func pinToHeader(_ subview: UIView) {
        guard let headerView: UIView = self.headerView else { return }
        self.pinnedHeaderView = subview
        self.scrollView.addSubview(subview)
        self.pinnedHeaderViewBottomConstraint = subview.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, priority: .defaultLow)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.pinnedHeaderViewBottomConstraint!
        ])
        let topConstraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            topConstraint = subview.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor)
        } else {
            topConstraint = subview.topAnchor.constraint(greaterThanOrEqualTo: self.topLayoutGuide.topAnchor)
        }
        topConstraint.isActive = true
    }
    
    public func insert(_ child: UIViewController) {
        self.addChildViewController(child)
        child.didMove(toParentViewController: self)
        self.stackView.insertArrangedSubview(child.view, at: self.stackView.arrangedSubviews.endIndex)
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView: UIView = self.headerView,
            let pinnedView: UIView = self.pinnedHeaderView else { return }
        
        let targetOffset: CGFloat = headerView.bounds.height - pinnedView.bounds.height
        if scrollView.contentOffset.y >= targetOffset &&
            self.pinnedHeaderViewBottomConstraint?.isActive == true {
            self.pinnedHeaderViewBottomConstraint?.isActive = false
        } else if scrollView.contentOffset.y < targetOffset &&
            self.pinnedHeaderViewBottomConstraint?.isActive == false {
            self.pinnedHeaderViewBottomConstraint?.isActive = true
        }
    }
}
