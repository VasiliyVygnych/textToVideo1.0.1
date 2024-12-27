//
//  NetworkManager.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit
import AVFoundation


class NetworkManager: NetworkServiceProtocol {

    private let urlExamp = "https://tevaapne.fun/api/examples?limit="
    private let urlTextToVideo = "https://tevaapne.fun/api/generate-video"
    private let urlCheckStatus = "https://tevaapne.fun/api/check-status/"
    private let urlGenegateVideo = "https://vastextvideon.fun/api/v1/video/generate"
    private let urlScriptText = "https://vastextvideon.fun/api/v1/textvideo/chatgpt"

    @MainActor
    func requestExampVideo() async throws -> [ExampModel] {
        let limit = 20
        guard let url = URL(string: "\(urlExamp)\(limit)") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        let exampleData = try decoder.decode([ExampModel].self,
                                             from: data)
        return exampleData
    }
    @MainActor
    func requestImageToVideo(requestId: String) async throws -> TextToImageProgress {
        guard let url = URL(string: "\(urlCheckStatus)\(requestId)") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        let exampleData = try decoder.decode(TextToImageProgress.self,
                                             from: data)
        return exampleData
    }
    func requestImageToURL(requestId: String) async throws -> TextToImageResponse {
        guard let url = URL(string: "\(urlCheckStatus)\(requestId)") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        let exampleData = try decoder.decode(TextToImageResponse.self,
                                             from: data)
        return exampleData
    }
    func loadrTextToImage(id: String,
                          delegate: RequestStatusDelegate?) async throws -> TextToImageResponse? {
        while true {
            let response = try await requestImageToVideo(requestId: id)
            delegate?.getStatus(value: response.progress)
            if response.status == "COMPLETED" {
                let data = try await requestImageToURL(requestId: id)
                return data
            }
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2 секунды
        }
    }

    @MainActor
    func scriptRequest(text: String) async throws -> ScriptData {
        guard let url = URL(string: urlScriptText) else {
            throw URLError(.badURL)
        }
        let language = LanguageConstant.appLaunguage
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
                "query": "\(text).",
                "language": language
            ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body,
                                                      options: [])
            request.httpBody = jsonData
        } catch {
            print("Ошибка при кодировании JSON: \(error)")
            throw URLError(.badServerResponse)
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let responseData = try JSONDecoder().decode(ScriptData.self,
                                                    from: data)
        return responseData
    }
    @MainActor
    func postGenegateVideo(title: String,
                           type: GenerationType) async throws -> ResponseData {
        guard let url = URL(string: urlGenegateVideo) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "title": title,
            "tone": "professional",
            "creativity_level": 0.5,
            "format": type.valueType
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body,
                                                      options: [])
            request.httpBody = jsonData
        } catch {
            print("Ошибка при кодировании JSON: \(error)")
            throw URLError(.badServerResponse)
        }
        request.timeoutInterval = 1500
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let responseData = try JSONDecoder().decode(ResponseData.self,
                                                    from: data)
        return responseData
    }
    func getPreviewVideo(url: String,
                         completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else { return }
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 2,
                          preferredTimescale: 600)
        assetImageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, cgImage, _, _, error in
            if let error = error {
                print("Error generating image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let cgImage = cgImage {
                let image = UIImage(cgImage: cgImage)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    func downloadVideo(_ url: URL,
                       completion: @escaping (URL?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            guard let localURL = localURL, error == nil else {
                print("Ошибка при загрузке видео: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                completion(nil)
                return
            }
            let fileManager = FileManager.default
            guard let documentsDirectory = fileManager.urls(for: .documentDirectory,
                                                            in: .userDomainMask).first else { return }
            let destinationURL = documentsDirectory.appendingPathComponent("\(UUID().uuidString).mp4")
            do {
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                try fileManager.moveItem(at: localURL,
                                         to: destinationURL)
                completion(destinationURL)
            } catch {
                print("Ошибка при перемещении файла: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
    @MainActor
    func requestImageToVideoStatus(model: TextToVideoData,
                                   type: RequestType) async throws -> TextToImageStatus? {
        var multipart = MultipartRequestValue()
        if let dataImage = model.image?.jpegData(compressionQuality: 0.9) {
            multipart.addValue(
                key: "image_file",
                fileName: "image.png",
                fileMimeType: "image/png",
                fileData: dataImage
            )
        }
        var version = "standard"
        if let style = model.models {
            switch style {
            case "kling-video":
                version = "pro"
            case "kling-standart":
                version = "standard"
            case "minimax-video":
                version = "pro"
            default:
                break
            }
        }
        multipart.add(key: "model",
                      value: model.models ?? "")
        multipart.add(key: "type",
                      value: type.value)
        multipart.add(key: "version",
                      value: version)
        multipart.add(key: "prompt",
                      value: model.description ?? "")
        multipart.add(key: "duration",
                      value: model.duration?.onlyIntValue() ?? "")
        guard let url = URL(string: urlTextToVideo) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(multipart.httpContentTypeValue,
                         forHTTPHeaderField: "Content-Type")
        request.httpBody = multipart.httpBodyValue
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let _ = String(data: data,
                                       encoding: String.Encoding.utf8) {
            }
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(TextToImageStatus.self,
                                                 from: data)
            return decodedData
        } catch {
            print(error)
        }
        return nil
    }
 }
    extension Data {
    mutating func append(
        _ string: String,
        encoding: String.Encoding = .utf8) {
        guard let data = string.data(using: encoding) else {
            return
        }
        append(data)
    }
 }
    struct MultipartRequestValue {
    public let boundary: String
    private let separator: String = "\r\n"
    private var data: Data
    public init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
        self.data = .init()
    }
    private mutating func appendBoundarySeparatorBody() {
        data.append("--\(boundary)\(separator)")
    }
    private mutating func appendSeparatorBody() {
        data.append(separator)
    }
    private func dispositionValue(_ key: String) -> String {
        "Content-Disposition: form-data; name=\"\(key)\""
    }
     mutating func add(
        key: String,
        value: String
    ) {
        appendBoundarySeparatorBody()
        data.append(dispositionValue(key) + separator)
        appendSeparatorBody()
        data.append(value + separator)
    }
     mutating func addValue(
        key: String,
        fileName: String,
        fileMimeType: String,
        fileData: Data
    ) {
        appendBoundarySeparatorBody()
        data.append(dispositionValue(key) + "; filename=\"\(fileName)\"" + separator)
        data.append("Content-Type: \(fileMimeType)" + separator + separator)
        data.append(fileData)
        appendSeparatorBody()
    }
     var httpContentTypeValue: String {
        "multipart/form-data; boundary=\(boundary)"
    }
     var httpBodyValue: Data {
        var bodyData = data
        bodyData.append("--\(boundary)--")
        return bodyData
    }
}
