//
//  DatePickerView.swift
//  UIKitHelpers
//
//  Created by Chandler De Angelis on 4/27/18.
//  Copyright © 2018 Chandler De Angelis. All rights reserved.
//

import UIKit

final class DatePickerView: UIView {
    
    override var intrinsicContentSize: CGSize {
        set {}
        get {
            var result: CGSize = CGSize()
            result.width = self.bounds.width
            result.height += self.titleLabel.intrinsicContentSize.height
            result.height += self.doneButton.intrinsicContentSize.height
            result.height += self.picker.intrinsicContentSize.height
            result.height += 32
            return result
        }
    }

    let titleLabel: UILabel = {
        let label: UILabel = UILabel.autolayoutView()
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let doneButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = UIColor.defaultViewTintColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        return button
    }()
    
    let picker: UIDatePicker

    override init(frame: CGRect) {
        self.picker = UIDatePicker()
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = UIColor.white
        
        self.doneButton.backgroundColor = UIColor.defaultViewTintColor
        self.doneButton.clipsToBounds = true
        self.doneButton.layer.cornerRadius = 7
        
        self.titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        let stackView: UIStackView = UIStackView.autolayoutView()
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.addArrangedSubview(self.titleLabel)
        stackView.addArrangedSubview(self.picker)
        stackView.addArrangedSubview(self.doneButton)
        
        self.addSubview(stackView)
        stackView.activateAllSideAnchors(
            padding: .withValue(16),
            priorities: .withPriority(.almostRequired)
        )
        
        NSLayoutConstraint.activate([
            self.picker.heightAnchor.constraint(equalToConstant: 200),
            self.doneButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = UIView.defaultCornerRadius
    }
}
