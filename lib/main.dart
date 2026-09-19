import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BoraJogarApp());
}

// ============================================================
// BORA JOGAR — VERSAO PRONTA PARA BUILD (APK / IPA)
// ============================================================

const Color kGreen = Color(0xFF20C997);
const Color kGreenDark = Color(0xFF12B886);
const Color kPurple = Color(0xFF7C5CFC);
const Color kBlue = Color(0xFF3498DB);
const Color kOrange = Color(0xFFF39C12);
const Color kRed = Color(0xFFE74C3C);
const Color kBackground = Color(0xFFF6F8FB);

// ============================================================
// MODELOS
// ============================================================

enum ActivityCategory { esporte, lazer }

class Place {
  final String name;
  final double x;
  final double y;
  final ActivityCategory category;
  final IconData icon;

  const Place({
    required this.name,
    required this.x,
    required this.y,
    required this.category,
    required this.icon,
  });
}

class Activity {
  final String id;
  final String title;
  final String type;
  final ActivityCategory category;
  final String dateTime;
  final Place place;
  final int totalSpots;
  int occupiedSpots;
  final List<String> participants;

  Activity({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.dateTime,
    required this.place,
    required this.totalSpots,
    required this.occupiedSpots,
    List<String>? participants,
  }) : participants = participants ?? [];

  bool get isFull => occupiedSpots >= totalSpots;
}

class AvatarConfig {
  Color skin;
  Color hair;
  Color shirt;
  Color pants; // cor fixa - nao aparece mais no editor
  Color accessory;
  Color shoes;
  Color eyeColor;
  int hairStyle;
  int shirtStyle;
  int shoeStyle;
  int accessoryStyle;
  int faceStyle;

  AvatarConfig({
    this.skin = const Color(0xFFF1C27D),
    this.hair = const Color(0xFF2B1B12),
    this.shirt = kBlue,
    this.pants = const Color(0xFF263238),
    this.accessory = const Color(0xFF212121),
    this.shoes = Colors.white,
    this.eyeColor = Colors.black,
    this.hairStyle = 0,
    this.shirtStyle = 0,
    this.shoeStyle = 0,
    this.accessoryStyle = 0,
    this.faceStyle = 0,
  });

  AvatarConfig copy() {
    return AvatarConfig(
      skin: skin,
      hair: hair,
      shirt: shirt,
      pants: pants,
      accessory: accessory,
      shoes: shoes,
      eyeColor: eyeColor,
      hairStyle: hairStyle,
      shirtStyle: shirtStyle,
      shoeStyle: shoeStyle,
      accessoryStyle: accessoryStyle,
      faceStyle: faceStyle,
    );
  }
}

// ============================================================
// ESTADO GLOBAL
// ============================================================

class AppState extends ChangeNotifier {
  String name = '';
  int age = 0;
  String gender = 'Masculino';
  int xp = 0;

  AvatarConfig avatar = AvatarConfig();
  final List<Activity> activities = [];
  final List<String> scheduledIds = [];
  late final List<Place> places;

  AppState() {
    places = const [
      // ---------------- ESPORTE ----------------
      Place(name: 'Arena Central', x: 980, y: 760, category: ActivityCategory.esporte, icon: Icons.sports_soccer),
      Place(name: 'Praça da Juventude', x: 420, y: 1120, category: ActivityCategory.esporte, icon: Icons.sports_basketball),
      Place(name: 'Ginásio Municipal', x: 1380, y: 360, category: ActivityCategory.esporte, icon: Icons.sports_volleyball),
      Place(name: 'Pista Riverside', x: 310, y: 820, category: ActivityCategory.esporte, icon: Icons.directions_run),
      Place(name: 'Bike Park', x: 280, y: 300, category: ActivityCategory.esporte, icon: Icons.directions_bike),
      Place(name: 'Complexo Aquático', x: 2100, y: 2100, category: ActivityCategory.esporte, icon: Icons.pool),
      Place(name: 'Dojo de Lutas', x: 1800, y: 1500, category: ActivityCategory.esporte, icon: Icons.sports_martial_arts),
      Place(name: 'Skatepark Radical', x: 2500, y: 1100, category: ActivityCategory.esporte, icon: Icons.skateboarding),
      Place(name: 'Arena de Areia', x: 2700, y: 1480, category: ActivityCategory.esporte, icon: Icons.sports_volleyball),
      Place(name: 'Lago dos Caiaques', x: 2330, y: 1760, category: ActivityCategory.esporte, icon: Icons.rowing),
      Place(name: 'Quadra do Bairro', x: 760, y: 1600, category: ActivityCategory.esporte, icon: Icons.sports_basketball),
      Place(name: 'Pista de Atletismo', x: 1720, y: 2290, category: ActivityCategory.esporte, icon: Icons.directions_run),
      Place(name: 'Academia ao Ar Livre', x: 1010, y: 1720, category: ActivityCategory.esporte, icon: Icons.fitness_center),
      Place(name: 'Trilha da Serra', x: 150, y: 1520, category: ActivityCategory.esporte, icon: Icons.directions_walk),
      Place(name: 'Campo do Sindicato', x: 330, y: 2290, category: ActivityCategory.esporte, icon: Icons.sports_soccer),

      // ---------------- LAZER ----------------
      Place(name: 'Parque das Árvores', x: 620, y: 430, category: ActivityCategory.lazer, icon: Icons.park),
      Place(name: 'Cine Center', x: 1540, y: 980, category: ActivityCategory.lazer, icon: Icons.movie),
      Place(name: 'Boliche Station', x: 1160, y: 1120, category: ActivityCategory.lazer, icon: Icons.sports),
      Place(name: 'Teatro Municipal', x: 2200, y: 600, category: ActivityCategory.lazer, icon: Icons.theater_comedy),
      Place(name: 'Praia do Sol', x: 2800, y: 1800, category: ActivityCategory.lazer, icon: Icons.beach_access),
      Place(name: 'Arena de Shows', x: 500, y: 1900, category: ActivityCategory.lazer, icon: Icons.mic),
      Place(name: 'Polo Gastronômico', x: 1200, y: 2200, category: ActivityCategory.lazer, icon: Icons.restaurant),
      Place(name: 'Quiosque da Praia', x: 2700, y: 2180, category: ActivityCategory.lazer, icon: Icons.local_bar),
      Place(name: 'Píer do Porto', x: 2720, y: 820, category: ActivityCategory.lazer, icon: Icons.directions_boat),
      Place(name: 'Mirante do Morro', x: 2380, y: 240, category: ActivityCategory.lazer, icon: Icons.terrain),
      Place(name: 'Shopping Praça', x: 880, y: 1360, category: ActivityCategory.lazer, icon: Icons.shopping_cart),
      Place(name: 'Camping do Lago', x: 1520, y: 1830, category: ActivityCategory.lazer, icon: Icons.nature_people),
      Place(name: 'Museu da Cidade', x: 2010, y: 1150, category: ActivityCategory.lazer, icon: Icons.account_balance),
      Place(name: 'Arena Gamer', x: 1960, y: 2400, category: ActivityCategory.lazer, icon: Icons.sports_esports),
      Place(name: 'Feira Livre', x: 670, y: 2320, category: ActivityCategory.lazer, icon: Icons.store),
    ];

    _createInitialActivities();
  }

