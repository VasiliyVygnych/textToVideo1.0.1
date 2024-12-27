//
//  String.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 09.11.2024.
//

import UIKit

extension String {
    func localized(_ language: String) -> String {
        if let path = Bundle.main.path(forResource: language,
                                       ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(self,
                                     bundle: bundle,
                                     comment: "")
        }
        return ""
    }
}
//extension UILabel {
//    func setLocalizedText(text: String,
//                          language: String) {
//        if let path = Bundle.main.path(forResource: language,
//                                       ofType: "lproj"),
//           let bundle = Bundle(path: path) {
//            self.text = NSLocalizedString(text,
//                                       bundle: bundle,
//                                       comment: "")
//        }
//    }
//}
