import Foundation
import SafeEnum
import CCTVThings

/// Statistics for a single stream.
///
/// - `streamType`: FourCC.
/// - `mediaType`: internal product enum (2 — video, 3 — audio).
/// - `resolution`: Standard video resolution (QCIF, CIF, HD, 4K, etc.).
public struct StatisticsStream: Codable, Equatable, Sendable {
    /// Throughput in **bytes per second** (B/s), as returned by `/statistics`.
    /// Display divides by 1024 for kBps / MBps (binary), matching legacy iOS and server samples (~1_085_025 for 720p H.264).
    public let bitrate: Double
    public let fps: Double
    public let width: Int
    public let height: Int
    //mediaType - внутренний enum продукта. 2 - видео, 3 - аудио
    public let mediaType: SafeEnum<MediaType>
    //streamType - это FourCC
    public let streamType: FourCC

    public var resolution: Resolution {
        Resolution(width: width, height: height)
    }

    public var isValidVideo: Bool {
        width != 0 && height != 0 && mediaType.value == .video
    }
}

public extension StatisticsStream {
    enum DescriptionStyle: Sendable {
        case bitrateOnly
        case fourCCAndBitrate
        case fourCCResolutionAndBitrate
        case full
    }

    var fourCC: String { streamType.string }
    var isH26X: Bool { fourCC == "H264" || fourCC == "H265" }
    var isMpeg4: Bool { fourCC == "MPG4" }

    private static let bitrateFormat = ByteCountFormatStyle(allowedUnits: [.kb, .mb, .gb])

    var bitrateDescription: String {
        Self.bitrateFormat.format(Int64(bitrate)) + "/s"
    }

    var resolutionDescription: String {
        if mediaType.value == .video && isValidVideo {
            return "\(resolution)"
        }
        return "N/A"
    }

    var fpsDescription: String {
        String(format: "%.1f fps", fps)
    }

    func formattedDescription(style: DescriptionStyle = .full) -> String {
        switch style {
        case .bitrateOnly:
            return bitrateDescription

        case .fourCCAndBitrate:
            return "\(fourCC) \(bitrateDescription)"

        case .fourCCResolutionAndBitrate:
            return "\(fourCC) \(resolutionDescription) \(bitrateDescription)"

        case .full:            
            return "\(fourCC) \(resolutionDescription) \(fpsDescription) \(bitrateDescription)"
        }
    }
}

extension StatisticsStream: CustomStringConvertible {
    public var description: String { formattedDescription(style: .full) }
    public var debugDescription: String { description }
}