  int get level => (xp ~/ 100) + 1;
  double get levelProgress => (xp % 100) / 100;
  int get xpForNextLevel => level * 100;
  bool get hasProfile => name.trim().isNotEmpty;

  bool isScheduled(Activity activity) => scheduledIds.contains(activity.id);

  Place placeByName(String name) => places.firstWhere((p) => p.name == name);

  void _createInitialActivities() {
    activities.addAll([
      Activity(id: 'sp_1', title: 'Futebol Society Arena', type: 'Futebol', category: ActivityCategory.esporte, dateTime: 'Hoje • 18:00', place: placeByName('Arena Central'), totalSpots: 10, occupiedSpots: 6, participants: ['Lucas', 'Marcos', 'João', 'Pedro']),
      Activity(id: 'lz_1', title: 'Sessão de Cinema', type: 'Cinema', category: ActivityCategory.lazer, dateTime: 'Hoje • 21:00', place: placeByName('Cine Center'), totalSpots: 20, occupiedSpots: 4, participants: ['Bia', 'Gui']),
      Activity(id: 'sp_2', title: 'Treino de Natação', type: 'Natação', category: ActivityCategory.esporte, dateTime: 'Amanhã • 07:00', place: placeByName('Complexo Aquático'), totalSpots: 12, occupiedSpots: 5, participants: ['Ana', 'Carlos']),
      Activity(id: 'sp_3', title: 'Vôlei de Praia no Fim de Tarde', type: 'Vôlei de Praia', category: ActivityCategory.esporte, dateTime: 'Sábado • 16:00', place: placeByName('Arena de Areia'), totalSpots: 8, occupiedSpots: 3, participants: ['Duda', 'Rafa']),
      Activity(id: 'lz_2', title: 'Pôr do Sol no Mirante', type: 'Passeio', category: ActivityCategory.lazer, dateTime: 'Domingo • 17:30', place: placeByName('Mirante do Morro'), totalSpots: 15, occupiedSpots: 7, participants: ['Nina', 'Tom']),
    ]);
  }

  void saveProfile(String newName, int newAge, String newGender) {
    name = newName.trim();
    age = newAge;
    gender = newGender;
    notifyListeners();
  }

  void schedule(Activity activity) {
    if (isScheduled(activity) || activity.isFull) return;
    activity.occupiedSpots++;
    activity.participants.add(name);
    scheduledIds.add(activity.id);
    xp += 50;
    notifyListeners();
  }

  void createActivity(Activity activity) {
    activities.insert(0, activity);
    xp += 100;
    notifyListeners();
  }

  void saveAvatar(AvatarConfig config) {
    avatar = config.copy();
    notifyListeners();
  }

  void logout() {
    name = '';
    age = 0;
    gender = 'Masculino';
    xp = 0;
    scheduledIds.clear();
    avatar = AvatarConfig();
    notifyListeners();
  }
}

final AppState appState = AppState();

// ============================================================
// APP ROOT
// ============================================================

class BoraJogarApp extends StatelessWidget {
  const BoraJogarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bora Jogar PRO',
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: kBackground,
            colorScheme: ColorScheme.fromSeed(seedColor: kGreen, brightness: Brightness.light),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0),
            cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
          ),
          home: appState.hasProfile ? const MainNavigation() : const OnboardingScreen(),
        );
      },
    );
  }
}

// ============================================================
// ONBOARDING
// ============================================================

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  String gender = 'Masculino';
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void start() {
    final parsedAge = int.tryParse(ageController.text.trim());
    if (nameController.text.trim().isEmpty || parsedAge == null || parsedAge <= 0 || parsedAge > 99) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha seu nome e uma idade válida.')));
      return;
    }
    SystemSound.play(SystemSoundType.click);
    appState.saveProfile(nameController.text, parsedAge, gender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) => Transform.scale(scale: 0.94 + (animationController.value * 0.08), child: child),
                    child: const AppLogo(),
                  ),
                  const SizedBox(height: 22),
                  const Text('Bora Jogar PRO', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  const Text('O maior mapa de esporte e lazer da cidade.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 15)),
                  const SizedBox(height: 32),
                  TextField(controller: nameController, textCapitalization: TextCapitalization.words, decoration: appInputDecoration('Seu nome', Icons.person_outline)),
                  const SizedBox(height: 14),
                  TextField(controller: ageController, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], decoration: appInputDecoration('Sua idade', Icons.cake_outlined)),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: gender,
                    decoration: appInputDecoration('Gênero', Icons.person_search_outlined),
                    items: const [
                      DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                      DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
                    ],
                    onChanged: (value) => setState(() => gender = value ?? gender),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: start,
                    icon: const Icon(Icons.rocket_launch),
                    label: const Text('COMEÇAR AGORA', style: TextStyle(fontWeight: FontWeight.w800)),
                    style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 58), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kGreen, kBlue]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Color(0x3320C997), blurRadius: 26, offset: Offset(0, 10))],
      ),
      child: const Icon(Icons.public, color: Colors.white, size: 55),
    );
  }
}

// ============================================================
// NAVEGACAO PRINCIPAL
// ============================================================

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;
  final List<Widget> pages = const [HomeScreen(), ExploreScreen(), CreateActivityScreen(), AgendaScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0.025, 0), end: Offset.zero).animate(animation), child: child)),
        child: KeyedSubtree(key: ValueKey(index), child: pages[index]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          SystemSound.play(SystemSoundType.click);
          setState(() => index = value);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explorar'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Criar'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Agenda'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// ============================================================
// TELAS PRINCIPAIS
// ============================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recommended = appState.activities.take(5).toList();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Olá, ${appState.name} 👋', style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    const Text('Qual vai ser o rolê de hoje?', style: TextStyle(color: Colors.grey, fontSize: 15)),
                  ],
                ),
              ),
              const AvatarPreview(size: 52, animated: true),
            ],
          ),
          const SizedBox(height: 20),
          const XPCard(),
          const SizedBox(height: 24),
          const SectionHeader(title: 'O que você quer fazer?'),
          const SizedBox(height: 12),
          SizedBox(
            height: 112,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                QuickActionCard(title: 'Esportes', subtitle: 'Jogos e treinos', icon: Icons.sports_soccer, color: kGreen, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen(initialFilter: ActivityCategory.esporte)))),
                QuickActionCard(title: 'Lazer', subtitle: 'Cinema e shows', icon: Icons.movie_outlined, color: kPurple, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen(initialFilter: ActivityCategory.lazer)))),
                QuickActionCard(title: 'Mapa', subtitle: 'Ver a cidade', icon: Icons.map_outlined, color: kBlue, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BigMapScreen()))),
                QuickActionCard(title: 'Avatar', subtitle: 'Mude seu visual', icon: Icons.face_retouching_natural, color: kOrange, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AvatarEditorScreen()))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SectionHeader(title: 'Recomendados'),
              TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen())), child: const Text('Ver tudo')),
            ],
          ),
          const SizedBox(height: 2),
          ...recommended.map((activity) => ActivityCard(activity: activity)),
        ],
      ),
    );
  }
}

class XPCard extends StatelessWidget {
  const XPCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kGreen, kGreenDark]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Color(0x3320C997), blurRadius: 20, offset: Offset(0, 9))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .18), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.emoji_events, color: Colors.white, size: 28)),
              const SizedBox(width: 12),
              Expanded(child: Text('Nível ${appState.level}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900))),
              Text('${appState.xp} XP', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: appState.levelProgress, minHeight: 9, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(Colors.white))),
          const SizedBox(height: 8),
          Align(alignment: Alignment.centerLeft, child: Text('${appState.xpForNextLevel - appState.xp} XP para o próximo nível', style: const TextStyle(color: Colors.white70, fontSize: 12))),
        ],
      ),
    );
  }
}

