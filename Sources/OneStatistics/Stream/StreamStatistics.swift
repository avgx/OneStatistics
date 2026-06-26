import Foundation
import SafeEnum
import CCTVThings

/// Statistics for a single video or audio stream.
public struct StreamStatistics: Codable, Equatable, Sendable {
    /// Throughput from `/statistics` in **bytes per second** (B/s).
    public let bitrate: Double
    public let fps: Double
    public let width: Int
    public let height: Int
    public let mediaType: SafeEnum<MediaType>
    /// Codec FourCC.
    public let streamType: FourCC

    /// Megabits per second (Mbit/s): `bitrate * 8 / 1_000_000`.
    ///
    /// Comparable to demux/input bitrates in VLC and similar tools.
    public var bitrateMbps: Double { bitrate * 8 / 1_000_000 }

    /// Statistics panel display scale: `bitrate / 1_000_000`.
    ///
    /// Matches web UI labels such as ``1.14Mbps`` when ``bitrate`` is `1_138_507`. Not Mbit/s.
    public var bitrateAsInWebClient: Double { bitrate / 1_000_000 }

    public var resolution: Resolution {
        Resolution(width: width, height: height)
    }

    public var isValidVideo: Bool {
        width != 0 && height != 0 && mediaType.value == .video
    }

    public var fourCC: String { streamType.string }
}

extension StreamStatistics: CustomStringConvertible {
    public var description: String {
        let style = FloatingPointFormatStyle<Double>.number
            .locale(Locale(identifier: "en_US_POSIX"))
            .precision(.significantDigits(3))
        let bitrateFixed = bitrateMbps.formatted(style)
        let fpsFixed = fps.formatted(style)
        return "\(fourCC) \(resolution) \(fpsFixed)f/s \(bitrateFixed)Mb/s"
    }
}
