import 'dart:async';
import 'dart:io';

import 'package:farmers_market/src/models/product.dart';
import 'package:farmers_market/src/services/firebase_storage_service.dart';
import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class ProductBloc {
  final _productName = BehaviorSubject<String>();
  final _unitType = BehaviorSubject<String>();
  final _unitPrice = BehaviorSubject<String>();
  final _availableUnits = BehaviorSubject<String>();
  final _imageUrl = BehaviorSubject<String>();
  final _vendorId = BehaviorSubject<String>();
  final _productSaved = PublishSubject<bool>();
  final _product = BehaviorSubject<Product>();

  final db = FirestoreService();
  var uuid = Uuid();
  final _picker = ImagePicker();
  final storageService = FirebaseStorageService();

  //Get
  Stream<String> get productName =>
      _productName.stream.transform(validateProductName);
  Stream<String> get unitType => _unitType.stream;
  Stream<double> get unitPrice =>
      _unitPrice.stream.transform(validateUnitPrice);
  Stream<int> get availableUnits =>
      _availableUnits.stream.transform(validateAvailableUnits);
  Stream<String> get imageUrl => _imageUrl.stream;
  Stream<bool> get isValid => CombineLatestStream.combine4(
      productName, unitType, unitPrice, availableUnits, (a, b, c, d) => true);
  Stream<List<Product>> productByVendorId(String vendorId) =>
      db.fetchProductsByVendorId(vendorId);
  Stream<bool> get productSaved => _productSaved.stream;
  Future<Product> fetchProduct(String productId) => db.fetchProduct(productId);

  //Set
  Function(String) get changeProductName => _productName.sink.add;
  Function(String) get changeUnitType => _unitType.sink.add;
  Function(String) get changeUnitPrice => _unitPrice.sink.add;
  Function(String) get changeAvailableUnits => _availableUnits.sink.add;
  Function(String) get changeImageUrl => _imageUrl.sink.add;
  Function(String) get changeVendorId => _vendorId.sink.add;
  Function(Product) get changeProduct => _product.sink.add;

  dispose() {
    _productName.close();
    _unitType.close();
    _unitPrice.close();
    _availableUnits.close();
    _vendorId.close();
    _productSaved.close();
    _product.close();
    _imageUrl.close();
  }

  //Functions
  Future<void> saveProduct() async {
    var product = Product(
        approved: (_product.value == null) ? true : _product.value.approved,
        availableUnits: int.parse(_availableUnits.value),
        productId:
            (_product.value == null) ? uuid.v4() : _product.value.productId,
        productName: _productName.value.trim(),
        unitPrice: double.parse(_unitPrice.value),
        unitType: _unitType.value,
        vendorId: _vendorId.value,
        imageUrl: _imageUrl.value);

    return db
        .setProduct(product)
        .then((value) => _productSaved.sink.add(true))
        .catchError((error) => _productSaved.sink.add(false));
  }

  void pickImage() async {
    PickedFile image;

    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Get Image from Device
      image = await _picker.getImage(source: ImageSource.gallery);

      //upload to Firebase Storage
      if (image != null) {
        var imageUrl = await storageService.uploadProductImage(
            File(image.path), uuid.v4());
        print(imageUrl);
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  //validators
  final validateUnitPrice = StreamTransformer<String, double>.fromHandlers(
      handleData: (unitPrice, sink) {
    if (unitPrice != null) {
      try {
        sink.add(double.parse(unitPrice));
      } catch (error) {
        sink.addError('Must be a number');
      }
    }
  });

  final validateAvailableUnits = StreamTransformer<String, int>.fromHandlers(
      handleData: (availableUnits, sink) {
    if (availableUnits != null) {
      try {
        sink.add(int.parse(availableUnits));
      } catch (error) {
        sink.addError('Must be a whole number');
      }
    }
  });

  final validateProductName = StreamTransformer<String, String>.fromHandlers(
      handleData: (productName, sink) {
    if (productName != null) {
      if (productName.length >= 3 && productName.length <= 20) {
        sink.add(productName.trim());
      } else {
        if (productName.length < 3) {
          sink.addError('3 Characters Minimum');
        } else {
          sink.addError('20 Characters Maximum');
        }
      }
    }
  });
}
