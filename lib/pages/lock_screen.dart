import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../services/auth_service.dart';

class LockScreen extends StatefulWidget {
  final Widget child;
  final bool requireAuth;

  const LockScreen({
    super.key,
    required this.child,
    this.requireAuth = true,
  });

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> with WidgetsBindingObserver {
  final AuthService _auth = AuthService();
  bool _isLocked = true;
  bool _isLoading = true;
  bool _hasBiometrics = false;
  String _appState = 'active';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAuth();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      setState(() {
        _isLocked = true;
        _appState = 'background';
      });
    }
  }

 Future<void> _checkAuth() async {
    setState(() => _isLoading = true);
    
    final lockEnabled = await _auth.isLockEnabled();
    final hasBio = await _auth.hasBiometrics();
    
    setState(() {
      _hasBiometrics = hasBio;
      _isLoading = false;
      
      // CORREGIDO: Solo bloquear si el bloqueo está activado
      if (!lockEnabled || !widget.requireAuth) {
        _isLocked = false;
      }
    });
    
    // Solo autenticar si el bloqueo está activado
    if (lockEnabled && widget.requireAuth) {
      _authenticate();
    }
  }

  // En el método _authenticate, cambia:
Future<void> _authenticate() async {
  // Primero intenta con biometría si está disponible
  if (_hasBiometrics) {
    final success = await _auth.authenticateWithBiometrics(
      reason: 'Autentícate para acceder a tus finanzas',
    );
    if (mounted) {
      if (success) {
        setState(() => _isLocked = false);
      } else {
        // Si falla la biometría, ofrecer PIN
        _showPinDialog();
      }
    }
  } else {
    _showPinDialog();
  }
}

  void _showPinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PinDialog(
        onUnlock: () {
          Navigator.pop(ctx);
          setState(() => _isLocked = false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

     // Si no está bloqueado, mostrar la app directamente
    if (!_isLocked) {
      return widget.child;
    }


    if (_isLocked) {
      return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  _hasBiometrics ? Icons.fingerprint : Icons.lock,
                  size: 50,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'ExchangeRate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Protege tus finanzas',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: _hasBiometrics ? _authenticate : _showPinDialog,
                icon: Icon(
                  _hasBiometrics ? Icons.fingerprint : Icons.lock_open,
                  size: 24,
                ),
                label: Text(
                  _hasBiometrics ? 'Usar Huella' : 'Ingresar PIN',
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}

// Diálogo de PIN
class PinDialog extends StatefulWidget {
  final VoidCallback onUnlock;

  const PinDialog({super.key, required this.onUnlock});

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final _pinController = TextEditingController();
  final AuthService _auth = AuthService();
  String _pin = '';
  String _error = '';

  void _addDigit(String digit) {
    if (_pin.length < 4) {
      setState(() {
        _pin += digit;
        _error = '';
      });
      
      if (_pin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  Future<void> _verifyPin() async {
    final valid = await _auth.verifyPin(_pin);
    if (valid) {
      widget.onUnlock();
    } else {
      setState(() {
        _pin = '';
        _error = 'PIN incorrecto';
      });
      // Vibrar
      HapticFeedback.heavyImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Center(child: Text('Ingresa tu PIN')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador de dígitos
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              return Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < _pin.length 
                      ? AppColors.primaryColor 
                      : Colors.grey[300],
                ),
              );
            }),
          ),
          
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(_error, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ],
          
          const SizedBox(height: 20),
          
          // Teclado numérico
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildKey('1'), _buildKey('2'), _buildKey('3'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildKey('4'), _buildKey('5'), _buildKey('6'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildKey('7'), _buildKey('8'), _buildKey('9'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildKey('', isEmpty: true),
                  _buildKey('0'),
                  _buildKey('⌫', isDelete: true),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String label, {bool isEmpty = false, bool isDelete = false}) {
    if (isEmpty) return const SizedBox(width: 70, height: 70);
    
    return SizedBox(
      width: 70,
      height: 70,
      child: TextButton(
        onPressed: () {
          if (isDelete) {
            _removeDigit();
          } else {
            _addDigit(label);
          }
        },
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.grey.withOpacity(0.1),
        ),
        child: isDelete
            ? Icon(Icons.backspace_outlined, color: AppColors.primaryColor)
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
      ),
    );
  }
}