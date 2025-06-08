import 'package:flutter/material.dart';


class InstanceEditPage extends StatefulWidget {
  final String instanceId;

  InstanceEditPage({required this.instanceId});

  @override
  _InstanceEditPageState createState() => _InstanceEditPageState();
}
class _InstanceEditPageState extends State<InstanceEditPage> {
  final _formKey = GlobalKey<FormState>();
  String _instanceName = '';
  String _instanceUrl = '';

  @override
  void initState() {
    super.initState();
    // Load instance data here using widget.instanceId
    // For example, you might fetch the instance details from a database or API
    // and set the initial values for _instanceName and _instanceUrl.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Instance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Instance Name'),
                initialValue: _instanceName,
                onSaved: (value) => _instanceName = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an instance name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Instance URL'),
                initialValue: _instanceUrl,
                onSaved: (value) => _instanceUrl = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an instance URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    // Save the instance data here
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}