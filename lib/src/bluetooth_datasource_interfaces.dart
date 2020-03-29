part of flutter_blue;

abstract class IBluetoothCharacteristic {
  IBluetoothCharacteristic(
      this.uuid, this.deviceId, this.serviceUuid, this.secondaryServiceUuid, this.properties, this.descriptors, this.characteristicInternalValue);

  final Guid uuid;
  final IDeviceIdentifier deviceId;
  final Guid serviceUuid;
  final Guid secondaryServiceUuid;
  final CharacteristicProperties properties;
  final List<IBluetoothDescriptor> descriptors;

  bool get isNotifying;

  final BehaviorSubject<List<int>> characteristicInternalValue;
  Stream<List<int>> get value;

  List<int> get lastValue;

  Future<List<int>> read();

  Future<Null> write(List<int> value, {bool withoutResponse = false});

  Future<bool> setNotifyValue(bool notify);
}

abstract class IDeviceBluetoothDataSource {
  LogLevel get logLevel;

  Future<bool> get isAvailable;

  Future<bool> get isOn;

  Stream<BluetoothState> get state;

  Future setUniqueId(String uniqueid);

  Future<List<IBluetoothDevice>> get connectedDevices;

  Stream<IScanResult> scan({
    ScanMode scanMode = ScanMode.lowLatency,
    List<Guid> withServices = const [],
    List<Guid> withDevices = const [],
    Duration timeout,
  });

  Future startScan({
    ScanMode scanMode = ScanMode.lowLatency,
    List<Guid> withServices = const [],
    List<Guid> withDevices = const [],
    Duration timeout,
  });

  Future stopScan();
  void setLogLevel(LogLevel level);
}

abstract class IBluetoothDescriptor {
  IBluetoothDescriptor(this.uuid, this.deviceId, this.serviceUuid, this.characteristicUuid, this.descriptorInternalValue);

  static Guid cccd;
  final Guid uuid;
  final IDeviceIdentifier deviceId;
  final Guid serviceUuid;
  final Guid characteristicUuid;

  final BehaviorSubject<List<int>> descriptorInternalValue;
  List<int> get lastValue;
  Stream<List<int>> get value;

  Future<List<int>> read();
  Future<Null> write(List<int> value);
}

abstract class IBluetoothDevice {
  IBluetoothDevice(this.id, this.name, this.type);

  final IDeviceIdentifier id;
  final String name;
  final BluetoothDeviceType type;

  Stream<bool> get isDiscoveringServices;
  Future<void> connect({Duration timeout, bool autoConnect = true});
  Future disconnect();
  Future<List<IBluetoothService>> discoverServices();
  Stream<List<IBluetoothService>> get services;
  Stream<BluetoothDeviceState> get state;
  Stream<int> get mtu;
  Future<void> requestMtu(int desiredMtu);
  Future<bool> get canSendWriteWithoutResponse;
}

abstract class IBluetoothService {
  IBluetoothService(
    this.uuid,
    this.deviceId,
    this.isPrimary,
    this.characteristics,
    this.includedServices,
  );
  final Guid uuid;
  final IDeviceIdentifier deviceId;
  final bool isPrimary;
  final List<IBluetoothCharacteristic> characteristics;
  final List<IBluetoothService> includedServices;
}

abstract class IDeviceIdentifier {
  const IDeviceIdentifier(this.id);
  final String id;
}

abstract class IScanResult {
  const IScanResult({this.device, this.advertisementData, this.rssi});
  final IBluetoothDevice device;
  final IAdvertisementData advertisementData;
  final int rssi;
}

abstract class IAdvertisementData {
  IAdvertisementData({this.localName, this.txPowerLevel, this.connectable, this.manufacturerData, this.serviceData, this.serviceUuids});
  final String localName;
  final int txPowerLevel;
  final bool connectable;
  final Map<int, List<int>> manufacturerData;
  final Map<String, List<int>> serviceData;
  final List<String> serviceUuids;
}
