//
//  DatePickerViewController.swift
//  UIKitHelpers
//
//  Created by Chandler De Angelis on 4/27/18.
//  Copyright © 2018 Chandler De Angelis. All rights reserved.
//

import UIKit

public protocol DatePickerViewControllerDelegate: class {
    func didChangeDate(_ date: Date)
}

public final class DatePickerViewController: UIViewController {

    // MARK: - Properties
    
    public weak var delegate: DatePickerViewControllerDelegate?
    
    public var pickerTitle: String? {
        get {
            return self.datePickerView.titleLabel.text
        }
        set {
            self.datePickerView.titleLabel.text = newValue
        }
    }
    
    private var datePickerView: DatePickerView {
        return self.view as! DatePickerView
    }
    
    public override var preferredContentSize: CGSize {
        set {}
        get {
            return self.view.intrinsicContentSize
        }
    }
    
    // MARK: - Init
    
    public convenience init() {
        self.init(creationTime: Date())
    }
    
    public init(creationTime: Date) {
        super.init(nibName: .none, bundle: .none)
        self.datePickerView.picker.date = creationTime
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    public override func loadView() {
        self.view = DatePickerView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePickerView.doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        self.datePickerView.doneButton.addTarget(
            self,
            action: #selector(self.done(_:)),
            for: .touchUpInside
        )
        self.datePickerView.picker.datePickerMode = .dateAndTime
        self.datePickerView.picker.addTarget(
            self,
            action: #selector(self.dateChanged(_:)),
            for: .valueChanged
        )
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate?.didChangeDate(self.datePickerView.picker.date)
    }
    
    // MARK: - Actions
    
    @objc func dateChanged(_ sender: Any) {
        self.delegate?.didChangeDate(self.datePickerView.picker.date)
    }
    
    @objc func done(_ sender: Any) {
        self.dismiss(animated: true, completion: .none)
    }
}

