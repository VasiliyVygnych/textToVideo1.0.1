//
//  String.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 12.12.2024.
//

import Foundation

extension String {
    func onlyIntValue() -> String {
        return self.filter { $0.isNumber }
    }
}