class ExploreScreen extends StatefulWidget {
  final ActivityCategory? initialFilter;
  const ExploreScreen({super.key, this.initialFilter});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  ActivityCategory? filter;
  String search = '';

  @override
  void initState() {
    super.initState();
    filter = widget.initialFilter;
  }

  List<Activity> get filteredActivities {
    return appState.activities.where((a) {
      final matchesCategory = filter == null || a.category == filter;
      final q = search.trim().toLowerCase();
      final matchesSearch = q.isEmpty || a.title.toLowerCase().contains(q) || a.type.toLowerCase().contains(q) || a.place.name.toLowerCase().contains(q);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final activities = filteredActivities;
    // Se esta tela foi aberta por cima de outra (Navigator.push), ela cobre a
    // barra de baixo. Entao mostramos uma setinha de voltar.
    final canGoBack = Navigator.of(context).canPop();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
              child: Row(
                children: [
                  if (canGoBack) ...[
                    IconButton.filledTonal(
                      tooltip: 'Voltar',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 10),
                  ],
                  const Expanded(child: Text('Explorar', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900))),
                  IconButton.filledTonal(tooltip: 'Abrir o mapa', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BigMapScreen())), icon: const Icon(Icons.map_outlined)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(onChanged: (v) => setState(() => search = v), decoration: appInputDecoration('Buscar esporte, lazer ou local...', Icons.search)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: [
                  FilterChip(label: const Text('Todos'), selected: filter == null, onSelected: (_) => setState(() => filter = null)),
                  const SizedBox(width: 8),
                  FilterChip(label: const Text('⚽ Esportes'), selected: filter == ActivityCategory.esporte, onSelected: (_) => setState(() => filter = ActivityCategory.esporte)),
                  const SizedBox(width: 8),
                  FilterChip(label: const Text('🎬 Lazer'), selected: filter == ActivityCategory.lazer, onSelected: (_) => setState(() => filter = ActivityCategory.lazer)),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: activities.isEmpty
                  ? const EmptyState(icon: Icons.search_off, title: 'Nada encontrado', subtitle: 'Tente outro nome ou categoria.')
                  : ListView.builder(padding: const EdgeInsets.fromLTRB(18, 10, 18, 30), itemCount: activities.length, itemBuilder: (c, i) => ActivityCard(activity: activities[i])),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Activity activity;
  const ActivityCard({super.key, required this.activity});
  @override
  Widget build(BuildContext context) {
    final color = activity.category == ActivityCategory.lazer ? kPurple : kGreen;
    return Card(
      margin: const EdgeInsets.only(bottom: 13),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ActivityDetailScreen(activity: activity))),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Hero(tag: 'act_${activity.id}', child: Container(width: 64, height: 64, decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(18)), child: Icon(activityIcon(activity.type), color: color, size: 30))),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activity.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 5),
                    Text('${activity.dateTime} • ${activity.place.name}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.people_alt_outlined, size: 15, color: activity.isFull ? kRed : Colors.grey),
                        const SizedBox(width: 4),
                        Text('${activity.occupiedSpots}/${activity.totalSpots}', style: TextStyle(color: activity.isFull ? kRed : Colors.grey, fontWeight: FontWeight.w700, fontSize: 12)),
                        const SizedBox(width: 9),
                        Icon(Icons.location_on_outlined, size: 15, color: color),
                        const SizedBox(width: 3),
                        Expanded(child: Text(activity.type, overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700))),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityDetailScreen extends StatelessWidget {
  final Activity activity;
  const ActivityDetailScreen({super.key, required this.activity});
  @override
  Widget build(BuildContext context) {
    final scheduled = appState.isScheduled(activity);
    final color = activity.category == ActivityCategory.lazer ? kPurple : kGreen;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(flex: 5, child: BigMapScreen(focusPlace: activity.place, compact: true)),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Hero(tag: 'act_${activity.id}', child: Container(width: 54, height: 54, decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(16)), child: Icon(activityIcon(activity.type), color: color))),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(activity.category == ActivityCategory.lazer ? 'LAZER' : activity.type.toUpperCase(), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                                const SizedBox(height: 3),
                                Text(activity.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      DetailInfoRow(icon: Icons.schedule, title: activity.dateTime, subtitle: 'Horário da atividade'),
                      DetailInfoRow(icon: Icons.location_on_outlined, title: activity.place.name, subtitle: 'Local do evento'),
                      DetailInfoRow(icon: Icons.groups_outlined, title: '${activity.occupiedSpots}/${activity.totalSpots} pessoas', subtitle: activity.isFull ? 'Evento lotado' : 'Vagas disponíveis'),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: scheduled || activity.isFull
                                  ? null
                                  : () {
                                      appState.schedule(activity);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Presença confirmada! +50 XP ⭐')));
                                    },
                              icon: Icon(scheduled ? Icons.check_circle : Icons.event_available),
                              label: Text(scheduled
                                  ? 'CONFIRMADO'
                                  : activity.isFull
                                      ? 'LOTADO'
                                      : 'MARCAR PRESENÇA'),
                              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54), backgroundColor: color),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton.filledTonal(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(activity: activity))), icon: const Icon(Icons.chat_bubble_outline)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(top: 42, left: 16, child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)))),
        ],
      ),
    );
  }
}

class DetailInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const DetailInfoRow({super.key, required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: kGreen.withValues(alpha: .10), borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 21, color: kGreen)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({super.key});
  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final titleController = TextEditingController();
  final dateController = TextEditingController(text: 'Hoje • 19:00');
  ActivityCategory category = ActivityCategory.esporte;
  String type = 'Futebol';
  String placeName = 'Arena Central';

  List<String> get sportTypes => const [
        'Futebol',
        'Basquete',
        'Vôlei',
        'Vôlei de Praia',
        'Futevôlei',
        'Tênis',
        'Corrida',
        'Ciclismo',
        'Natação',
        'Caiaque',
        'Trilha',
        'Musculação',
        'Artes Marciais',
        'Skate',
      ];

  List<String> get leisureTypes => const [
        'Cinema',
        'Parque',
        'Caminhada',
        'Boliche',
        'Passeio',
        'Teatro',
        'Show',
        'Praia',
        'Camping',
        'Restaurante',
        'Museu',
        'Feira',
        'Games',
        'Compras',
      ];

  List<String> get currentTypes => category == ActivityCategory.esporte ? sportTypes : leisureTypes;

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void create() {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Digite um nome para sua atividade.')));
      return;
    }
    appState.createActivity(Activity(
      id: 'cust_${DateTime.now().millisecondsSinceEpoch}',
      title: titleController.text.trim(),
      type: type,
      category: category,
      dateTime: dateController.text.trim().isEmpty ? 'A combinar' : dateController.text.trim(),
      place: appState.placeByName(placeName),
      totalSpots: 15,
      occupiedSpots: 0,
    ));
    titleController.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Atividade criada! +100 XP 🚀')));
  }

  @override
  Widget build(BuildContext context) {
    final color = category == ActivityCategory.lazer ? kPurple : kGreen;
    return Scaffold(
      appBar: AppBar(title: const Text('Criar atividade', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 35),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withValues(alpha: .75)]), borderRadius: BorderRadius.circular(25)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome, color: Colors.white, size: 30),
                SizedBox(height: 12),
                Text('Monte seu rolê', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text('Crie um jogo, passeio, praia, cinema ou show.', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 22),
          TextField(controller: titleController, decoration: appInputDecoration('Nome da atividade', Icons.edit_outlined)),
          const SizedBox(height: 14),
          DropdownButtonFormField<ActivityCategory>(
            initialValue: category,
            decoration: appInputDecoration('Categoria', Icons.category_outlined),
            items: const [
              DropdownMenuItem(value: ActivityCategory.esporte, child: Text('⚽ Esporte')),
              DropdownMenuItem(value: ActivityCategory.lazer, child: Text('🎬 Lazer')),
            ],
            onChanged: (v) {
              if (v != null) {
                setState(() {
                  category = v;
                  type = currentTypes.first;
                  placeName = appState.places.firstWhere((p) => p.category == v).name;
                });
              }
            },
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            key: ValueKey('type_$category'),
            initialValue: type,
            decoration: appInputDecoration('Atividade', activityIcon(type)),
            items: currentTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) {
              if (v != null) setState(() => type = v);
            },
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            key: ValueKey('place_$category'),
            initialValue: placeName,
            decoration: appInputDecoration('Local', Icons.location_on_outlined),
            items: appState.places.where((p) => p.category == category).map((p) => DropdownMenuItem(value: p.name, child: Text(p.name))).toList(),
            onChanged: (v) {
              if (v != null) setState(() => placeName = v);
            },
          ),
          const SizedBox(height: 14),
          TextField(controller: dateController, decoration: appInputDecoration('Data e hora', Icons.schedule_outlined)),
          const SizedBox(height: 25),
          FilledButton.icon(onPressed: create, icon: const Icon(Icons.add), label: const Text('CRIAR ATIVIDADE', style: TextStyle(fontWeight: FontWeight.w900)), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56), backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)))),
        ],
      ),
    );
  }
}

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final scheduled = appState.activities.where(appState.isScheduled).toList();
    return SafeArea(
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.fromLTRB(18, 20, 18, 10), child: Align(alignment: Alignment.centerLeft, child: Text('Minha agenda', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900)))),
          Expanded(child: scheduled.isEmpty ? const EmptyState(icon: Icons.calendar_month_outlined, title: 'Agenda vazia', subtitle: 'Marque uma atividade para ela aparecer aqui.') : ListView(padding: const EdgeInsets.fromLTRB(18, 10, 18, 30), children: scheduled.map((a) => ActivityCard(activity: a)).toList())),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
        children: [
          const Text('Meu perfil', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 6))]),
            child: Column(
              children: [
                const AvatarPreview(size: 145, animated: true),
                const SizedBox(height: 12),
                Text(appState.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('${appState.age} anos • ${appState.gender}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          ProfileStatRow(icon: Icons.emoji_events_outlined, title: 'Nível', value: '${appState.level}'),
          ProfileStatRow(icon: Icons.bolt_outlined, title: 'XP total', value: '${appState.xp}'),
          ProfileStatRow(icon: Icons.event_available_outlined, title: 'Atividades', value: '${appState.scheduledIds.length}'),
          const SizedBox(height: 15),
          ProfileMenuTile(icon: Icons.face_retouching_natural, title: 'Personalizar avatar', subtitle: 'Cabelo, tênis, chapéus e óculos', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AvatarEditorScreen()))),
          const SizedBox(height: 10),
          ProfileMenuTile(icon: Icons.map_outlined, title: 'Abrir mapa do universo', subtitle: 'Explore todos os novos locais', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BigMapScreen()))),
          const SizedBox(height: 22),
          OutlinedButton.icon(onPressed: () => appState.logout(), icon: const Icon(Icons.logout), label: const Text('Sair / trocar perfil'), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52))),
        ],
      ),
    );
  }
}

class ProfileStatRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const ProfileStatRow({super.key, required this.icon, required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(children: [Icon(icon, color: kGreen), const SizedBox(width: 12), Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))), Text(value, style: const TextStyle(fontWeight: FontWeight.w900))]),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const ProfileMenuTile({super.key, required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), leading: Container(width: 44, height: 44, decoration: BoxDecoration(color: kGreen.withValues(alpha: .10), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: kGreen)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(subtitle), trailing: const Icon(Icons.chevron_right), onTap: onTap));
  }
}

// ============================================================
// EDITOR DE AVATAR
// ============================================================

class AvatarEditorScreen extends StatefulWidget {
  const AvatarEditorScreen({super.key});
  @override
  State<AvatarEditorScreen> createState() => _AvatarEditorScreenState();
}

class _AvatarEditorScreenState extends State<AvatarEditorScreen> {
  late AvatarConfig draft;
  final skinColors = const [Color(0xFFF8D2A5), Color(0xFFF1C27D), Color(0xFFC68642), Color(0xFF8D5524), Color(0xFF5A3825)];
  final hairColors = const [Color(0xFF2B1B12), Color(0xFF6D3B1F), Color(0xFFD4A017), Color(0xFFBFC7D5), Color(0xFF181818), Color(0xFF8E44AD), Color(0xFFE74C3C)];
  final shirtColors = const [kBlue, kRed, kGreen, kPurple, kOrange, Color(0xFF263238), Colors.white];
  final shoeColors = const [Colors.white, Color(0xFF212121), kRed, kBlue, kGreen, kOrange, Color(0xFF8D6E63), Color(0xFFFFD54F)];
  final accessoryColors = const [Color(0xFF212121), Color(0xFF6D4C41), Color(0xFFFFD54F), Colors.white, Color(0xFFEC407A), Color(0xFF00BCD4), kRed];
  final eyeColors = const [Colors.black, Color(0xFF2E7D32), Color(0xFF1565C0), Color(0xFF5D4037)];

  @override
  void initState() {
    super.initState();
    draft = appState.avatar.copy();
  }

  void save() {
    appState.saveAvatar(draft);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visual salvo com sucesso! ✨')));
    Navigator.pop(context);
  }

