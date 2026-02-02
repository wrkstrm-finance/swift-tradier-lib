// Overview: NIO ChannelInboundHandler for WebSocket frames.
// Delegates text/binary/close events to callbacks used by TradierEventsClient.
import Foundation
import NIO
import NIOWebSocket

final class WSInbound: ChannelInboundHandler, @unchecked Sendable {
  typealias InboundIn = WebSocketFrame
  private let onText: @Sendable (String) -> Void
  private let onBinary: @Sendable (ByteBuffer) -> Void
  private let onClose: @Sendable (Error?) -> Void

  init(
    onText: @escaping @Sendable (String) -> Void,
    onBinary: @escaping @Sendable (ByteBuffer) -> Void,
    onClose: @escaping @Sendable (Error?) -> Void,
  ) {
    self.onText = onText
    self.onBinary = onBinary
    self.onClose = onClose
  }

  func channelRead(context: ChannelHandlerContext, data: NIOAny) {
    let frame: WebSocketFrame = unwrapInboundIn(data)
    switch frame.opcode {
    case .text:
      var buffer: ByteBuffer = frame.unmaskedData
      if let text: String = buffer.readString(length: buffer.readableBytes) {
        onText(text)
      }

    case .binary:
      onBinary(frame.unmaskedData)

    case .ping:
      let pong = WebSocketFrame(
        opcode: .pong,
        data: context.channel.allocator.buffer(capacity: 0),
      )
      context.writeAndFlush(NIOAny(pong), promise: nil)

    case .connectionClose:
      onClose(nil)
      context.close(promise: nil)

    default:
      break
    }
  }

  func errorCaught(context: ChannelHandlerContext, error: Error) {
    onClose(error)
    context.close(promise: nil)
  }
}
