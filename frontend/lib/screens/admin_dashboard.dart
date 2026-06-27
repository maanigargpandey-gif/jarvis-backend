import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final data = await ApiService.getAdminDashboard();
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isCreator) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0E21),
        body: const Center(
          child: Text(
            'Access Denied: Creator Only',
            style: TextStyle(color: Colors.redAccent, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'ADMIN DASHBOARD',
          style: TextStyle(color: Colors.amberAccent, letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildDashboard(),
    );
  }

  Widget _buildDashboard() {
    final stats = _dashboardData?['system_stats'] ?? {};
    final actions = _dashboardData?['quick_actions'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Creator Info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amberAccent.withOpacity(0.2), Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amberAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.amberAccent,
                  child: Icon(Icons.person, size: 35, color: Colors.black),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mani Pandey',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _dashboardData?['creator']?['mode'] ?? 'God Mode Active',
                      style: const TextStyle(color: Colors.amberAccent, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          // System Stats
          const Text(
            'SYSTEM STATS',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard('CPU', '${stats['cpu_usage'] ?? 0}%', Icons.memory),
              _buildStatCard('Memory', '${stats['memory_usage'] ?? 0}%', Icons.storage),
              _buildStatCard('Disk', '${stats['disk_usage'] ?? 0}%', Icons.disc_full),
              _buildStatCard('Uptime', _formatUptime(stats['uptime'] ?? 0), Icons.timer),
            ],
          ),
          const SizedBox(height: 30),
          
          // Quick Actions
          const Text(
            'QUICK ACTIONS',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...actions.map((action) => ListTile(
            leading: Icon(_getActionIcon(action['name']), color: Colors.cyanAccent),
            title: Text(action['name'], style: const TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Executing ${action['name']}...')),
              );
            },
          )),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  IconData _getActionIcon(String action) {
    if (action.contains('Scan')) return Icons.security;
    if (action.contains('Cache')) return Icons.cleaning_services;
    if (action.contains('Backup')) return Icons.backup;
    if (action.contains('Log')) return Icons.article;
    return Icons.settings;
  }

  String _formatUptime(double seconds) {
    final hours = (seconds / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    return '${hours}h ${minutes}m';
  }
}
