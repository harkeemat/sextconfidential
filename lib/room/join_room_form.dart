import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../conference/conference_page.dart';
import '../debug.dart';
import '../models/twilio_enums.dart';
import '../shared/services/backend_service.dart';
import '../shared/widgets/button_to_progress.dart';
import '../shared/widgets/platform_exception_alert_dialog.dart';
import 'room_bloc.dart';
import 'room_model.dart';

class JoinRoomForm extends StatefulWidget {
  final RoomBloc roomBloc;

  const JoinRoomForm({
    Key? key,
    required this.roomBloc,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final backendService = Provider.of<BackendService>(context, listen: false);
    return Provider<RoomBloc>(
      create: (BuildContext context) =>
          RoomBloc(backendService: backendService),
      dispose: (BuildContext context, RoomBloc roomBloc) => roomBloc.dispose(),
      child: Consumer<RoomBloc>(
        builder: (BuildContext context, RoomBloc roomBloc, _) => JoinRoomForm(
          roomBloc: roomBloc,
        ),
      ),
    );
  }

  @override
  _JoinRoomFormState createState() => _JoinRoomFormState();
}

class _JoinRoomFormState extends State<JoinRoomForm> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RoomModel>(
        stream: widget.roomBloc.modelStream,
        initialData: RoomModel(),
        builder: (BuildContext context, AsyncSnapshot<RoomModel> snapshot) {
          final roomModel = snapshot.data!;
          print("roomModel${roomModel.type}");
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildChildren(roomModel),
            ),
          );
        });
  }

  List<Widget> _buildChildren(RoomModel roomModel) {
    return <Widget>[
      TextField(
        key: Key('enter-room-name'),
        decoration: InputDecoration(
          labelText: 'Enter room name',
          errorText: roomModel.nameErrorText,
          enabled: !roomModel.isLoading,
        ),
        controller: _nameController,
        onChanged: widget.roomBloc.updateName,
      ),
      const SizedBox(
        height: 16,
      ),
      Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              'Room size:',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: DropdownButton(
              underline: Container(
                height: 1,
                color: Colors.grey,
              ),
              isExpanded: true,
              items: <TwilioRoomType>[
                TwilioRoomType.group,
                TwilioRoomType.groupSmall
              ].map<DropdownMenuItem<TwilioRoomType>>((TwilioRoomType value) {
                return DropdownMenuItem<TwilioRoomType>(
                  value: value,
                  child: Text(RoomModel.getTypeText(value)),
                );
              }).toList(),
              value: widget.roomBloc.model.type,
              onChanged: widget.roomBloc.updateType,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 16,
      ),
      _buildButton(roomModel),
      const SizedBox(
        height: 16,
      ),
    ];
  }

  Widget _buildButton(RoomModel roomModel) {
    return ButtonToProgress(
      onLoading: widget.roomBloc.onLoading,
      loadingText: 'Creating the room...',
      progressHeight: 2,
      child: TextButton(
        key: Key('join-button'),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.shade300;
          } else {
            return Theme.of(context).appBarTheme.backgroundColor ??
                Theme.of(context).primaryColor;
          }
        })),
        onPressed: roomModel.canSubmit && !roomModel.isLoading
            ? () => _submit()
            : null,
        child: FittedBox(
          child: Text(
            'JOIN',
            style: TextStyle(
                color: Theme.of(context).appBarTheme.titleTextStyle?.color ??
                    Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    try {
      //final roomModel = await widget.roomBloc.submit();
      //print("identity$roomModel");
      var room = {
        'name': "ddfsdf",
        'isLoading': true,
        'isSubmitted': true,
        'token':
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTS2E5NGQ3Mjc4OWE1YzA5NjZhZGVlMWNhZWZiOTkwNjNjLTE2OTg0OTA2ODAiLCJpc3MiOiJTS2E5NGQ3Mjc4OWE1YzA5NjZhZGVlMWNhZWZiOTkwNjNjIiwic3ViIjoiQUM3YWM2YjU5OTFmNTc4NTU3ZDg2Nzk4YmE4NWI4N2E3ZSIsImV4cCI6MTY5ODUyNjY4MCwiZ3JhbnRzIjp7ImlkZW50aXR5IjoiTWljaGFlbCIsInZpZGVvIjp7InJvb20iOiIxNTVfODUzMyJ9fX0.Lmv2FZ9Ccxk0KQw5sfhLzP1DjuX6GRaMtlwe3MjrH6c",
        'identity': "demo",
        'type': TwilioRoomType.groupSmall
      };
      final roomModel = RoomModel.fromMap(Map<String, dynamic>.from(room));
      await Navigator.of(context).push(
        MaterialPageRoute<ConferencePage>(
          fullscreenDialog: true,
          builder: (BuildContext context) =>
              ConferencePage(roomModel: roomModel),
        ),
      );
    } catch (err) {
      Debug.log(err);
      await PlatformExceptionAlertDialog(
        exception: err as Exception,
      ).show(context);
    }
  }
}
