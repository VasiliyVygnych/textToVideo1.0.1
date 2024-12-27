//
//  Extension.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 30.10.2024.
//

import UIKit

extension IndexPath {
    func convertToArray() -> [Int] {
        return [self.section, self.row]
    }
    
    init?(from array: [Int]) {
        guard array.count == 2 else { return nil }
        self.init(row: array[1], section: array[0])
    }
}
