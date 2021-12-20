import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {

  final String _baseUrl = 'flutter-varios-a2333-default-rtdb.firebaseio.com';
  final List<Product> products = [];

  final storage = FlutterSecureStorage();

  late Product selectedProduct;

  bool isLoading = true;
  bool isSaving = false;

  File? newPictureFile;


  ProductsService(){
    this.loadProducts();
  }

  Future<List<Product>> loadProducts() async{

    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value){
      final tempProduct = Product.fromMap(value);
    
      tempProduct.id = key;

      this.products.add(tempProduct);
    });

    this.isLoading = false;
    notifyListeners();    

    return this.products;

    // print(productsMap);
  }

   Future saveOrCreateProduct(Product product) async{
    isSaving = true;
    notifyListeners();

    if(product.id == null){
      await createProduct(product);
    }else{
      await updateProduct(product);
    }

    isSaving= false;
    notifyListeners();


  } 

  Future<String> updateProduct(Product product) async{
    
    final url = Uri.https(_baseUrl, 'products/${product.id}.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

    final index = this.products.indexWhere((element) => element.id == product.id);
    this.products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async{
    
    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);

    product.id = decodedData['name'];

    this.products.add(product);


    return product.id!;
  }

  void updateSelectedProductImage(String path){
    
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();

  }

  Future<String?> uploadImage() async{
    if(newPictureFile == null){
      return null;
    }

    isSaving = true;
    notifyListeners();


    final url = Uri.parse('https://api.cloudinary.com/v1_1/faof/image/upload?upload_preset=xklsqt16');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamReponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamReponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      print('algo salir mal');
      print(resp.body);
      return null;
    }

    this.newPictureFile = null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];


  }

}