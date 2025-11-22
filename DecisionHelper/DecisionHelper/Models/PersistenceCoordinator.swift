import Foundation

// Refactored implementation - different file access patterns
class PersistenceCoordinator {
    static let quintessential = PersistenceCoordinator()

    private let archiveFilenameDesignation = "deliberations_archive.json"

    // Refactored: Computed property with different directory access pattern
    private var archiveURL: URL {
        // New logic: Multi-step directory retrieval
        let fileManager = FileManager.default
        let directories = fileManager.urls(for: .documentDirectory, in: .userDomainMask)

        guard let documentDirectory = directories.first else {
            fatalError("Unable to access document directory")
        }

        let filePath = documentDirectory.appendingPathComponent(archiveFilenameDesignation)
        return filePath
    }

    private init() {}

    // Refactored: Using different encoding workflow
    func perpetuateDeliberations(_ deliberations: [Deliberation]) throws {
        // New logic: Step-by-step encoding process
        let encoder = JSONEncoder()

        // Configure encoder separately
        let strategy = JSONEncoder.DateEncodingStrategy.iso8601
        encoder.dateEncodingStrategy = strategy

        // Encode data
        let encodedBytes = try encoder.encode(deliberations)

        // Write with explicit options
        let writeOptions: Data.WritingOptions = [.atomic]
        let targetURL = archiveURL

        try encodedBytes.write(to: targetURL, options: writeOptions)
    }

    // Refactored: Using manual existence check and different decoding pattern
    func recuperateDeliberations() throws -> [Deliberation] {
        // New logic: Manual file existence verification
        let fileManager = FileManager.default
        let targetPath = archiveURL.path
        let fileExists = fileManager.fileExists(atPath: targetPath)

        guard fileExists else {
            let emptyArray: [Deliberation] = []
            return emptyArray
        }

        // New logic: Step-by-step decoding
        let fileURL = archiveURL
        let rawBytes = try Data(contentsOf: fileURL)

        let decoder = JSONDecoder()
        let strategy = JSONDecoder.DateDecodingStrategy.iso8601
        decoder.dateDecodingStrategy = strategy

        let decodedItems = try decoder.decode([Deliberation].self, from: rawBytes)
        return decodedItems
    }

    // Refactored: Different deletion verification pattern
    func obliterateAllDeliberations() throws {
        // New logic: Explicit file manager usage
        let fileManager = FileManager.default
        let targetPath = archiveURL.path

        // Check existence first
        let doesExist = fileManager.fileExists(atPath: targetPath)

        if doesExist {
            let fileURL = archiveURL
            try fileManager.removeItem(at: fileURL)
        }
    }
}