  bool get isFemale => appState.gender == 'Feminino';
  List<String> get hairLabels => isFemale ? const ['Longo', 'Rabo de cavalo', 'Curto', 'Coque'] : const ['Clássico', 'Topete', 'Careca', 'Militar'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editor PRO', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 35),
        children: [
          Center(child: AvatarPreview(size: 205, animated: true, config: draft)),
          const SizedBox(height: 12),
          const Center(child: Text('Customização Avançada', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900))),
          const SizedBox(height: 22),
          AvatarSection(title: 'Tom de pele', icon: Icons.face, child: ColorSelector(colors: skinColors, selected: draft.skin, onSelected: (c) => setState(() => draft.skin = c))),
          AvatarSection(title: 'Expressão', icon: Icons.mood_outlined, child: ChoiceSelector(labels: const ['Normal', 'Sorrindo', 'Raivoso', 'Triste'], selected: draft.faceStyle, onSelected: (i) => setState(() => draft.faceStyle = i))),
          AvatarSection(title: 'Olhos', icon: Icons.visibility, child: ColorSelector(colors: eyeColors, selected: draft.eyeColor, onSelected: (c) => setState(() => draft.eyeColor = c))),
          AvatarSection(title: 'Cabelo (${appState.gender})', icon: Icons.content_cut, child: ColorSelector(colors: hairColors, selected: draft.hair, onSelected: (c) => setState(() => draft.hair = c))),
          AvatarSection(title: 'Estilo de cabelo', icon: Icons.auto_awesome, child: ChoiceSelector(labels: hairLabels, selected: draft.hairStyle, onSelected: (i) => setState(() => draft.hairStyle = i))),
          AvatarSection(title: 'Camisa', icon: Icons.checkroom_outlined, child: ColorSelector(colors: shirtColors, selected: draft.shirt, onSelected: (c) => setState(() => draft.shirt = c))),
          AvatarSection(title: 'Estilo da camisa', icon: Icons.palette_outlined, child: ChoiceSelector(labels: const ['Normal', 'Listrada', 'Terno', 'Camisa Anglo'], selected: draft.shirtStyle, onSelected: (i) => setState(() => draft.shirtStyle = i))),
          AvatarSection(title: 'Cor do tênis', icon: Icons.roller_skating, child: ColorSelector(colors: shoeColors, selected: draft.shoes, onSelected: (c) => setState(() => draft.shoes = c))),
          AvatarSection(title: 'Modelo do tênis', icon: Icons.directions_run, child: ChoiceSelector(labels: const ['Clássico', 'Cano alto', 'Corrida', 'Chunky', 'Chuteira', 'Bota'], selected: draft.shoeStyle, onSelected: (i) => setState(() => draft.shoeStyle = i))),
          AvatarSection(title: 'Cor do acessório', icon: Icons.stars_outlined, child: ColorSelector(colors: accessoryColors, selected: draft.accessory, onSelected: (c) => setState(() => draft.accessory = c))),
          AvatarSection(title: 'Acessório', icon: Icons.workspace_premium_outlined, child: ChoiceSelector(labels: const ['Nenhum', 'Óculos', 'Óculos escuro', 'Brinco', 'Coroa', 'Cartola', 'Fedora', 'Boné'], selected: draft.accessoryStyle, onSelected: (i) => setState(() => draft.accessoryStyle = i))),
          const SizedBox(height: 15),
          FilledButton.icon(onPressed: save, icon: const Icon(Icons.check), label: const Text('SALVAR AVATAR', style: TextStyle(fontWeight: FontWeight.w900)), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(57), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)))),
        ],
      ),
    );
  }
}

class AvatarSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const AvatarSection({super.key, required this.title, required this.icon, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(icon, size: 19, color: kGreen), const SizedBox(width: 8), Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)))]), const SizedBox(height: 12), child]),
    );
  }
}

class ColorSelector extends StatelessWidget {
  final List<Color> colors;
  final Color selected;
  final ValueChanged<Color> onSelected;
  const ColorSelector({super.key, required this.colors, required this.selected, required this.onSelected});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (c, i) {
          final color = colors[i];
          final isSelected = color == selected;
          return GestureDetector(
            onTap: () => onSelected(color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: isSelected ? 53 : 48,
              height: isSelected ? 53 : 48,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: isSelected ? kGreen : Colors.grey.shade300, width: isSelected ? 4 : 1)),
            ),
          );
        },
      ),
    );
  }
}

class ChoiceSelector extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  const ChoiceSelector({super.key, required this.labels, required this.selected, required this.onSelected});
  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, runSpacing: 8, children: List.generate(labels.length, (i) => ChoiceChip(label: Text(labels[i]), selected: selected == i, onSelected: (_) => onSelected(i))));
  }
}

class AvatarPreview extends StatefulWidget {
  final double size;
  final bool animated;
  final AvatarConfig? config;
  const AvatarPreview({super.key, required this.size, this.animated = false, this.config});
  @override
  State<AvatarPreview> createState() => _AvatarPreviewState();
}

class _AvatarPreviewState extends State<AvatarPreview> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
    if (widget.animated) controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget avatar = SizedBox(width: widget.size, height: widget.size, child: CustomPaint(painter: AvatarPainter(widget.config ?? appState.avatar, appState.gender)));
    if (!widget.animated) return avatar;
    return AnimatedBuilder(animation: controller, builder: (c, child) => Transform.translate(offset: Offset(0, sin(controller.value * pi) * -3), child: child), child: avatar);
  }
}

class AvatarPainter extends CustomPainter {
  final AvatarConfig config;
  final String gender;
  AvatarPainter(this.config, this.gender);

