import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'КубГАУ Кампус',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const CampusScreen(),
    );
  }
}

class CampusScreen extends StatefulWidget {
  const CampusScreen({super.key});

  @override
  State<CampusScreen> createState() => _CampusScreenState();
}

class _CampusScreenState extends State<CampusScreen> {
  bool _isLiked = false;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    _showMessage(_isLiked ? 'Вы поставили лайк! ❤️' : 'Вы убрали лайк');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('КубГАУ Кампус'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Image.asset(
            'assets/images/kubsau.jpg',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200,
              color: Colors.green[50],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 50, color: Colors.green),
                    SizedBox(height: 8),
                    Text(
                      'Фото кампуса',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Студенческий городок Кубанского ГАУ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: _toggleLike,
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : Colors.grey,
                        size: 32,
                      ),
                    ),
                    Text(
                      _isLiked ? 'Лайк' : 'Нравится',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _showMessage('📞 Звонок в приёмную комиссию'),
                      icon: const Icon(Icons.phone, size: 32, color: Colors.green),
                    ),
                    const Text('Звонок', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _showMessage('🧭 Построение маршрута до КубГАУ'),
                      icon: const Icon(Icons.directions, size: 32, color: Colors.green),
                    ),
                    const Text('Маршрут', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _showMessage('📤 Открыто окно поделиться'),
                      icon: const Icon(Icons.share, size: 32, color: Colors.green),
                    ),
                    const Text('Поделиться', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 32, thickness: 1),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Студенческий городок или так называемый кампус Кубанского ГАУ состоит из двадцати общежитий, в которых проживает более 8000 студентов, что составляет 96% от всех нуждающихся. Студенты первого курса обеспечены местами в общежитии полностью. В соответствии с Положением о студенческих общежитиях университета, при поселении между администрацией и студентами заключается договор найма жилого помещения. Воспитательная работа в общежитиях направлена на улучшение быта, соблюдение правил внутреннего распорядка, отсутствия асоциальных явлений в молодежной среде. Условия проживания в общежитиях университетского кампуса полностью отвечают санитарным нормам и требованиям: наличие оборудованных кухонь, душевых комнат, прачечных, читальных залов, комнат самоподготовки, помещений для заседаний студенческих советов и наглядной агитации. С целью улучшения условий быта студентов активно работает система студенческого самоуправления - студенческие советы организуют всю работу по самообслуживанию.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.green[700]),
                        const SizedBox(width: 8),
                        const Text(
                          'Факты о кампусе',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('• 20 общежитий'),
                    const SizedBox(height: 4),
                    const Text('• 8000+ студентов проживает'),
                    const SizedBox(height: 4),
                    const Text('• 96% обеспеченность местами'),
                    const SizedBox(height: 4),
                    const Text('• Первокурсники обеспечены полностью'),
                    const SizedBox(height: 4),
                    const Text('• Оборудованные кухни и душевые'),
                    const SizedBox(height: 4),
                    const Text('• Читальные залы и комнаты самоподготовки'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}