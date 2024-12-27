//
//  NetworkProtocol.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit

protocol NetworkServiceProtocol {
    func scriptRequest(text: String) async throws -> ScriptData
    func postGenegateVideo(title: String,
                           type: GenerationType) async throws -> ResponseData
    func getPreviewVideo(url: String,
                         completion: @escaping (UIImage?) -> Void)
    func downloadVideo(_ url: URL,
                       completion: @escaping (URL?) -> Void)
    func requestExampVideo() async throws -> [ExampModel]
    func loadrTextToImage(id: String,
                          delegate: RequestStatusDelegate?) async throws -> TextToImageResponse?
    func requestImageToVideoStatus(model: TextToVideoData,
                                   type: RequestType) async throws -> TextToImageStatus? 
}
