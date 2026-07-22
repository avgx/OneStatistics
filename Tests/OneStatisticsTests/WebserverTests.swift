import Testing
import Foundation
@testable import OneStatistics

@Test func webserverRequestPath() {
    let request = StatisticsApi.webserver()
    #expect(request.method == .get)
    #expect(request.path == "statistics/webserver")
}

@Test func webserverStatisticsDecoding() throws {
    let json = """
    {
      "now": "2024-03-13T12:00:00",
      "requests": 100,
      "requestsPerSecond": 2,
      "bytesOut": 1073741824,
      "bytesOutPerSecond": 1048576,
      "streams": 5,
      "uptime": 3600
    }
    """
    let data = try #require(json.data(using: .utf8))
    let decoded = try JSONDecoder().decode(WebserverStatistics.self, from: data)
    #expect(decoded.now == "2024-03-13T12:00:00")
    #expect(decoded.requests == 100)
    #expect(decoded.requestsPerSecond == 2)
    #expect(decoded.bytesOut == 1_073_741_824)
    #expect(decoded.bytesOutPerSecond == 1_048_576)
    #expect(decoded.streams == 5)
    #expect(decoded.uptime == 3600)
    #expect(decoded.megabytesOutPerSecond == 1)
    #expect(decoded.gigabytesOut == 1)
}
