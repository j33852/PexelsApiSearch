//
//  Extensions.swift
//  PexelsApiSearch
//
//  Created by Chun Chieh Chang on 2024/01/26.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(message: String, title: String = "Error") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

