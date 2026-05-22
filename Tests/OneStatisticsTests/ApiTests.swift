import Testing
import Foundation
@testable import OneStatistics

@Test func getStripsHostsPrefix() {
    let id = "hosts/Demoserver/DeviceIpint.7/SourceEndpoint.video:0:0"
    let request = StatisticsApi.statistics(for: id)
    #expect(request.method == .get)
    #expect(request.path == "statistics/Demoserver/DeviceIpint.7/SourceEndpoint.video:0:0")
}

@Test func getKeepsLegacyPath() {
    let id = "Demoserver/DeviceIpint.7/SourceEndpoint.video:0:0"
    let request = StatisticsApi.statistics(for: id)
    #expect(request.path == "statistics/Demoserver/DeviceIpint.7/SourceEndpoint.video:0:0")
}

@Test func postAddsHostsPrefixWithoutEscapedSlashes() throws {
    let request = StatisticsApi.statistics(for: ["Demoserver/DeviceIpint.7/SourceEndpoint.video:0:0"])
    #expect(request.method == .post)
    #expect(request.path == "statistics")

    let body = try #require(request.body as? Data)
    let json = try #require(String(data: body, encoding: .utf8))
    #expect(json.contains("hosts/Demoserver/DeviceIpint.7/SourceEndpoint.video:0:0"))
    #expect(!json.contains("\\/"))
}

@Test func postAccepts200AccessPoints() {
    let ids = (0..<200).map { "hosts/Demoserver/DeviceIpint.\($0)/SourceEndpoint.video:0:0" }
    let request = StatisticsApi.statistics(for: ids)
    #expect(request.method == .post)
}
