//
//  FileDownloader.swift
//  Plugin
//
//  Created by himanushi on 2023/02/27.
//  Copyright © 2023 Max Lynch. All rights reserved.
//  ref:
//

import Foundation
import Path
import ZIPFoundation

protocol FileDownloaderDelegate: AnyObject {
    func downloadDidStart()
    func downloadDidComplete(withURL url: URL)
    func downloadDidFail(withError error: Error)
    func downloadDidUpdateProgress(progress: Double)
}

class FileDownloader: NSObject, ObservableObject {
    
    private var downloadTask: URLSessionDownloadTask?
    private var resumeData: Data?
    private var downloadURL: URL
    private var downloadedPath: Path
    private var savePath: Path
    
    weak var delegate: FileDownloaderDelegate?
    
    var isDownloading: Bool {
        return downloadTask != nil
    }
    
    var progress: Double = 0.0 {
        didSet {
            delegate?.downloadDidUpdateProgress(progress: progress)
        }
    }
    
    init(url: String, modelsDirName: String) {
        downloadURL = URL(string: url)!
        savePath = Path.documents / modelsDirName
        downloadedPath = savePath / downloadURL.lastPathComponent
    }
    
    func startDownloading() {
        cancelDownloading()
        delegate?.downloadDidStart()
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        let downloadRequest = URLRequest(url: downloadURL)
        downloadTask = session.downloadTask(with: downloadRequest)
        downloadTask?.resume()
    }
    
    func pauseDownloading() {
        downloadTask?.cancel(byProducingResumeData: { resumeData in
            self.resumeData = resumeData
        })
        downloadTask = nil
    }
    
    func resumeDownloading() {
        guard let resumeData = resumeData else { return }
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        downloadTask = session.downloadTask(withResumeData: resumeData)
        downloadTask?.resume()
        self.resumeData = nil
    }
    
    func cancelDownloading() {
        downloadTask?.cancel()
        downloadTask = nil
        resumeData = nil
    }
    
    func unzip() {
        do {
            try FileManager().unzipItem(at: downloadedPath.url, to: savePath.url)
            try FileManager.default.removeItem(at: downloadedPath.url)
        } catch {
            // Cleanup
            let fileName = downloadedPath.url.lastPathComponent
            let unzipDir = savePath / (fileName as NSString).deletingPathExtension
            do { try FileManager.default.removeItem(at: unzipDir.url) } catch {}
        }

        do {
            // 不要ファイル
            try FileManager.default.removeItem(at: (savePath / "__MACOSX").url)
        } catch {}
    }
}

extension FileDownloader: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            try FileManager.default.moveItem(at: location, to: downloadedPath.url)
            delegate?.downloadDidComplete(withURL: downloadedPath.url)
        } catch {
            delegate?.downloadDidFail(withError: error)
        }
        self.downloadTask = nil
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            delegate?.downloadDidFail(withError: error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
    }
}
