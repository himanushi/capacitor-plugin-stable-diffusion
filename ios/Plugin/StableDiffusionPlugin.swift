import Foundation
import Capacitor
import ZIPFoundation
import Path
import CoreML

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(StableDiffusionPlugin)
@available(iOS 16.2, macOS 13.1, *)
public class CapCoreMLPlugin: CAPPlugin, FileDownloaderDelegate {
    var downloader: FileDownloader?
    var downloadProgress: Double { downloader!.progress }

    func downloadDidStart() {}
    func downloadDidFail(withError error: Error) {
        notifyListeners("downloadDidComplete", data: ["state": "fail", "error": error.localizedDescription])
    }
    func downloadDidUpdateProgress(progress: Double) {
        notifyListeners("downloadProgress", data: ["progress": progress])
    }
    func downloadDidComplete(withURL url: URL) {
        notifyListeners("downloadDidComplete", data: ["state": "completed"])
    }

    @objc func echo(_ call: CAPPluginCall) {
        call.resolve([
            "value": "echo"
        ])
    }

    @objc func download(_ call: CAPPluginCall) {
        let url = call.getString("url")!
        let modelsDirName = call.getString("modelsDirName")!
        downloader = FileDownloader(url: url, modelsDirName: modelsDirName)
        downloader!.delegate = self
        downloader!.startDownloading()
        call.resolve()
    }

    @objc func unzip(_ call: CAPPluginCall) {
        call.resolve()
        let url = call.getString("url")!
        let modelsDirName = call.getString("modelsDirName")!
        downloader = FileDownloader(url: url, modelsDirName: modelsDirName)
        downloader!.delegate = self
        downloader!.unzip()
        notifyListeners("unzipDidComplete", data: ["state": "completed"])
    }
    
    func saveCGImageAsPNG(image: CGImage, to url: URL) -> Bool {
        let uiImage = UIImage(cgImage: image)
        guard let data = uiImage.pngData() else {
            return false
        }
        do {
            try data.write(to: url)
            return true
        } catch {
            print("Failed to save CGImage as PNG: \(error.localizedDescription)")
            return false
        }
    }

    @objc func generateTextToImage(_ call: CAPPluginCall) {
        call.resolve()
        let resourcesAt = (Path.documents / call.getString("modelPath")!).url
        let savePath = call.getString("savePath")!
        let seed = UInt32(call.getInt("seed")!)
        let prompt = call.getString("prompt")!
        do {
            let beginDate = Date()
            let pipelineConfig = MLModelConfiguration()
            pipelineConfig.allowLowPrecisionAccumulationOnGPU = true
            pipelineConfig.computeUnits = .cpuAndGPU
            pipelineConfig.preferredMetalDevice = .none
            let pipeline = try StableDiffusionPipeline(resourcesAt: resourcesAt,
                                                       configuration: pipelineConfig,
                                                       reduceMemory: true)
            var configuration = StableDiffusionPipeline.Configuration(prompt: prompt)
            configuration.stepCount = 3
            configuration.schedulerType = .pndmScheduler
            configuration.guidanceScale = 3
            configuration.seed = seed
            let images = try pipeline.generateImages(configuration: configuration) {progress in
                notifyListeners("generateProgress",data: ["progress": Double(progress.step) / Double(progress.stepCount)])
                return true
            }
            notifyListeners("generateProgress", data: ["progress": 1.0])
            let interval = Date().timeIntervalSince(beginDate)
            let image = images.compactMap({ $0 }).first
            if let imageData = image {
                let result = saveCGImageAsPNG(image: imageData, to: (Path.documents / savePath).url)
                if result {
                    notifyListeners(
                        "generateDidComplete",
                        data: [
                            "state": "completed",
                            "filePath": (Path.documents / savePath).string
                        ]
                    )
                    return
                }
            }

            notifyListeners(
                "generateDidComplete",
                data: [
                    "state": "fail",
                    "error": "画像保存失敗"
                ]
            )
        } catch {
            notifyListeners(
                "generateDidComplete",
                data: [
                    "state": "fail",
                    "error": error.localizedDescription
                ]
            )
        }
    }
}
