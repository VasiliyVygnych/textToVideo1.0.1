//
//  GenModel.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 12.12.2024.
//

import Foundation

struct GenModel {
    let title: String
    let subtitle: String
    let descriptions: String
}
var genModel = [GenModel(title: "Dinson Pro",
                        subtitle: "high detail, long generation".localized(LanguageConstant.appLaunguage),
                         descriptions: "High detail, video generation up to 20 minutes. You can select the time - 5/10 seconds. When choosing image to video, uses a photo / object with a photo, the neural network can move the object / change the photo under the prompt.".localized(LanguageConstant.appLaunguage)),
                GenModel(title: "Dinson Standart",
                         subtitle: "basic detail, fast generation".localized(LanguageConstant.appLaunguage),
                         descriptions: "Basic detail, fast generation, on average up to 5 minutes. When choosing image to video, uses a photo / object with a photo, the neural network can move the object / change the photo under the prompt.".localized(LanguageConstant.appLaunguage)),
                GenModel(title: "Natash",
                         subtitle: "optimal in speed / quality".localized(LanguageConstant.appLaunguage),
                         descriptions: "Optimal in terms of speed/quality. Average generation time is 5 minutes. You cannot select the length of the video - it is always fixed, 6 seconds. When choosing image to video, it “animates” the photo - it starts from the photo, using it as the first frame of the video.".localized(LanguageConstant.appLaunguage))]