  // ---------- TENIS ----------
  void _drawShoe(Canvas canvas, double s, double cx) {
    final shoePaint = Paint()..color = config.shoes;
    final bool light = config.shoes.computeLuminance() > .5;
    final solePaint = Paint()..color = light ? const Color(0xFF9E9E9E) : Colors.white;
    final detailPaint = Paint()
      ..color = light ? Colors.black54 : Colors.white
      ..strokeWidth = s * .016
      ..strokeCap = StrokeCap.round;

    switch (config.shoeStyle) {
      case 1: // Cano alto
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .855), width: s * .135, height: s * .10), Radius.circular(s * .03)), shoePaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .905), width: s * .175, height: s * .065), Radius.circular(s * .025)), shoePaint);
        canvas.drawLine(Offset(cx - s * .04, s * .838), Offset(cx + s * .04, s * .838), detailPaint);
        canvas.drawLine(Offset(cx - s * .04, s * .872), Offset(cx + s * .04, s * .872), detailPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .942), width: s * .19, height: s * .03), Radius.circular(s * .015)), solePaint);
        break;
      case 2: // Corrida
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .903), width: s * .185, height: s * .07), Radius.circular(s * .033)), shoePaint);
        canvas.drawLine(Offset(cx - s * .062, s * .884), Offset(cx + s * .05, s * .918), detailPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .943), width: s * .195, height: s * .028), Radius.circular(s * .014)), solePaint);
        break;
      case 3: // Chunky
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .880), width: s * .175, height: s * .058), Radius.circular(s * .026)), shoePaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .928), width: s * .205, height: s * .056), Radius.circular(s * .024)), solePaint);
        canvas.drawLine(
          Offset(cx - s * .085, s * .928),
          Offset(cx + s * .085, s * .928),
          Paint()
            ..color = Colors.black26
            ..strokeWidth = s * .008,
        );
        break;
      case 4: // Chuteira
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .901), width: s * .185, height: s * .066), Radius.circular(s * .018)), shoePaint);
        canvas.drawLine(Offset(cx - s * .05, s * .888), Offset(cx + s * .045, s * .888), detailPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .937), width: s * .185, height: s * .022), Radius.circular(s * .01)), solePaint);
        final studs = Paint()..color = const Color(0xFF424242);
        for (final dx in [-0.055, 0.0, 0.055]) {
          canvas.drawCircle(Offset(cx + s * dx, s * .955), s * .012, studs);
        }
        break;
      case 5: // Bota
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .845), width: s * .145, height: s * .12), Radius.circular(s * .022)), shoePaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .908), width: s * .185, height: s * .058), Radius.circular(s * .02)), shoePaint);
        canvas.drawLine(Offset(cx - s * .045, s * .828), Offset(cx + s * .045, s * .838), detailPaint);
        canvas.drawLine(Offset(cx - s * .045, s * .864), Offset(cx + s * .045, s * .874), detailPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .944), width: s * .195, height: s * .028), Radius.circular(s * .012)), Paint()..color = const Color(0xFF3E2723));
        break;
      default: // 0 - Classico
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .90), width: s * .175, height: s * .072), Radius.circular(s * .03)), shoePaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s * .942), width: s * .185, height: s * .028), Radius.circular(s * .014)), solePaint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final centerX = size.width / 2;

    // 1. Sombra
    canvas.drawOval(Rect.fromCenter(center: Offset(centerX, s * .965), width: s * .55, height: s * .07), Paint()..color = Colors.black.withValues(alpha: .10));

    // 2. Pernas (cor fixa)
    final legPaint = Paint()..color = config.pants;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(s * .41, s * .80), width: s * .155, height: s * .26), Radius.circular(s * .055)), legPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(s * .59, s * .80), width: s * .155, height: s * .26), Radius.circular(s * .055)), legPaint);

    // 3. Camisa e detalhes
    final shirtPath = Path()
      ..moveTo(s * .27, s * .62)
      ..quadraticBezierTo(s * .50, s * .53, s * .73, s * .62)
      ..lineTo(s * .80, s * .80)
      ..lineTo(s * .20, s * .80)
      ..close();
    canvas.drawPath(shirtPath, Paint()..color = (config.shirtStyle == 2) ? Colors.white : config.shirt);

    if (config.shirtStyle == 1) {
      final stripePaint = Paint()
        ..color = Colors.white.withValues(alpha: .35)
        ..strokeWidth = s * .045;
      canvas.drawLine(Offset(s * .37, s * .60), Offset(s * .33, s * .80), stripePaint);
      canvas.drawLine(Offset(s * .63, s * .60), Offset(s * .67, s * .80), stripePaint);
    } else if (config.shirtStyle == 2) {
      final jacketPaint = Paint()..color = const Color(0xFF212121);
      canvas.drawPath(
          Path()
            ..moveTo(s * .27, s * .62)
            ..lineTo(s * .42, s * .62)
            ..lineTo(s * .47, s * .80)
            ..lineTo(s * .20, s * .80)
            ..close(),
          jacketPaint);
      canvas.drawPath(
          Path()
            ..moveTo(s * .73, s * .62)
            ..lineTo(s * .58, s * .62)
            ..lineTo(s * .53, s * .80)
            ..lineTo(s * .80, s * .80)
            ..close(),
          jacketPaint);
      final tiePaint = Paint()..color = kRed;
      canvas.drawPath(
          Path()
            ..moveTo(s * .47, s * .62)
            ..lineTo(s * .53, s * .62)
            ..lineTo(s * .50, s * .74)
            ..close(),
          tiePaint);
    } else if (config.shirtStyle == 3) {
      final textPainter = TextPainter(
        text: TextSpan(text: 'ANGLO', style: TextStyle(color: Colors.white, fontSize: s * .10, fontWeight: FontWeight.w900)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(centerX - (textPainter.width / 2), s * .655));
    }

    // 4. Tenis
    _drawShoe(canvas, s, s * .41);
    _drawShoe(canvas, s, s * .59);

    // 5. Pescoco e cabeca
    final skinPaint = Paint()..color = config.skin;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(centerX, s * .52), width: s * .18, height: s * .18), Radius.circular(s * .04)), skinPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(centerX, s * .36), width: s * .48, height: s * .43), Radius.circular(s * .18)), skinPaint);

    canvas.drawCircle(Offset(s * .26, s * .38), s * .055, skinPaint);
    canvas.drawCircle(Offset(s * .74, s * .38), s * .055, skinPaint);

    // 6. Cabelos por genero
    final hairPaint = Paint()..color = config.hair;
    final bool isFemale = gender == 'Feminino';

    if (isFemale) {
      if (config.hairStyle == 0) {
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s * .22, s * .14, s * .56, s * .40), Radius.circular(s * .09)), hairPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(centerX, s * .36), width: s * .48, height: s * .43), Radius.circular(s * .18)), skinPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s * .26, s * .14, s * .48, s * .14), Radius.circular(s * .06)), hairPaint);
      } else if (config.hairStyle == 1) {
        canvas.drawCircle(Offset(s * .20, s * .25), s * .10, hairPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s * .26, s * .14, s * .48, s * .18), Radius.circular(s * .09)), hairPaint);
      } else if (config.hairStyle == 2) {
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s * .22, s * .14, s * .56, s * .30), Radius.circular(s * .09)), hairPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(centerX, s * .36), width: s * .48, height: s * .43), Radius.circular(s * .18)), skinPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s * .26, s * .14, s * .48, s * .14), Radius.circular(s * .06)), hairPaint);
      } else {
        canvas.drawCircle(Offset(centerX, s * .10), s * .09, hairPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s * .26, s * .14, s * .48, s * .18), Radius.circular(s * .09)), hairPaint);
      }
    } else {
      if (config.hairStyle == 0) {
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s * .26, s * .14, s * .48, s * .18), Radius.circular(s * .09)), hairPaint);
      } else if (config.hairStyle == 1) {
        canvas.drawPath(
            Path()
              ..moveTo(s * .25, s * .29)
              ..quadraticBezierTo(s * .34, s * .06, s * .55, s * .12)
              ..quadraticBezierTo(s * .74, s * .02, s * .78, s * .29)
              ..close(),
            hairPaint);
      } else if (config.hairStyle == 2) {
        // Careca - nenhum cabelo, so um brilho na testa
        canvas.drawArc(
          Rect.fromLTWH(s * .34, s * .18, s * .17, s * .11),
          pi * 1.12,
          pi * .55,
          false,
          Paint()
            ..color = Colors.white.withValues(alpha: .35)
            ..style = PaintingStyle.stroke
            ..strokeWidth = s * .014
            ..strokeCap = StrokeCap.round,
        );
      } else {
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s * .27, s * .12, s * .46, s * .10), Radius.circular(s * .02)), hairPaint);
      }
    }

    // 7. Olhos e sobrancelhas
    final eyePaint = Paint()..color = config.eyeColor;
    canvas.drawCircle(Offset(s * .40, s * .39), s * .028, eyePaint);
    canvas.drawCircle(Offset(s * .60, s * .39), s * .028, eyePaint);

    final browPaint = Paint()
      ..color = config.hair
      ..strokeWidth = s * .018
      ..strokeCap = StrokeCap.round;
    if (config.faceStyle == 2) {
      canvas.drawLine(Offset(s * .33, s * .32), Offset(s * .46, s * .36), browPaint);
      canvas.drawLine(Offset(s * .67, s * .32), Offset(s * .54, s * .36), browPaint);
    } else if (config.faceStyle == 3) {
      canvas.drawLine(Offset(s * .33, s * .36), Offset(s * .46, s * .33), browPaint);
      canvas.drawLine(Offset(s * .67, s * .36), Offset(s * .54, s * .33), browPaint);
    } else {
      canvas.drawLine(Offset(s * .35, s * .345), Offset(s * .45, s * .34), browPaint);
      canvas.drawLine(Offset(s * .55, s * .34), Offset(s * .65, s * .345), browPaint);
    }

    // 8. Boca
    final mouthPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * .018
      ..strokeCap = StrokeCap.round;
    if (config.faceStyle == 0 || config.faceStyle == 2) {
      canvas.drawLine(Offset(s * .44, s * .49), Offset(s * .56, s * .49), mouthPaint);
    } else if (config.faceStyle == 1) {
      canvas.drawArc(Rect.fromCenter(center: Offset(centerX, s * .46), width: s * .16, height: s * .13), 0, pi, false, mouthPaint);
    } else if (config.faceStyle == 3) {
      canvas.drawArc(Rect.fromCenter(center: Offset(centerX, s * .53), width: s * .16, height: s * .13), pi, pi, false, mouthPaint);
    }

    // 9. Acessorios (oculos, brinco, coroa e chapeus)
    if (config.accessoryStyle != 0) {
      final accPaint = Paint()..color = config.accessory;
      final bandPaint = Paint()..color = config.accessory.computeLuminance() > .5 ? Colors.black54 : Colors.white70;

      switch (config.accessoryStyle) {
        case 1: // Oculos
          final glasses = Paint()
            ..color = config.accessory
            ..style = PaintingStyle.stroke
            ..strokeWidth = s * .025;
          canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s * .33, s * .35, s * .15, s * .10), Radius.circular(s * .03)), glasses);
          canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s * .52, s * .35, s * .15, s * .10), Radius.circular(s * .03)), glasses);
          canvas.drawLine(Offset(s * .48, s * .40), Offset(s * .52, s * .40), glasses);
          break;

        case 2: // Oculos escuro
          final haste = Paint()
            ..color = config.accessory
            ..strokeWidth = s * .02
            ..strokeCap = StrokeCap.round;
          canvas.drawLine(Offset(s * .23, s * .365), Offset(s * .30, s * .378), haste);
          canvas.drawLine(Offset(s * .77, s * .365), Offset(s * .70, s * .378), haste);
          canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s * .30, s * .345, s * .18, s * .10), Radius.circular(s * .03)), accPaint);
          canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s * .52, s * .345, s * .18, s * .10), Radius.circular(s * .03)), accPaint);
          canvas.drawRect(Rect.fromLTWH(s * .475, s * .375, s * .05, s * .022), accPaint);
          final shine = Paint()
            ..color = Colors.white.withValues(alpha: .40)
            ..strokeWidth = s * .018
            ..strokeCap = StrokeCap.round;
          canvas.drawLine(Offset(s * .335, s * .425), Offset(s * .395, s * .368), shine);
          canvas.drawLine(Offset(s * .555, s * .425), Offset(s * .615, s * .368), shine);
          break;

        case 3: // Brinco
          canvas.drawCircle(Offset(s * .24, s * .41), s * .018, accPaint);
          canvas.drawCircle(Offset(s * .76, s * .41), s * .018, accPaint);
          break;

        case 4: // Coroa
          canvas.drawPath(
              Path()
                ..moveTo(s * .34, s * .15)
                ..lineTo(s * .38, s * .06)
                ..lineTo(s * .50, s * .13)
                ..lineTo(s * .61, s * .05)
                ..lineTo(s * .67, s * .15)
                ..close(),
              accPaint);
          break;

        case 5: // Cartola
          canvas.drawOval(Rect.fromCenter(center: Offset(centerX, s * .16), width: s * .68, height: s * .075), accPaint);
          canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(s * .335, s * .015, s * .33, s * .15), Radius.circular(s * .018)), accPaint);
          canvas.drawRect(Rect.fromLTWH(s * .335, s * .112, s * .33, s * .038), bandPaint);
          break;

        case 6: // Fedora
          canvas.drawOval(Rect.fromCenter(center: Offset(centerX, s * .175), width: s * .76, height: s * .09), accPaint);
          canvas.drawPath(
              Path()
                ..moveTo(s * .32, s * .178)
                ..quadraticBezierTo(s * .33, s * .055, s * .50, s * .088)
                ..quadraticBezierTo(s * .67, s * .055, s * .68, s * .178)
                ..close(),
              accPaint);
          canvas.drawRect(Rect.fromLTWH(s * .32, s * .132, s * .36, s * .042), bandPaint);
          break;

        case 7: // Bone
          canvas.drawArc(Rect.fromCenter(center: Offset(centerX, s * .18), width: s * .52, height: s * .30), pi, pi, true, accPaint);
          canvas.drawOval(Rect.fromLTWH(s * .28, s * .163, s * .44, s * .055), accPaint);
          canvas.drawCircle(Offset(centerX, s * .042), s * .022, bandPaint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant AvatarPainter oldDelegate) => true;
}

