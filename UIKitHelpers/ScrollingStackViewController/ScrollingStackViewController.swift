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
    
    private var pinnedHeaderView: UIView? {
        willSet {
            self.pinnedHeaderView?.removeFromSuperview()
        }
    }
    
    private var pinnedHeaderViewBottomConstraint: NSLayoutConstraint? {
        willSet {
            self.pinnedHeaderViewBottomConstraint?.isActive = false
        }
    }

    // MARK: - View Lifecycle
    
    open override func loadView() {
        self.view = ScrollingStackView()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.scrollView.delegate = self
    }
    
    // MARK: - Public
    
    public func insert(_ child: UIViewController) {
        self.addChildViewController(child)
        child.didMove(toParentViewController: self)
        self.scrollView.stackView.insertArrangedSubview(child.view, at: self.scrollView.stackView.arrangedSubviews.endIndex)
    }
    
    public func pinToHeader(_ subview: UIView) {
        guard let headerView: UIView = self.headerView else { return }
        self.pinnedHeaderView = subview
        self.scrollView.scrollView.addSubview(subview)
        self.pinnedHeaderViewBottomConstraint = subview.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, priority: .defaultLow)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: self.scrollView.scrollView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: self.scrollView.scrollView.trailingAnchor),
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
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView: UIView = self.headerView,
            let pinnedView: UIView = self.pinnedHeaderView,
            headerView.bounds.height > 0.0 else { return }
        
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
