//
//  ImageCacheManager.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 04/09/25.
//

import SwiftUI
import Foundation

@MainActor
class ImageCacheManager: ObservableObject {
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
        
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        cacheDirectory = documentsPath.appendingPathComponent("ImageCache")
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
        
        cleanupOldCache()
    }
    
    // MARK: - Public Methods
    
    func getImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        if let diskImage = loadImageFromDisk(urlString: urlString) {
            cache.setObject(diskImage, forKey: cacheKey)
            return diskImage
        }
        
        return await downloadAndCacheImage(from: urlString)
    }
    
    func preloadImages(_ urlStrings: [String]) {
        Task {
            for urlString in urlStrings {
                _ = await getImage(from: urlString)
            }
        }
    }
    
    func clearCache() {
        cache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    // MARK: - Private Methods
    
    private func downloadAndCacheImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            
            let cacheKey = NSString(string: urlString)
            
            cache.setObject(image, forKey: cacheKey)
            
            saveImageToDisk(image: image, urlString: urlString)
            
            return image
        } catch {
            print("Failed to download image: \(error)")
            return nil
        }
    }
    
    private func saveImageToDisk(image: UIImage, urlString: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        
        let filename = generateFilename(from: urlString)
        let fileURL = cacheDirectory.appendingPathComponent(filename)
        
        try? data.write(to: fileURL)
    }
    
    private func loadImageFromDisk(urlString: String) -> UIImage? {
        let filename = generateFilename(from: urlString)
        let fileURL = cacheDirectory.appendingPathComponent(filename)
        
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
    
    private func generateFilename(from urlString: String) -> String {
        return urlString.hash.description + ".jpg"
    }
    
    private func cleanupOldCache() {
        guard let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.creationDateKey]) else {
            return
        }
        
        let oneWeekAgo = Date().addingTimeInterval(-7 * 24 * 60 * 60)
        
        for file in files {
            guard let attributes = try? fileManager.attributesOfItem(atPath: file.path),
                  let creationDate = attributes[.creationDate] as? Date else {
                continue
            }
            
            if creationDate < oneWeekAgo {
                try? fileManager.removeItem(at: file)
            }
        }
    }
}

// MARK: - Cached AsyncImage View
struct CachedAsyncImage<Content: View>: View {
    let url: String?
    let content: (Image) -> Content
    let placeholder: () -> Content
    
    @StateObject private var imageLoader = CachedImageLoader()
    
    init(
        url: String?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Content
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                content(Image(uiImage: image))
            } else {
                placeholder()
            }
        }
        .onAppear {
            if let url = url {
                imageLoader.loadImage(from: url)
            }
        }
        .onChange(of: url) { _, newURL in
            if let newURL = newURL {
                imageLoader.loadImage(from: newURL)
            }
        }
    }
}

// MARK: - Image Loader for Individual Images
@MainActor
class CachedImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private var currentURL: String?
    
    func loadImage(from urlString: String) {
        guard currentURL != urlString else { return }
        
        currentURL = urlString
        isLoading = true
        
        Task {
            let loadedImage = await ImageCacheManager.shared.getImage(from: urlString)
            
            if currentURL == urlString {
                self.image = loadedImage
                self.isLoading = false
            }
        }
    }
}
