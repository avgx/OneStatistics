# OneStatistics

Swift package for VMS **statistics** APIs (`/statistics`, `/statistics/webserver`).

**Platforms:** iOS 15+, macOS 13+, tvOS 18+, watchOS 9+, visionOS 1+  
**Swift tools:** 6.1+

## Dependencies

| Package | Role |
|---------|------|
| [RequestResponse](https://github.com/avgx/RequestResponse) | `StatisticsApi` returns `Request<…>` |
| [CCTVThings](https://github.com/avgx/CCTVThings) | `FourCC`, `Resolution` |
| [SafeEnum](https://github.com/avgx/SafeEnum) | Tolerant `mediaType` decoding |

## Module layout

```
Sources/OneStatistics/
├── API/           StatisticsApi, AccessPoint
├── Stream/        StreamStatistics, StreamStatisticResponse, MediaType
└── Webserver/     WebserverStatistics
```

## API

| Method | HTTP | Response |
|--------|------|----------|
| `StatisticsApi.statistics(for id:)` | `GET /statistics/{accessPoint}` | `StreamStatistics` |
| `StatisticsApi.statistics(for ids:)` | `POST /statistics` | `StreamStatisticResponse` |
| `StatisticsApi.webserver()` | `GET /statistics/webserver` | `WebserverStatistics` |

- **GET (legacy):** `hosts/` prefix is stripped from the path automatically.
- **POST (recommended):** `hosts/` prefix is added to each access point when missing.
- **Batch limit:** at most **~200** access points per POST; larger lists must be split on the client.

### Chunking large lists

Chunking is not implemented in the package — add a helper in your app and merge `StreamStatisticResponse.streams`:

```swift
extension Array {
    func chunked(into chunkSize: Int) -> [[Element]] {
        guard chunkSize > 0 else { return [] }
        return stride(from: 0, to: count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, count)])
        }
    }
}

var merged: [AccessPoint: StreamStatistics] = [:]
for chunk in allIds.chunked(into: 200) {
    let request = StatisticsApi.statistics(for: chunk)
    // execute request, then:
    // merged.merge(response.streams) { _, new in new }
}
```

## Bitrate

| Property | Meaning |
|----------|---------|
| `StreamStatistics.bitrate` | **Bytes per second** (B/s) — raw value from `/statistics` |
| `StreamStatistics.bitrateMbps` | **Megabits per second** (Mbit/s): `bitrate * 8 / 1_000_000` — comparable to VLC demux/input |
| `StreamStatistics.bitrateAsInWebClient` | Web UI scale: `bitrate / 1_000_000` (panel labels like `1.14Mbps`) |
