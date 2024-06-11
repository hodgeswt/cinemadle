import 'package:cinemadle/src/bloc_utilities/utilities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Utilities', () {
    group('With', () {
      test('listCopyWith', () {
        List<String>? list = ['a', 'b', 'c'];
        expect(With.listCopyWith(list, 'd'), ['d', 'a', 'b', 'c']);

        list = [];
        expect(With.listCopyWith(list, 'a'), ['a']);

        list = null;
        expect(With.listCopyWith(list, 'a'), ['a']);
      });

      test('mapCopyWith', () {
        Map<int, String>? map = {1: 'a'};
        expect(With.mapCopyWith(map, 2, 'b'), {1: 'a', 2: 'b'});

        map = {1: 'a', 2: 'b'};
        expect(With.mapCopyWith(map, 3, 'c'), {1: 'a', 2: 'b', 3: 'c'});

        map = null;
        expect(With.mapCopyWith(map, 1, 'a'), {1: 'a'});
      });
    });

    test('Prepend', () {
      List<String> list = ['a', 'b', 'c'];
      expect(list.prepend('d'), ['d', 'a', 'b', 'c']);

      list = [];
      expect(list.prepend('a'), ['a']);

      list = ['a'];
      expect(list.prepend('b'), ['b', 'a']);

      List<int> list2 = [1, 2, 3];
      expect(list2.prepend(4), [4, 1, 2, 3]);

      list2 = [];
      expect(list2.prepend(1), [1]);

      list2 = [1];
      expect(list2.prepend(2), [2, 1]);
    });

    test('WithData', () {
      Map<int, String> map = {1: 'a'};
      expect(map.withData(2, 'b'), {1: 'a', 2: 'b'});

      map = {1: 'a', 2: 'b'};
      expect(map.withData(3, 'c'), {1: 'a', 2: 'b', 3: 'c'});

      map = {};
      expect(map.withData(1, 'a'), {1: 'a'});
    });

    test('Union', () {
      List<String> list = ['a', 'b', 'c'];
      expect(list.union(['b', 'c', 'd']), ['b', 'c']);

      list = ['a', 'b', 'c'];
      expect(list.union(['d', 'e', 'f']), []);

      list = ['a', 'b', 'c'];
      expect(list.union(['d', 'e', 'f', 'a']), ['a']);

      list = [];
      expect(list.union(['a', 'b', 'c']), []);

      list = [];
      expect(list.union([]), []);
    });

    test('GetOrDefault', () {
      List<String> list = ['a', 'b', 'c'];
      expect(list.getOrDefault(0, 'd'), 'a');
      expect(list.getOrDefault(1, 'd'), 'b');
      expect(list.getOrDefault(2, 'd'), 'c');
      expect(list.getOrDefault(3, 'd'), 'd');

      list = [];
      expect(list.getOrDefault(0, 'a'), 'a');
      expect(list.getOrDefault(1, 'a'), 'a');
      expect(list.getOrDefault(2, 'a'), 'a');
      expect(list.getOrDefault(3, 'a'), 'a');
    });
  });
}
