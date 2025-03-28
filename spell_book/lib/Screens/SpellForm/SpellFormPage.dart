import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spell_book/Models/Spell.dart';
import 'package:flutter/services.dart';
import 'SpellFormViewModel.dart';
import 'package:go_router/go_router.dart';

class SpellFormPage extends StatefulWidget {
  const SpellFormPage({super.key, required this.title});
  final String title;
  @override
  _SpellFormPageState createState() => _SpellFormPageState();
}

class _SpellFormPageState extends State<SpellFormPage> {
  final AllSpellsViewModel vm = AllSpellsViewModel();
  final _formKey = GlobalKey<FormState>();

  late String _name, _desc, _range, _material, _castingTime, _attackType, _url;
  late String _duration, _school, _level, _components, _concentration;
  late bool _ritual;
  late List<String> _classes;
  late Map<int, String> _damageAtSlotLevel;
  DateTime _updatedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _name = '';
    _desc = '';
    _range = '';
    _material = '';
    _castingTime = '';
    _attackType = '';
    _url = '';
    _duration = '';
    _school = '';
    _level = '';
    _components = '';
    _concentration = 'false';
    _ritual = false;
    _classes = [];
    _damageAtSlotLevel = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0E6D2),
      appBar: AppBar(
        backgroundColor: Color(0xFF939c6c),
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            children: <Widget>[
              CupertinoTextField(
                placeholder: 'Spell Name',
                onChanged: (value) => _name = value,
                padding: EdgeInsets.all(16),
                controller: TextEditingController(text: _name),
              ),
              CupertinoTextField(
                placeholder: 'Description',
                onChanged: (value) => _desc = value,
                padding: EdgeInsets.all(16),
                controller: TextEditingController(text: _desc),
              ),
              CupertinoTextField(
                placeholder: 'Range (e.g., 150 feet)',
                onChanged: (value) => _range = value,
                padding: EdgeInsets.all(16),
                controller: TextEditingController(text: _range),
              ),
              CupertinoTextField(
                placeholder: 'Material (optional)',
                onChanged: (value) => _material = value,
                padding: EdgeInsets.all(16),
                controller: TextEditingController(text: _material),
              ),
              CupertinoTextField(
                placeholder: 'Casting Time',
                onChanged: (value) => _castingTime = value,
                padding: EdgeInsets.all(16),
                controller: TextEditingController(text: _castingTime),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              CupertinoTextField(
                placeholder: 'Attack Type (optional)',
                onChanged: (value) => _attackType = value,
                padding: EdgeInsets.all(16),
                controller: TextEditingController(text: _attackType),
              ),
              CupertinoTextField(
                placeholder: 'Duration',
                onChanged: (value) => _duration = value,
                padding: EdgeInsets.all(16),
                controller: TextEditingController(text: _duration),
              ),
              Row(
                children: [
                  Text(
                    'Ritual:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Spacer(),
                  CupertinoSwitch(
                    value: _ritual,
                    onChanged: (value) {
                      setState(() {
                        _ritual = value;
                      });
                    },
                    activeColor: CupertinoColors.activeGreen,
                  ),
                ],
              ),

              CupertinoTextField(
                placeholder: 'Level (integer)',
                onChanged: (value) => _level = value,
                padding: EdgeInsets.all(16),
                controller: TextEditingController(text: _level),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              CupertinoTextField(
                placeholder: 'School (e.g., Evocation)',
                onChanged: (value) => _school = value,
                padding: EdgeInsets.all(16),
                controller: TextEditingController(text: _school),
              ),
              CupertinoTextField(
                placeholder: 'Components (comma-separated)',
                onChanged: (value) => _components = value,
                padding: EdgeInsets.all(16),
                controller: TextEditingController(text: _components),
              ),
              Row(
                children: [
                  Text(
                    'Concentration:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Spacer(),
                  CupertinoSwitch(
                    value: _concentration == 'true',
                    onChanged: (value) {
                      setState(() {
                        _concentration = value ? 'true' : 'false';
                      });
                    },
                    activeColor: CupertinoColors.activeGreen,
                  ),
                ],
              ),

              CupertinoButton.filled(
                onPressed: () => _submitForm(context),
                child: Text('Create Spell'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (_name == '') {
          _showErrorDialog("Please add a spell level and name.");
        } else {
          final spell = Spell(
            index: _name,
            name: _name,
            desc: [_desc],
            higherLevel: [],
            range: _range,
            components: _components.split(','),
            material: _material.isNotEmpty ? _material : null,
            ritual: _ritual,
            duration: _duration,
            concentration: _concentration == 'true',
            castingTime: _castingTime,
            level: int.parse(_level),
            attackType: _attackType.isEmpty ? null : _attackType,
            damage: Damage(
              damageType: DamageType(index: 'fire', name: 'Fire', url: ''),
              damageAtSlotLevel: _damageAtSlotLevel,
            ),
            school: School(index: 'evocation', name: _school, url: ''),
            classes:
                _classes
                    .map((e) => SpellClass(index: e, name: e, url: ''))
                    .toList(),
            subclasses: [],
            url: _url,
            updatedAt: _updatedAt,
          );

          await vm.saveSpell(spell);
          context.go('/');
        }
      } catch (e) {
        _showErrorDialog('Please add a spell level and name.');
      }
    } else {
      _showErrorDialog('Please fill in all the fields correctly.');
    }
  }

  // Function to show an error dialog
  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
