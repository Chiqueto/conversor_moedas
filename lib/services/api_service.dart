import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = "https://api.frankfurter.app";

  /// Busca a lista de códigos de moedas disponíveis na API.
  Future<List<String>> fetchCurrencies() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/currencies'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Retorna a lista de chaves (símbolos das moedas)
        return data.keys.toList();
      } else {
        // Lança uma exceção se a resposta não for OK.
        throw Exception('Falha ao carregar moedas');
      }
    } catch (e) {
      // Relança a exceção para ser tratada na UI.
      throw Exception('Erro de conexão ou ao buscar moedas: $e');
    }
  }

  /// Converte um valor de uma moeda para outra.
  Future<double> convert(String from, String to, double amount) async {
    final url = '$_baseUrl/latest?amount=$amount&from=$from&to=$to';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Retorna o valor convertido
        return data['rates'][to];
      } else {
        throw Exception('Falha ao converter moeda');
      }
    } catch (e) {
      throw Exception('Erro de conexão ou ao converter: $e');
    }
  }
}
