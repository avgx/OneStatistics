import Testing
import Foundation
import CCTVThings
@testable import OneStatistics

@Test func decodeStreamStatisticsBitrateMegabitsPerSecond() throws {
    // 1280×720 H.264: bitrate is B/s; Mbit/s ≈ VLC demux/input (×8).
    let json = """
    {
        "bitrate": 1085025,
        "fps": 19.899177551269531,
        "height": 720,
        "mediaType": 2,
        "streamType": 875967048,
        "width": 1280
    }
    """
    let stream = try JSONDecoder().decode(StreamStatistics.self, from: Data(json.utf8))

    #expect(stream.bitrate == 1_085_025)
    #expect(stream.bitrateMbps == 1_085_025.0 * 8 / 1_000_000)
    #expect(stream.bitrateMbps > 8.5)
    #expect(stream.bitrateMbps < 8.9)
    #expect(stream.bitrateAsInWebClient == 1_085_025.0 / 1_000_000)
    #expect(stream.resolution == .hd)
}

@Test func decodeStreamStatisticsFromLegacyGet() throws {
    let json = """
    {
        "bitrate": 1138507,
        "fps": 24.997659683227539,
        "height": 576,
        "mediaType": 2,
        "streamType": 875967048,
        "width": 768
    }
    """
    let stream = try JSONDecoder().decode(StreamStatistics.self, from: Data(json.utf8))

    #expect(stream.bitrate == 1_138_507)
    #expect(stream.bitrateMbps == 1_138_507.0 * 8 / 1_000_000)
    #expect(stream.bitrateAsInWebClient == 1_138_507.0 / 1_000_000)
    #expect(stream.resolution == Resolution(width: 768, height: 576))
    #expect(stream.resolution != .d1Pal)
    #expect(stream.resolution != .fourCifPal)
    #expect(stream.mediaType.value == .video)
    #expect(stream.streamType == .h264)
    #expect(stream.description == "H264 768x576 \(stream.fps)f/s \(stream.bitrateMbps)Mb/s")
}

@Test func decodeDualStreamPostResponse() throws {
    let json = """
    {
        "hosts/Demoserver/DeviceIpint.4/SourceEndpoint.video:0:0": {
            "bitrate": 2616928,
            "fps": 16.02906608581543,
            "height": 1080,
            "mediaType": 2,
            "streamType": 875967048,
            "width": 1920
        },
        "hosts/Demoserver/DeviceIpint.4/SourceEndpoint.video:0:1": {
            "bitrate": 226386,
            "fps": 29.950273513793945,
            "height": 360,
            "mediaType": 2,
            "streamType": 877088845,
            "width": 640
        }
    }
    """
    let response = try JSONDecoder().decode(StreamStatisticResponse.self, from: Data(json.utf8))

    #expect(response.streams.count == 2)
    let main = response.streams["hosts/Demoserver/DeviceIpint.4/SourceEndpoint.video:0:0"]
    let sub = response.streams["hosts/Demoserver/DeviceIpint.4/SourceEndpoint.video:0:1"]
    #expect(main?.resolution == .fullHd)
    #expect(main?.bitrateAsInWebClient == 2_616_928.0 / 1_000_000)
    #expect(sub?.resolution == Resolution(width: 640, height: 360))
    #expect(sub?.resolution != .hd)
    #expect(sub?.bitrateAsInWebClient == 226_386.0 / 1_000_000)
}

@Test func filtersInvalidStreams() throws {
    let json = """
    {
        "hosts/camera1": {
            "bitrate": 2048,
            "fps": 30,
            "width": 1920,
            "height": 1080,
            "mediaType": 2,
            "streamType": 875967048
        },
        "hosts/camera2": null,
        "hosts/camera3": {
            "bitrate": 128,
            "fps": 0,
            "width": 0,
            "height": 0,
            "mediaType": 3,
            "streamType": 0
        }
    }
    """
    let response = try JSONDecoder().decode(StreamStatisticResponse.self, from: Data(json.utf8))

    #expect(response.streams.count == 1)
    #expect(response.streams["hosts/camera1"]?.resolution == .fullHd)
}

@Test func decodeEmptyResponse() throws {
    let response = try JSONDecoder().decode(StreamStatisticResponse.self, from: Data("{}".utf8))
    #expect(response.streams.isEmpty)
}

@Test func decodeInvalidJSONReturnsEmptyStreams() throws {
    let response = try JSONDecoder().decode(StreamStatisticResponse.self, from: Data("[\"invalid\"]".utf8))
    #expect(response.streams.isEmpty)
}
