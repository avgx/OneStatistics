import Foundation

/// Media stream type (internal product enum: 2 — video, 3 — audio).
public enum MediaType: Int, Codable, Equatable, Sendable {
    case video = 2
    case audio = 3
}
