import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/util.dart';

void main() async {
  group('formatMarkdownSymbol', () {
    // Regression: https://github.com/onedigitalde/appflowy-editor — a stale
    // selection (e.g. an iOS IME/autocorrect replacement shortened the text
    // before the selection was reconciled) used to throw a RangeError from
    // `delta.toPlainText().substring(0, selection.end.offset)`.
    test(
        'returns false instead of throwing when the selection offset is past the text length',
        () async {
      const text = '*Welcome';
      final document = Document.blank().addParagraph(initialText: text);
      final editorState = EditorState(document: document);

      // Simulate the stale selection: offset beyond the node's plain text.
      editorState.selection = Selection.collapsed(
        Position(path: [0], offset: text.length + 3),
      );

      final result = await formatAsteriskToBulletedList.execute(editorState);

      // No formatting happened and nothing threw.
      expect(result, false);
      final after = editorState.getNodeAtPath([0])!;
      expect(after.type, ParagraphBlockKeys.type);
      expect(after.delta!.toPlainText(), text);
    });
  });
}