// ============================================================
// MAPA GIGANTE
// ============================================================

class BigMapScreen extends StatefulWidget {
  final Place? focusPlace;
  final bool compact;
  const BigMapScreen({super.key, this.focusPlace, this.compact = false});
  @override
  State<BigMapScreen> createState() => _BigMapScreenState();
}

class _BigMapScreenState extends State<BigMapScreen> {
  final TransformationController controller = TransformationController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void resetMap() => controller.value = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    final map = SizedBox(
      width: 3000,
      height: 2500,
      child: Stack(
        children: [
          CustomPaint(size: const Size(3000, 2500), painter: CityMapPainter()),
          ...appState.places.map((p) => Positioned(left: p.x - 48, top: p.y - 48, child: MapPlacePin(place: p))),
          if (widget.focusPlace != null) Positioned(left: widget.focusPlace!.x - 25, top: widget.focusPlace!.y - 25, child: const PulseLocationMarker()),
        ],
      ),
    );

    final mapBody = InteractiveViewer(transformationController: controller, constrained: false, minScale: .25, maxScale: 4.0, boundaryMargin: const EdgeInsets.all(500), panEnabled: true, scaleEnabled: true, child: map);

    if (widget.compact) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: Stack(children: [Positioned.fill(child: ColoredBox(color: const Color(0xFFEFF3F5), child: mapBody)), Positioned(top: 15, right: 15, child: IconButton.filledTonal(onPressed: resetMap, icon: const Icon(Icons.center_focus_strong)))]),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa do Universo PRO', style: TextStyle(fontWeight: FontWeight.w900)), actions: [IconButton(tooltip: 'Centralizar', onPressed: resetMap, icon: const Icon(Icons.center_focus_strong))]),
      body: Stack(
        children: [
          Positioned.fill(child: ColoredBox(color: const Color(0xFFEFF3F5), child: mapBody)),
          const Positioned(left: 18, bottom: 18, child: MapLegend()),
          Positioned(
            right: 18,
            bottom: 18,
            child: Column(children: [FloatingActionButton.small(heroTag: 'zoom_in', onPressed: () => controller.value = controller.value.scaled(1.25), child: const Icon(Icons.add)), const SizedBox(height: 8), FloatingActionButton.small(heroTag: 'zoom_out', onPressed: () => controller.value = controller.value.scaled(.8), child: const Icon(Icons.remove))]),
          ),
        ],
      ),
    );
  }
}

class MapPlacePin extends StatefulWidget {
  final Place place;
  const MapPlacePin({super.key, required this.place});
  @override
  State<MapPlacePin> createState() => _MapPlacePinState();
}

class _MapPlacePinState extends State<MapPlacePin> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.place.category == ActivityCategory.lazer ? kPurple : kGreen;
    return AnimatedBuilder(
      animation: controller,
      builder: (c, child) => Transform.translate(offset: Offset(0, -controller.value * 4), child: child),
      child: Column(
        children: [
          Container(width: 52, height: 52, decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))]), child: Icon(widget.place.icon, color: Colors.white, size: 27)),
          const SizedBox(height: 4),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)]), child: Text(widget.place.name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900))),
        ],
      ),
    );
  }
}

