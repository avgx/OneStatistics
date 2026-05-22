import Testing
import Foundation
import CCTVThings
@testable import OneStatistics

@Test("Parsing H264 HD video stream")
func parseH264HDVideoStream() throws {
    // Real `/statistics` sample (1280×720, ~20 fps): bitrate is bytes/s, not bits/s.
    // 1_085_025 B/s ≈ 1060 kB/s ≈ 8.5 Mbit/s — comparable to VLC demux/input after ×8.
    let json = """
    {
        "hosts/camera1": {
            "bitrate": 1085025,
            "fps": 19.899177551269531,
            "width": 1280,
            "height": 720,
            "mediaType": 2,
            "streamType": 875967048
        }
    }
    """
    
    let data = json.data(using: .utf8)!
    let response = try JSONDecoder().decode(StreamStatisticResponse.self, from: data)
    
    #expect(response.streams.count == 1)
    let stream = response.streams["hosts/camera1"]!
    
    #expect(stream.bitrate == 1_085_025)
    #expect(Int(stream.fps) == Int(19.899177551269531))
    #expect(stream.resolution == Resolution(width: 1280, height: 720))
    #expect(stream.mediaType.value == .video)
    #expect(stream.streamType == .h264)
    #expect(stream.isValidVideo)
    #expect(stream.resolution.naturalAspectRatio == ._16x9)
    let expectedBitrate = ByteCountFormatStyle(allowedUnits: [.kb, .mb, .gb])
        .format(Int64(stream.bitrate)) + "/s"
    #expect(stream.bitrateDescription == expectedBitrate)
}
