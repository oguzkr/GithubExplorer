//
//  UIImageView.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 23.06.2021.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: String) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL(string: url)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
