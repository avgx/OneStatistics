import Foundation

/// Response of `POST /statistics`: stream statistics keyed by access point.
public struct StreamStatisticResponse: Decodable, Sendable {
    public let streams: [AccessPoint: StreamStatistics]

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let decoded = try container.decode([AccessPoint: StreamStatistics?].self)
            self.streams = decoded
                .filter { $0.value?.isValidVideo ?? false }
                .reduce(into: [:]) { result, entry in
                    result[entry.key] = entry.value!
                }
        } catch {
            streams = [:]
        }
    }
}
