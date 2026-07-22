import Foundation

/// Response from `GET /statistics/webserver` (Next / One).
public struct WebserverStatistics: Codable, Equatable, Sendable {
    /// Server clock as UTC string (format used by the VMS webserver).
    public let now: String
    public let requests: Int
    public let requestsPerSecond: Int
    public let bytesOut: Int
    public let bytesOutPerSecond: Int
    public let streams: Int
    /// Process uptime in seconds.
    public let uptime: Int

    public init(
        now: String,
        requests: Int,
        requestsPerSecond: Int,
        bytesOut: Int,
        bytesOutPerSecond: Int,
        streams: Int,
        uptime: Int
    ) {
        self.now = now
        self.requests = requests
        self.requestsPerSecond = requestsPerSecond
        self.bytesOut = bytesOut
        self.bytesOutPerSecond = bytesOutPerSecond
        self.streams = streams
        self.uptime = uptime
    }

    /// Megabytes out per second (compact formatting helper).
    public var megabytesOutPerSecond: Double {
        Double(bytesOutPerSecond) / (1024 * 1024)
    }

    /// Total bytes out in gigabytes.
    public var gigabytesOut: Double {
        Double(bytesOut) / (1024 * 1024 * 1024)
    }
}
