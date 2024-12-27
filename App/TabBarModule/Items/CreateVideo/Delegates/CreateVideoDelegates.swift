//
//  CreateVideoProtocols.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 17.10.2024.
//

import Foundation

protocol RequestStatusDelegate: AnyObject {
    func getStatus(value: Int?)
}

protocol RequestDelegate: AnyObject {
    func getResultTextToVideo(_ data: TextToImageResponse?)
    func getResultVideoToVideo()
    func getResult(data: ResponseData?)
    func getAIText(data: ScriptData?)
    
    func error()
}

protocol ParametersDelegate: AnyObject {
    func setRatio(value: String)
    func setDuration(value: String, duration: DurationGenerate)
    func setModel(model: ModelsToCreate)
    
    func defaultArrow()
}

protocol PluginDelegate: AnyObject {
    func selectPlugin(_ mode: PluginMode)
    func removePlugin()
    func dataForVideoGeneration(data: BaseData)
}

protocol SelectModelDelgate: AnyObject {
    func selectModel(_ model: ModelsToCreate)
    func isShowView(_ bool: Bool)
}
