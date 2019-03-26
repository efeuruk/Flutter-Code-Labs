import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

// Stateless widgets -> doesn't change
// Stateful widgets -> may change

void main() {
  runApp(new FriendlyChatApp());
}

class FriendlyChatApp extends StatelessWidget {

  final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light,
  );

  final ThemeData kDefaultTheme = new ThemeData(
    primarySwatch: Colors.green,
    accentColor: Colors.blueAccent[400],
  );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "FriendlyChat",
      theme: defaultTargetPlatform == TargetPlatform.android ?
        kDefaultTheme : kIOSTheme,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget{
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  // List of messages in the screen
  final List<ChatMessage> _messages = <ChatMessage>[];

  // Reading the contents of the input field and for cleaning the field after the text message is sent
  final TextEditingController _textController = new TextEditingController();

  // To activate send when users are typing something
  bool _isComposing = false;

  @override
  void dispose() {
    for(ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    // Add messages to screen
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(microseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  // Creating a widget that returns a Container widget with configured TextField widget
  Widget _buildTextComposer() {
    return new IconTheme(
      // Take the color of the theme for the button otherwise it is black
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[

            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length>0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),

            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.android ?
              new IconButton(
                icon: new Icon(Icons.send),
                onPressed: _isComposing ?
                  () =>  _handleSubmitted(_textController.text) : null,
              ) :
              new CupertinoButton(
                child: new Text("Send"),
                onPressed: _isComposing
                  ? () =>  _handleSubmitted(_textController.text)
                  : null,)
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Friendlychat"),
        elevation: Theme.of(context).platform == TargetPlatform.android ? 0.0 :
        4.0,
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
          ? new BoxDecoration(
          border: new Border(
            top: new BorderSide(color: Colors.grey[200]),
          ),
        ) : null
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  // Adding a member variable
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    const String _name = "Efe";
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            // Take the first character of the name and put it on to profile
            // avatar
            child: new CircleAvatar(child: new Text(_name[0]),),
          ),
          Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_name, style: Theme.of(context).textTheme.subhead,),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
















