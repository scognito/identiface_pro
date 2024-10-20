import 'dart:async';

class EventBus {
  final _streamController = StreamController<EventBusEvent>.broadcast();

  Stream<EventBusEvent> on() {
    return _streamController.stream;
  }

  void fire(EventBusEvent event) {
    _streamController.add(event);
  }

  void dispose() {
    _streamController.close();
  }
}

enum EventBusEvent { cameraSwitch, startCameraStream, stopCameraStream }
