import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/product_model.dart';

class ProductService {
  final Dio _dio = DioClient().dio;

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/products/');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    try {
      final response = await _dio.get('/products/$barcode');
      
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // Ürün bulunamadı
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}
