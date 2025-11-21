import Foundation

class PersistenceCoordinator {
    static let quintessential = PersistenceCoordinator()

    private let archiveFilenameDesignation = "deliberations_archive.json"
    private var archiveURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(archiveFilenameDesignation)
    }

    private init() {}

    func perpetuateDeliberations(_ deliberations: [Deliberation]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let transmutedData = try encoder.encode(deliberations)
        try transmutedData.write(to: archiveURL, options: [.atomic])
    }

    func recuperateDeliberations() throws -> [Deliberation] {
        guard FileManager.default.fileExists(atPath: archiveURL.path) else {
            return []
        }

        let transmutedData = try Data(contentsOf: archiveURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Deliberation].self, from: transmutedData)
    }

    func obliterateAllDeliberations() throws {
        if FileManager.default.fileExists(atPath: archiveURL.path) {
            try FileManager.default.removeItem(at: archiveURL)
        }
    }
}
