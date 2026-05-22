import Foundation

/// Media stream type.
public enum MediaType: Int, Codable, Equatable, Sendable {
    case video = 2
    case audio = 3
}