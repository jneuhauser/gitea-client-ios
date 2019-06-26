//
//  NavigationItemExtensions.swift
//  Gitea
//
//  Created by Johann Neuhauser on 26.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationItem {
    func setTilte(_ text: String, withImage image: UIImage?) {
        let titleImage = UIImageView()
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        titleImage.contentMode = .scaleAspectFit
        titleImage.image = image
        titleImage.addConstraint(titleImage.heightAnchor.constraint(equalTo: titleImage.widthAnchor, multiplier: 1.0 / 1.0))

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = text

        let titleStack = UIStackView()
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        titleStack.alignment = .fill
        titleStack.axis = .horizontal
        titleStack.distribution = .fill
        titleStack.spacing = 8.0
        titleStack.addArrangedSubview(titleImage)
        titleStack.addArrangedSubview(titleLabel)

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleStack)
        view.addConstraint(view.topAnchor.constraint(equalTo: titleStack.topAnchor))
        view.addConstraint(view.bottomAnchor.constraint(equalTo: titleStack.bottomAnchor))
        view.addConstraint(view.leadingAnchor.constraint(equalTo: titleStack.leadingAnchor))
        view.addConstraint(view.trailingAnchor.constraint(equalTo: titleStack.trailingAnchor))

        titleView = view
    }
}
