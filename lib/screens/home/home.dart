// ignore_for_file: constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tapped_coin_example/widgets/button_widget.dart';

enum Level {
  Bronze,
  Silver,
  Gold,
  Platinum,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Level level; // Default level
  int lvl = 0;

  // Define energy thresholds for each level
  final Map<Level, int> energyThresholds = {
    Level.Bronze: 500,
    Level.Silver: 1000,
    Level.Gold: 1500,
    Level.Platinum: 2000,
  };

  // Define corresponding tap energies for each level
  final Map<Level, int> tapEnergies = {
    Level.Bronze: 1,
    Level.Silver: 2,
    Level.Gold: 3,
    Level.Platinum: 4,
  };

  int energy = 0;

  int tapEnergy = 0;

  int fullEnergy = 0;

  int totalEnergy = 0;

  int restartEnergy = 0;

  int qolganEnergy = 0;

  int savedEnergy = 0;
  int boostedTapEnergy = 0;
  bool isBoosted = false;
  String referralCode = '';

  List<Task> tasks = [
    Task(name: "Task 1", coins: 100),
    Task(name: "Task 2", coins: 200),
    Task(name: "Task 3", coins: 300),
  ];

  List<Referral> referrals = [
    Referral(code: "REF123", coins: 100),
    Referral(code: "REF456", coins: 200),
    Referral(code: "REF789", coins: 300),
  ];

  @override
  void initState() {
    level = Level.Bronze;
    if (lvl == 0) {
      lvl = 1;
      energy = energyThresholds[Level.Bronze]!;
      tapEnergy = tapEnergies[Level.Bronze]!;
      fullEnergy = energyThresholds[Level.Bronze]!;
      totalEnergy = 0;
      restartEnergy = 2;
      qolganEnergy = energy;
      savedEnergy = energyThresholds[Level.Bronze]!;
      boostedTapEnergy = 5;
    }

    start();
    super.initState();
  }

