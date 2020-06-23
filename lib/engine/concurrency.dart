import 'dart:async';
import 'dart:isolate';

typedef IsolateEnvironmentEntryPoint(SendPort sendPort, ReceivePort receivePort);

class IsolateEnvironment {

  Isolate isolate;
  ReceivePort receivePort;
  SendPort sendPort;

  IsolateEnvironment._(this.isolate, this.receivePort, this.sendPort);

  static Future<IsolateEnvironment> spawn(IsolateEnvironmentEntryPoint entryPoint) async {
    var completer = Completer<IsolateEnvironment>();
    var isolateReceivePort = ReceivePort();
    var envReceivePort = ReceivePort();

    Isolate isolate;

    isolateReceivePort.listen((msg) {
      if (msg is SendPort) {
        completer.complete(IsolateEnvironment._(isolate, envReceivePort, msg));
      } else {
        envReceivePort.sendPort.send(msg);
      }
    });

    var args = [entryPoint, isolateReceivePort.sendPort];
    isolate = await Isolate.spawn(isolateEntryPoint, args);
    return completer.future;
  }

  static void isolateEntryPoint(List args) {
    IsolateEnvironmentEntryPoint entryPoint = args[0];
    SendPort sendPort = args[1];

    var receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    entryPoint(sendPort, receivePort);
  }
}