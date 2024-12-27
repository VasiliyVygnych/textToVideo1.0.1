////
////  Obserable.swift
////  CreateAIVideo
////
////  Created by Vasiliy Vygnych on 13.12.2024.
////
//
//import Foundation
//
//class Box<T> {
//    var value: T? {
//        didSet {
//            listener?(value)
//        }
//    }
//    init(_ value: T?) {
//        self.value = value
//    }
//    private var listener: ((T?) -> Void)?
//    
//    func bind(_ listener: @escaping (T?) -> Void) {
//        listener(value)
//        self.listener = listener
//    }
//}
//
