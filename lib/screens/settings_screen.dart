import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';
import 'package:southsea_cinema/models/user_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    this.themeMode = ThemeMode.dark,
    this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String _nameKey = 'cinema_name';
  static const String _addressKey = 'cinema_address';
  static const String _emailKey = 'cinema_email';
  static const String _patronKey = 'cinema_patron_number';
  static const String _newsletterKey = 'cinema_receive_newsletter';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _patronController;

  bool _receiveNewsletter = false;
  String _confirmationMessage = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _patronController = TextEditingController();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final String name = await _preferences.getString(_nameKey) ?? '';
    final String address = await _preferences.getString(_addressKey) ?? '';
    final String email = await _preferences.getString(_emailKey) ?? '';
    final String patronNumber = await _preferences.getString(_patronKey) ?? '';
    final bool receiveNewsletter =
        await _preferences.getBool(_newsletterKey) ?? false;

    if (!mounted) return;

    setState(() {
      _nameController.text = name;
      _addressController.text = address;
      _emailController.text = email;
      _patronController.text = patronNumber;
      _receiveNewsletter = receiveNewsletter;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _patronController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final String name = _nameController.text.trim();
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();
    final String patronNumber = _patronController.text.trim();

    final UserSettings settings = UserSettings(
      name: name,
      address: address,
      email: email,
      patronNumber: patronNumber,
      receiveNewsletter: _receiveNewsletter,
    );

    await _preferences.setString(_nameKey, settings.name);
    await _preferences.setString(_addressKey, settings.address);
    await _preferences.setString(_emailKey, settings.email);
    await _preferences.setString(_patronKey, settings.patronNumber);
    await _preferences.setBool(
      _newsletterKey,
      settings.receiveNewsletter,
    );

    if (!mounted) return;

    setState(() {
      _confirmationMessage = 'Settings saved for ${settings.name}';
    });
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: colors.onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.surfaceContainerHighest,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Settings',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField('Full Name', _nameController),
            const SizedBox(height: 24),
            _buildTextField(
              'Address',
              _addressController,
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            _buildTextField('Email Address', _emailController),
            const SizedBox(height: 24),
            _buildTextField('Patron Number', _patronController),
            const SizedBox(height: 32),
            Text(
              'Preferences',
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Receive news by email',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ),
                Switch(
                  value: _receiveNewsletter,
                  onChanged: (bool value) {
                    setState(() {
                      _receiveNewsletter = value;
                    });
                  },
                ),
              ],
            ),
            if (widget.onThemeModeChanged != null)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Light mode'),
                value: widget.themeMode == ThemeMode.light,
                onChanged: (bool useLightMode) {
                  widget.onThemeModeChanged?.call(
                    useLightMode ? ThemeMode.light : ThemeMode.dark,
                  );
                },
              ),
            const SizedBox(height: 32),
            Row(
              children: [
                PrimaryButton(
                  label: 'CANCEL',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 16),
                PrimaryButton(
                  label: 'SAVE SETTINGS',
                  onPressed: _saveSettings,
                ),
              ],
            ),
            if (_confirmationMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _confirmationMessage,
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}