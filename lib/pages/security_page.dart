import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';  // ← AGREGAR ESTE IMPORT
import '../core/app_colors.dart';
import '../services/auth_service.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final AuthService _auth = AuthService();
  bool _lockEnabled = false;
  bool _hasBiometrics = false;
  String _biometricType = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    final lockEnabled = await _auth.isLockEnabled();
    final hasBio = await _auth.hasBiometrics();
    
    String bioType = '';
    if (hasBio) {
      final types = await _auth.getAvailableBiometrics();
      if (types.contains(BiometricType.face)) {
        bioType = 'Reconocimiento facial';
      } else if (types.contains(BiometricType.fingerprint)) {
        bioType = 'Huella digital';
      } else {
        bioType = 'Biometría';
      }
    }
    
    setState(() {
      _lockEnabled = lockEnabled;
      _hasBiometrics = hasBio;
      _biometricType = bioType;
      _isLoading = false;
    });
  }

  Future<void> _toggleLock(bool value) async {
    if (value) {
      _showCreatePinDialog();
    } else {
      await _auth.disableLock();
      setState(() => _lockEnabled = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🔓 Bloqueo desactivado')),
      );
    }
  }

  void _showCreatePinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CreatePinDialog(
        onPinCreated: (pin) async {
          await _auth.savePin(pin);
          Navigator.pop(ctx);
          setState(() => _lockEnabled = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🔒 Bloqueo activado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _showChangePinDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ChangePinDialog(),
    );
  }

  Future<void> _testBiometric() async {
    final success = await _auth.authenticateWithBiometrics(
      reason: 'Verifica tu identidad',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '✅ Autenticación exitosa' : '❌ Falló la autenticación'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seguridad')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Estado de seguridad
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _lockEnabled
                          ? [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)]
                          : [Colors.grey.withOpacity(0.1), Colors.grey.withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _lockEnabled ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _lockEnabled ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _lockEnabled ? Icons.shield : Icons.shield_outlined,
                          size: 32,
                          color: _lockEnabled ? Colors.green : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _lockEnabled ? 'Protegido' : 'Sin protección',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _lockEnabled ? Colors.green : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _lockEnabled ? 'Tus datos financieros están seguros' : 'Activa el bloqueo para proteger tus finanzas',
                              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Toggle bloqueo
                Card(
                  child: SwitchListTile(
                    title: const Text('Activar bloqueo',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Text(_hasBiometrics 
                        ? 'Usa $_biometricType o PIN' 
                        : 'Usa PIN de 4 dígitos'),
                    value: _lockEnabled,
                    onChanged: _toggleLock,
                    activeColor: AppColors.primaryColor,
                  ),
                ),

                if (_lockEnabled) ...[
                  const SizedBox(height: 16),

                  // Opciones de seguridad
                  Card(
                    child: Column(
                      children: [
                        // Cambiar PIN
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.lock_reset, color: AppColors.primaryColor),
                          ),
                          title: const Text('Cambiar PIN'),
                          subtitle: const Text('Modifica tu PIN de acceso'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _showChangePinDialog,
                        ),

                        if (_hasBiometrics) ...[
                          const Divider(height: 1),
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _biometricType.contains('facial') ? Icons.face : Icons.fingerprint,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            title: Text(_biometricType),
                            subtitle: const Text('Configurado y activo'),
                            trailing: Icon(Icons.check_circle, color: Colors.green[400]),
                            onTap: _testBiometric,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

// Diálogo para crear PIN (COMPLETO CON TECLADO)
class CreatePinDialog extends StatefulWidget {
  final Function(String) onPinCreated;

  const CreatePinDialog({super.key, required this.onPinCreated});

  @override
  State<CreatePinDialog> createState() => _CreatePinDialogState();
}

class _CreatePinDialogState extends State<CreatePinDialog> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String _error = '';

  void _addDigit(String digit) {
    HapticFeedback.lightImpact();
    
    if (_isConfirming) {
      if (_confirmPin.length < 4) {
        setState(() {
          _confirmPin += digit;
          _error = '';
        });
        if (_confirmPin.length == 4) {
          if (_confirmPin == _pin) {
            widget.onPinCreated(_pin);
          } else {
            setState(() {
              _error = 'Los PIN no coinciden';
              _confirmPin = '';
              _isConfirming = false;
              _pin = '';
            });
            HapticFeedback.heavyImpact();
          }
        }
      }
    } else {
      if (_pin.length < 4) {
        setState(() {
          _pin += digit;
          _error = '';
        });
        if (_pin.length == 4) {
          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() => _isConfirming = true);
          });
        }
      }
    }
  }

  void _removeDigit() {
    HapticFeedback.lightImpact();
    if (_isConfirming && _confirmPin.isNotEmpty) {
      setState(() => _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1));
    } else if (!_isConfirming && _pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        children: [
          Icon(
            _isConfirming ? Icons.lock : Icons.lock_outline,
            size: 40,
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: 8),
          Text(
            _isConfirming ? 'Confirma tu PIN' : 'Crea tu PIN',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            _isConfirming ? 'Vuelve a ingresar el PIN' : 'Ingresa un PIN de 4 dígitos',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador de dígitos
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final filled = _isConfirming 
                  ? i < _confirmPin.length 
                  : i < _pin.length;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 16,
                height: 16,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled ? AppColors.primaryColor : AppColors.darkTextSecondary,
                  border: Border.all(
                    color: filled ? AppColors.primaryColor : AppColors.darkTextSecondary,
                    width: 2,
                  ),
                ),
              );
            }),
          ),
          
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(_error, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ],
          
          const SizedBox(height: 24),
          
          // Teclado numérico
          _buildKeypad(),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKey('1'), const SizedBox(width: 16),
            _buildKey('2'), const SizedBox(width: 16),
            _buildKey('3'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKey('4'), const SizedBox(width: 16),
            _buildKey('5'), const SizedBox(width: 16),
            _buildKey('6'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKey('7'), const SizedBox(width: 16),
            _buildKey('8'), const SizedBox(width: 16),
            _buildKey('9'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 65, height: 55),
            const SizedBox(width: 16),
            _buildKey('0'),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: _removeDigit,
              child: Container(
                width: 65,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.1),
                ),
                child: const Icon(Icons.backspace_outlined, color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String digit) {
    return GestureDetector(
      onTap: () => _addDigit(digit),
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor.withOpacity(0.05),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.2), width: 1.5),
        ),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

// Diálogo para cambiar PIN (COMPLETO)
class ChangePinDialog extends StatefulWidget {
  const ChangePinDialog({super.key});

  @override
  State<ChangePinDialog> createState() => _ChangePinDialogState();
}

class _ChangePinDialogState extends State<ChangePinDialog> {
  final AuthService _auth = AuthService();
  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.lock_reset, color: AppColors.primaryColor),
          SizedBox(width: 8),
          Text('Cambiar PIN'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _oldPinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'PIN actual',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _newPinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Nuevo PIN',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(_error, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () async {
            if (_oldPinController.text.length != 4 || _newPinController.text.length != 4) {
              setState(() => _error = 'El PIN debe ser de 4 dígitos');
              return;
            }
            final success = await _auth.changePin(
              _oldPinController.text,
              _newPinController.text,
            );
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success ? '✅ PIN cambiado correctamente' : '❌ PIN actual incorrecto'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            }
          },
          child: const Text('Cambiar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    super.dispose();
  }
}