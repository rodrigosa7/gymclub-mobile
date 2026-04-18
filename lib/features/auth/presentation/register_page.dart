import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/gymclub_theme.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    required this.api,
    required this.onRegister,
  });

  final dynamic api;
  final void Function() onRegister;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      debugPrint('REGISTER: calling api.register');
      await widget.api.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        preferredWeightUnit: 'kg',
      );
      debugPrint('REGISTER: api.register succeeded, calling onRegister');
      widget.onRegister();
      debugPrint('REGISTER: onRegister called');
    } catch (e) {
      debugPrint('REGISTER: error = $e');
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GymClubTheme.surface,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeroSection(),
                          const SizedBox(height: 32),
                          _buildRegistrationForm(),
                          const SizedBox(height: 32),
                          _buildStats(),
                          const SizedBox(height: 32),
                          _buildSocialIntegration(),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildLiveStatsBanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'GYM CLUB',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: GymClubTheme.primary,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => LoginPage(
                    api: widget.api,
                    onLogin: widget.onRegister,
                  ),
                ),
              );
            },
            child: const Text(
              'Member? Login',
              style: TextStyle(
                color: GymClubTheme.primaryContainer,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        // Kinetic text effect - "START"
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              GymClubTheme.primary.withValues(alpha: 0.6),
              GymClubTheme.primary.withValues(alpha: 0.3),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: const Text(
            'START',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 72,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -2,
              height: 1,
            ),
          ),
        ),
        // "EVOLVING" text
        const Text(
          'EVOLVING',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 72,
            fontWeight: FontWeight.w700,
            color: GymClubTheme.primary,
            letterSpacing: -2,
            height: 1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Enter the high-performance laboratory.\nYour biological optimization begins now.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: GymClubTheme.onSurfaceVariant,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFb92902).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: GymClubTheme.error.withValues(alpha: 0.3)),
              ),
              child: Text(
                _error!,
                style: const TextStyle(color: GymClubTheme.error),
              ),
            ),
          ],
          // 01 Full Name
          _buildFormField(
            label: '01 Full Name',
            controller: _nameController,
            placeholder: 'Enter your name',
            validator: (value) {
              if (value == null || value.isEmpty) return 'Name is required';
              if (value.length < 2) return 'Name must be at least 2 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),
          // 02 Email Address
          _buildFormField(
            label: '02 Email Address',
            controller: _emailController,
            placeholder: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email is required';
              if (!value.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          // 03 Secure Access
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '03 Secure Access',
                style: TextStyle(
                  color: GymClubTheme.onSurfaceVariant,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: GymClubTheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF484847).withValues(alpha: 0.5),
                  ),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: GymClubTheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Create password',
                    hintStyle: TextStyle(color: GymClubTheme.onSurfaceVariant),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: GymClubTheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Password is required';
                    if (value.length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Submit button
          _buildGradientButton(),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: GymClubTheme.onSurfaceVariant,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: GymClubTheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF484847).withValues(alpha: 0.5),
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: GymClubTheme.onSurface),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: GymClubTheme.onSurfaceVariant),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: GymClubTheme.primaryGradient,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation(GymClubTheme.onPrimaryFixed),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Initialize Profile',
                    style: TextStyle(
                      color: GymClubTheme.onPrimaryFixed,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: GymClubTheme.onPrimaryFixed),
                ],
              ),
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            value: '9.4k',
            label: 'Active Athletes',
            tag: 'GYM',
            tagColor: GymClubTheme.secondary,
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: _buildStatItem(
            value: '120+',
            label: 'Data Metrics',
            tag: 'LAB',
            tagColor: GymClubTheme.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required String tag,
    required Color tagColor,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: GymClubTheme.primaryContainer,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: GymClubTheme.onSurfaceVariant,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          tag,
          style: TextStyle(
            color: tagColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIntegration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Social Integration',
          style: TextStyle(
            color: GymClubTheme.onSurfaceVariant,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            _buildSocialIcon('G'),
            const SizedBox(width: 8),
            _buildSocialIcon('S'),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(String letter) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainer,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF484847).withValues(alpha: 0.5),
        ),
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: GymClubTheme.onSurface,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLiveStatsBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: GymClubTheme.surfaceContainerLow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: GymClubTheme.tertiaryFixed,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '342 people joined the club in the last 24 hours.',
                  style: TextStyle(
                    color: GymClubTheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            'LIVE STATS',
            style: TextStyle(
              color: GymClubTheme.secondaryDim,
              fontSize: 10,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
