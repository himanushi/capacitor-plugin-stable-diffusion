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
    func downloadDidFail(withError error: Error) { print("downloadDidFail", error) }
    func downloadDidUpdateProgress(progress: Double) {
        
    }
    func downloadDidComplete(withURL url: URL) {
        
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
        let url = call.getString("url")!
        let modelsDirName = call.getString("modelsDirName")!
        downloader = FileDownloader(url: url, modelsDirName: modelsDirName)
        downloader!.delegate = self
        downloader!.unzip()
        call.resolve()
    }

    @objc func generateTextToImage(_ call: CAPPluginCall) {
        call.resolve()
        // "models/stable-diffusion-v2.1-base_split-einsum_compiled"
        let resourcesAt = (Path.documents / call.getString("url")!).url
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
            print("Generating...")
            var configuration = StableDiffusionPipeline.Configuration(prompt: prompt)
            configuration.stepCount = 3
            configuration.schedulerType = .pndmScheduler
            configuration.guidanceScale = 3
            let images = try pipeline.generateImages(configuration: configuration)
            let interval = Date().timeIntervalSince(beginDate)
            let image = images.compactMap({ $0 }).first
            var imageStr: String? = nil
            if let imageData = image {
                let uiImage = UIImage(cgImage: imageData)
                if let uiImageData = uiImage.jpegData(compressionQuality: 1.0) {
                    imageStr = uiImageData.base64EncodedString()
                }
            }
            print(imageStr)
        } catch {
            print(error)
        }
    }
}