class PulseLocationMarker extends StatefulWidget {
  const PulseLocationMarker({super.key});
  @override
  State<PulseLocationMarker> createState() => _PulseLocationMarkerState();
}

class _PulseLocationMarkerState extends State<PulseLocationMarker> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (c, child) => Stack(
        alignment: Alignment.center,
        children: [
          Container(width: 35 + controller.value * 25, height: 35 + controller.value * 25, decoration: BoxDecoration(shape: BoxShape.circle, color: kRed.withValues(alpha: .25 * (1 - controller.value)))),
          Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: kRed, border: Border.all(color: Colors.white, width: 4)), child: const Icon(Icons.navigation, color: Colors.white, size: 22)),
        ],
      ),
    );
  }
}

class MapLegend extends StatelessWidget {
  const MapLegend({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: .95), borderRadius: BorderRadius.circular(17), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('MAPA', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)), const SizedBox(height: 8), _item(kGreen, 'Esporte'), const SizedBox(height: 5), _item(kPurple, 'Lazer')]),
    );
  }

  Widget _item(Color c, String t) => Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle)), const SizedBox(width: 7), Text(t, style: const TextStyle(fontSize: 11))]);
}

class CityMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFEFF3F5));
    canvas.drawRect(Rect.fromLTWH(2600, 0, 400, size.height), Paint()..color = const Color(0xFFFDEBD0));
    canvas.drawRect(Rect.fromLTWH(2850, 0, 150, size.height), Paint()..color = const Color(0xFF85C1E9));

    final parkPaint = Paint()..color = const Color(0xFFDCEFD8);
    for (final rect in [const Rect.fromLTWH(70, 70, 390, 300), const Rect.fromLTWH(1050, 80, 700, 300), const Rect.fromLTWH(690, 900, 500, 450), const Rect.fromLTWH(1800, 800, 600, 500), const Rect.fromLTWH(400, 1500, 800, 400), const Rect.fromLTWH(60, 1380, 300, 420), const Rect.fromLTWH(1380, 1700, 420, 360)]) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(55)), parkPaint);
    }

    final river = Path()
      ..moveTo(0, 530)
      ..quadraticBezierTo(430, 370, 880, 570)
      ..quadraticBezierTo(1360, 800, 2700, 560)
      ..lineTo(2700, 710)
      ..quadraticBezierTo(1360, 950, 880, 720)
      ..quadraticBezierTo(420, 500, 0, 690)
      ..close();
    canvas.drawPath(river, Paint()..color = const Color(0xFFD6ECF7));

    // Lago dos caiaques
    canvas.drawOval(const Rect.fromLTWH(2180, 1620, 340, 280), Paint()..color = const Color(0xFFD6ECF7));

    final streetPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;
    for (double x = 60; x < size.width; x += 200) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), streetPaint);
    }
    for (double y = 60; y < size.height; y += 200) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), streetPaint);
    }

    final avenuePaint = Paint()
      ..color = const Color(0xFFD4DADD)
      ..strokeWidth = 55
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(0, 410), Offset(size.width, 1070), avenuePaint);
    canvas.drawLine(const Offset(500, 0), Offset(1100, size.height), avenuePaint);
    canvas.drawLine(const Offset(2200, 0), Offset(1800, size.height), avenuePaint);
  }

  @override
  bool shouldRepaint(covariant CityMapPainter oldDelegate) => false;
}

// ============================================================
// CHAT
// ============================================================

class ChatScreen extends StatefulWidget {
  final Activity activity;
  const ChatScreen({super.key, required this.activity});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final List<ChatMessage> messages = [const ChatMessage(name: 'Lucas', text: 'Bora!', mine: false), const ChatMessage(name: 'Bia', text: 'Chego antes.', mine: false)];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void send() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      messages.add(ChatMessage(name: appState.name, text: controller.text.trim(), mine: true));
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.activity.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)), Text('Chat de ${widget.activity.type}', style: const TextStyle(fontSize: 11, color: Colors.grey))])),
      body: Column(
        children: [
          Expanded(child: ListView.builder(padding: const EdgeInsets.all(18), itemCount: messages.length, itemBuilder: (c, i) => ChatBubble(message: messages[i]))),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -3))]),
            child: Row(children: [Expanded(child: TextField(controller: controller, onSubmitted: (_) => send(), decoration: InputDecoration(hintText: 'Digite...', filled: true, fillColor: kBackground, border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none)))), const SizedBox(width: 8), IconButton.filled(onPressed: send, icon: const Icon(Icons.send))]),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String name;
  final String text;
  final bool mine;
  const ChatMessage({required this.name, required this.text, required this.mine});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 310),
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: message.mine ? kGreen.withValues(alpha: .12) : Colors.white, borderRadius: BorderRadius.circular(17)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [if (!message.mine) Text(message.name, style: const TextStyle(fontSize: 11, color: kGreen, fontWeight: FontWeight.w900)), if (!message.mine) const SizedBox(height: 3), Text(message.text, style: const TextStyle(fontSize: 14))]),
      ),
    );
  }
}

// ============================================================
// COMPONENTES & HELPERS
// ============================================================

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900));
}

class QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const QuickActionCard({super.key, required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 43, height: 43, decoration: BoxDecoration(color: color.withValues(alpha: .12), shape: BoxShape.circle), child: Icon(icon, color: color)), const Spacer(), Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11))]),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const EmptyState({super.key, required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(width: 75, height: 75, decoration: BoxDecoration(color: kGreen.withValues(alpha: .10), shape: BoxShape.circle), child: Icon(icon, size: 34, color: kGreen)), const SizedBox(height: 15), Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey))]),
      ),
    );
  }
}

InputDecoration appInputDecoration(String label, IconData icon) => InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: const BorderSide(color: kGreen, width: 2)),
    );

IconData activityIcon(String type) {
  switch (type) {
    case 'Basquete':
      return Icons.sports_basketball;
    case 'Vôlei':
      return Icons.sports_volleyball;
    case 'Vôlei de Praia':
      return Icons.sports_volleyball;
    case 'Futevôlei':
      return Icons.sports_volleyball;
    case 'Tênis':
      return Icons.sports_tennis;
    case 'Corrida':
      return Icons.directions_run;
    case 'Ciclismo':
      return Icons.directions_bike;
    case 'Natação':
      return Icons.pool;
    case 'Caiaque':
      return Icons.rowing;
    case 'Trilha':
      return Icons.directions_walk;
    case 'Musculação':
      return Icons.fitness_center;
    case 'Artes Marciais':
      return Icons.sports_martial_arts;
    case 'Skate':
      return Icons.skateboarding;
    case 'Cinema':
      return Icons.movie;
    case 'Teatro':
      return Icons.theater_comedy;
    case 'Show':
      return Icons.mic;
    case 'Praia':
      return Icons.beach_access;
    case 'Camping':
      return Icons.nature_people;
    case 'Restaurante':
      return Icons.restaurant;
    case 'Museu':
      return Icons.account_balance;
    case 'Feira':
      return Icons.store;
    case 'Games':
      return Icons.sports_esports;
    case 'Compras':
      return Icons.shopping_cart;
    case 'Parque':
      return Icons.park;
    case 'Caminhada':
      return Icons.directions_walk;
    case 'Boliche':
      return Icons.sports;
    case 'Passeio':
      return Icons.explore;
    default:
      return Icons.sports_soccer;
  }
}
