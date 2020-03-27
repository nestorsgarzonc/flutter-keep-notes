import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keep_notes/src/model/note.dart';
import 'package:flutter_keep_notes/src/providers/current_user.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _gridView = true; //true show a grid, else a list

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: _createNoteStream(context),
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            _appBar(context),
            SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
            _buildNotesView(context),
            SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
        floatingActionButton: _fab(context),
        bottomNavigationBar: _bottonActions(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        extendBody: true,
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      title: _topActions(context),
      automaticallyImplyLeading: false,
      centerTitle: true,
      titleSpacing: 0,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _topActions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: <Widget>[
              SizedBox(width: 20),
              Icon(Icons.menu),
              Expanded(child: Text('Buscar notas', softWrap: false)),
              InkWell(
                child: Icon(_gridView ? Icons.view_list : Icons.view_module),
                onTap: () => setState(() {
                  _gridView = !_gridView;
                }),
              ),
              SizedBox(width: 18),
              _buildAvatar(context),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottonActions() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Container(
        height: kBottomBarSize,
        padding: EdgeInsets.symmetric(horizontal: 17),
        child: Row(
          children: <Widget>[],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final url = Provider.of<CurrentUser>(context)?.data?.photoUrl;
    return CircleAvatar(
      backgroundImage: url != null ? NetworkImage(url) : null,
      child: url == null ? Icon(Icons.face) : null,
      radius: 17,
    );
  }

  Widget _buildNotesView(BuildContext context) {
    return Consumer<List<Note>>(
      builder: (context, notes, _) {
        if (notes?.isNotEmpty != true) {
          return _buildBlankView();
        }
        final widget = _gridView ? NotesGrid.create : NotesList.create;
        return widget(notes: notes, onTap: (_) {});
      },
    );
  }

  Widget _buildBlankView() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Text(
        'Tus notas apareceran aca',
        style: TextStyle(color: Colors.black54, fontSize: 14),
      ),
    );
  }

  Widget _fab(BuildContext context) => FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      );

  Stream<List<Note>> _createNoteStream(BuildContext context) {
    final uid = Provider.of<CurrentUser>(context)?.data?.uid;
    return Firestore.instance
        .collection('notes-$uid')
        .where('state', isEqualTo: 0)
        .snapshots()
        .handleError((e) => debugPrint('query notes failed: $e'))
        .map((snapshot) => Note.fromQuery(snapshot));
  }
}