  void start() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));

      if (energy >= fullEnergy) {
        setState(() {
          energy = fullEnergy;
        });
      } else if (energy < fullEnergy) {
        energy += restartEnergy;

        if (energy >= fullEnergy) {
          setState(() {
            energy = fullEnergy;
          });
        } else {
          setState(() {});
        }
      }
    }
  }

  void addEnergy() {
    final int currentTapEnergy = isBoosted ? boostedTapEnergy : tapEnergy;
    if (currentTapEnergy <= energy) {
      setState(() {
        totalEnergy += currentTapEnergy;
        energy -= currentTapEnergy;
        qolganEnergy = energy;
      });
    }

    updateLevel();
  }

  void updateLevel() {
    // Update the level based on the total energy
    if (totalEnergy >= 2000) {
      level = Level.Platinum;
    } else if (totalEnergy >= 1500) {
      level = Level.Gold;
    } else if (totalEnergy >= 1000) {
      level = Level.Silver;
    } else {
      level = Level.Bronze;
    }
  }

  void claimCoins(int coins) {
    setState(() {
      totalEnergy += coins;
    });
  }

  void activateBoost() {
    setState(() {
      isBoosted = true;
    });
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        isBoosted = false;
      });
    });
  }

  void claimReferralCoins() {
    final referral = referrals.firstWhere(
      (ref) => ref.code == referralCode,
      orElse: () => Referral(code: '', coins: 0),
    );
    if (referral.coins > 0) {
      setState(() {
        totalEnergy += referral.coins;
        referrals.remove(referral);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double appWidth = MediaQuery.sizeOf(context).width - 100;

    return Scaffold(
      backgroundColor: const Color(0xFF14213d),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14213d),
        elevation: 0,
        title: Text(
          "TapSwap Lv: ${levelToString(level)}",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: getPages(selectedIndex, appWidth)),
      bottomSheet: Container(
        height: 100,
        color: Colors.transparent,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildMenuCard(0, Icons.catching_pokemon, 'Ref'),
            buildMenuCard(1, Icons.task_sharp, 'Tasks'),
            buildMenuCard(2, Icons.money, 'Tap'),
            buildMenuCard(3, Icons.fire_hydrant, 'Boost'),
            buildMenuCard(4, Icons.line_axis_outlined, 'Status'),
          ],
        ),
      ),
    );
  }

  int selectedIndex = 2;

  getPages(int index, double appWidth) {
    switch (index) {
      case 0:
        return _buildReferralPage();
      case 1:
        return _buildTaskPage();
      case 2:
        return _buildTapPage(appWidth);
      case 3:
        return _buildBoostPage();
      case 4:
        return _buildStatisticsPage();
    }
  }

  Widget _buildReferralPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            onChanged: (value) {
              referralCode = value;
            },
            decoration: const InputDecoration(
              labelText: "Enter Referral Code",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: claimReferralCoins,
            child: const Text('Claim Coins'),
          ),
        ],
      ),
    );
  }

  _buildTapPage(double appWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 45.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        "assets/c.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      totalEnergy.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 62),
                    )
                  ],
                ),
                levelIconText(level)
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(),
              child: CoinButton(
                taper: addEnergy,
              ),
            ),
          ),
          Text(
            " ⚡️ $qolganEnergy / $savedEnergy",
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          Expanded(
            child: EnergyIndicator(
              energy: energy,
              fullEnergy: fullEnergy,
              appWidth: appWidth,
            ),
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  _buildTaskPage() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          color: const Color(0xFF14213d),
          child: ListTile(
            title: Text(task.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text('${task.coins} coins',
                style: const TextStyle(color: Colors.white70)),
            trailing: ElevatedButton(
              onPressed: () {
                claimCoins(task.coins);
                setState(() {
                  tasks.removeAt(index);
                });
              },
              child: const Text('Claim'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBoostPage() {
    return Center(
      child: isBoosted
          ? const Text(
              "Added 5 tapped boosted 🎉",
              style: TextStyle(color: Colors.white, fontSize: 24),
            )
          : ElevatedButton(
              onPressed: activateBoost,
              child: const Text('Activate Boost'),
            ),
    );
  }

  Widget _buildStatisticsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 20),
          // Add your statistics widgets here
          // For example:
          Text(
            'Total Energy: $totalEnergy',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            'Current Level: ${levelToString(level)}',
            style: const TextStyle(color: Colors.white),
          ),
          // Add more statistics as needed
        ],
      ),
    );
  }

  String levelToString(Level level) {
    switch (level) {
      case Level.Bronze:
        return 'Bronze';
      case Level.Silver:
        return 'Silver';
      case Level.Gold:
        return 'Gold';
      case Level.Platinum:
        return 'Platinum';
    }
  }

  Widget levelIconText(Level level) {
    IconData icon;
    String text;

    switch (level) {
      case Level.Bronze:
        icon = Icons.star_border;
        text = 'Bronze';
        break;
      case Level.Silver:
        icon = Icons.star_half;
        text = 'Silver';
        break;
      case Level.Gold:
        icon = Icons.star;
        text = 'Gold';
        break;
      case Level.Platinum:
        icon = Icons.star_border;
        text = 'Platinum';
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white), // Add icon before the text
        SizedBox(width: 5), // Add some space between the icon and text
        Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget buildMenuCard(int index, IconData icon, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  selectedIndex == index ? Colors.yellow : Colors.transparent,
              width: 2,
            ),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Referral {
  final String code;
  final int coins;

  Referral({required this.code, required this.coins});
}

class Task {
  final String name;
  final int coins;

  Task({required this.name, required this.coins});
}

class EnergyIndicator extends StatelessWidget {
  final int energy;
  final int fullEnergy;
  final double appWidth;

  const EnergyIndicator({
    super.key,
    required this.energy,
    required this.fullEnergy,
    required this.appWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            energy.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          Container(
            width: appWidth,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: LinearProgressIndicator(
                value: energy / fullEnergy,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 28, 48, 92),
                ),
                minHeight: 20,
                semanticsLabel: 'Energy progress indicator',
                semanticsValue: '${(energy / fullEnergy) * 100}%',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
