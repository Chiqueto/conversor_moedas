import 'package:flutter/material.dart';
import 'package:conversor/services/api_service.dart';
import 'package:conversor/widgets/currency_dropdown.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  final TextEditingController amountController = TextEditingController();

  List<String> _currencies = [];
  String? _fromCurrency = "BRL";
  String? _toCurrency = "USD";
  String _resultMessage = "Insira um valor para converter";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    try {
      final currencies = await apiService.fetchCurrencies();
      setState(() {
        _currencies = currencies;
        // Garante que as moedas padrão sejam válidas
        if (!_currencies.contains(_fromCurrency)) {
          _fromCurrency = _currencies.isNotEmpty ? _currencies.first : null;
        }
        if (!_currencies.contains(_toCurrency)) {
          _toCurrency = _currencies.length > 1 ? _currencies[1] : null;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _resultMessage = "Erro ao carregar moedas.";
        _isLoading = false;
      });
    }
  }

  void _convert() async {
    // Validação dos campos
    if (amountController.text.isEmpty) {
      setState(() => _resultMessage = "Por favor, insira um valor.");
      return;
    }
    final double? amount = double.tryParse(
      amountController.text.replaceAll(',', '.'),
    );
    if (amount == null || _fromCurrency == null || _toCurrency == null) {
      setState(() => _resultMessage = "Dados de entrada inválidos.");
      return;
    }

    setState(() => _resultMessage = "Convertendo...");

    try {
      final convertedAmount = await apiService.convert(
        _fromCurrency!,
        _toCurrency!,
        amount,
      );
      setState(() {
        _resultMessage =
            '$amount $_fromCurrency = ${convertedAmount.toStringAsFixed(2)} $_toCurrency';
      });
    } catch (e) {
      setState(() {
        _resultMessage = 'Erro ao converter. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Conversor de Moedas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Icon(
                      Icons.monetization_on,
                      size: 120.0,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Valor',
                        hintText: '100,00',
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CurrencyDropdown(
                            value: _fromCurrency,
                            items: _currencies,
                            onChanged:
                                (newValue) =>
                                    setState(() => _fromCurrency = newValue),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.swap_horiz,
                            color: Colors.amber,
                            size: 30,
                          ),
                        ),
                        Expanded(
                          child: CurrencyDropdown(
                            value: _toCurrency,
                            items: _currencies,
                            onChanged:
                                (newValue) =>
                                    setState(() => _toCurrency = newValue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _convert,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Converter',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          _resultMessage,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
