import Foundation
import Capacitor
import ZIPFoundation
import Path
import CoreML

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CapCoreMLPlugin)
@available(iOS 16.2, macOS 13.1, *)
public class CapCoreMLPlugin: CAPPlugin, FileDownloaderDelegate {
    var downloader: FileDownloader?
    let modelsDirName = "models"
    var downloadProgress: Double { downloader!.progress || 0.0 }

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
        call.get
        let url = "https://huggingface.co/coreml/coreml-stable-diffusion-2-1-base/resolve/main/split_einsum/stable-diffusion-v2.1-base_no-i2i_split-einsum.zip"

        downloader = FileDownloader(url: url, modelsDirName: modelsDirName)
        downloader!.delegate = self
        downloader!.startDownloading()
        call.resolve([
            "value": "queue"
        ])
    }

    @objc func unzip(_ call: CAPPluginCall) {
        let url = "https://huggingface.co/coreml/coreml-stable-diffusion-2-1-base/resolve/main/split_einsum/stable-diffusion-v2.1-base_no-i2i_split-einsum.zip"
        downloader = FileDownloader(url: url, modelsDirName: modelsDirName)
        downloader!.delegate = self
        downloader!.unzip()
        call.resolve([
            "value": "unzip"
        ])
    }

    @objc func generateTextToImage(_ call: CAPPluginCall) {
        do {
            let beginDate = Date()
            let pipelineConfig = MLModelConfiguration()
            pipelineConfig.allowLowPrecisionAccumulationOnGPU = true
            pipelineConfig.computeUnits = .cpuAndGPU
            pipelineConfig.preferredMetalDevice = .none
            let pipeline = try StableDiffusionPipeline(resourcesAt: (Path.documents / "models/stable-diffusion-v2.1-base_split-einsum_compiled").url,
                                                       configuration: pipelineConfig,
                                                       reduceMemory: true)
            print("Pipeline loaded in \(Date().timeIntervalSince(beginDate))")
            print("Generating...")
            var configuration = StableDiffusionPipeline.Configuration(prompt: "a photo of car")
            configuration.stepCount = 3
            configuration.schedulerType = .pndmScheduler
            configuration.guidanceScale = 3
            let images = try pipeline.generateImages(configuration: configuration) {progress in
                print(progress.step)
                print(progress.step / progress.stepCount)
                return true
            }
            let interval = Date().timeIntervalSince(beginDate)
            print("Got images: \(images) in \(interval)")
            let image = images.compactMap({ $0 }).first
            var imageStr = ""
            if let imageData = image {
                let uiImage = UIImage(cgImage: imageData)
                if let uiImageData = uiImage.jpegData(compressionQuality: 1.0) {
                    imageStr = uiImageData.base64EncodedString()
                }
            }
            print(imageStr)
            call.resolve([
                "value": imageStr
            ])
        } catch {
            print(error)
            call.resolve([
                "value": "unloaded"
            ])
        }
    }
}
