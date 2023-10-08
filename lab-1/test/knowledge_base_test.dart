import 'package:lab_1/knowledge_base.dart';
import 'package:lab_1/relation.dart';
import 'package:lab_1/sentence.dart';
import 'package:test/test.dart';

import 'token_extension.dart';

void main() {
  test('Knowledge Base', () {
    final base = KnowledgeBase();

    final facts = [
      Fact(NounFirstRelation(
        ["Bob"].noun,
        VerbFirstRelation(
          ["uses"].verb,
          NounFirstRelation(
            ["Photoshop"].noun,
            null,
          ),
        ),
      )),
      Fact(NounFirstRelation(
        ["Alice"].noun,
        VerbFirstRelation(
          ["uses"].verb,
          NounFirstRelation(
            ["Photoshop"].noun,
            null,
          ),
        ),
      )),
      Fact(NounFirstRelation(
        ["Alice"].noun,
        VerbFirstRelation(
          ["uses"].verb,
          NounFirstRelation(
            ["Surface"].noun,
            null,
          ),
        ),
      )),
      Fact(NounFirstRelation(
        ["Eve"].noun,
        VerbFirstRelation(
          ["uses"].verb,
          NounFirstRelation(
            ["Windows"].noun,
            null,
          ),
        ),
      )),
    ];

    expect(facts.map(base.feed).toSet(), equals(const {null}));

    final rules = [
      Rule(
        predicate: NounFirstRelation(
          ["someone"].noun,
          VerbFirstRelation(
            ["uses"].verb,
            NounFirstRelation(
              ["Photoshop"].noun,
              null,
            ),
          ),
        ),
        consequence: NounFirstRelation(
          ["someone"].noun,
          VerbFirstRelation(
            ["uses"].verb,
            NounFirstRelation(
              ["Windows"].noun,
              null,
            ),
          ),
        ),
      ),
      Rule(
        predicate: NounFirstRelation(
          ["someone"].noun,
          VerbFirstRelation(
            ["uses"].verb,
            NounFirstRelation(
              ["something"].noun,
              null,
            ),
          ),
        ),
        consequence: NounFirstRelation(
          ["something"].noun,
          VerbFirstRelation(
            ["is", "used", "by"].verb,
            NounFirstRelation(
              ["someone"].noun,
              null,
            ),
          ),
        ),
      ),
      Rule(
        predicate: NounFirstRelation(
          ["someone"].noun,
          VerbFirstRelation(
            ["uses"].verb,
            NounFirstRelation(
              ["Windows"].noun,
              null,
            ),
          ),
        ),
        conjunction: NounFirstRelation(
          ["someone"].noun,
          VerbFirstRelation(
            ["uses"].verb,
            NounFirstRelation(
              ["Surface"].noun,
              null,
            ),
          ),
        ),
        consequence: NounFirstRelation(
          ["someone"].noun,
          VerbFirstRelation(
            ["likes"].verb,
            NounFirstRelation(
              ["Microsoft"].noun,
              null,
            ),
          ),
        ),
      ),
      Rule(
        predicate: NounFirstRelation(
          ["someone"].noun,
          VerbFirstRelation(
            ["uses"].verb,
            NounFirstRelation(
              ["something"].noun,
              null,
            ),
          ),
        ),
        conjunction: NounFirstRelation(
          ["something"].noun,
          VerbFirstRelation(
            ["is", "used", "by"].verb,
            NounFirstRelation(
              ["someone", "else"].noun,
              null,
            ),
          ),
        ),
        consequence: NounFirstRelation(
          ["someone"].noun,
          VerbFirstRelation(
            ["matches"].verb,
            NounFirstRelation(
              ["someone", "else"].noun,
              null,
            ),
          ),
        ),
      ),
    ];

    expect(rules.map(base.feed).toSet(), equals(const {null}));

    expect(
      base
          .feed(
            Query(
              NounFirstRelation(
                ["Alice"].noun,
                VerbFirstRelation(
                  ["uses"].verb,
                  null,
                ),
              ),
            ),
          )
          ?.toSet(),
      equals({
        ["Surface"].noun,
        ["Photoshop"].noun,
        ["Windows"].noun,
      }),
    );

    expect(
      base
          .feed(
            Query(
              VerbFirstRelation(
                ["uses"].verb,
                NounFirstRelation(
                  ["Photoshop"].noun,
                  null,
                ),
              ),
            ),
          )
          ?.toSet(),
      equals({
        ["Alice"].noun,
        ["Bob"].noun,
      }),
    );

    expect(
      base
          .feed(
            Query(
              VerbFirstRelation(
                ["uses"].verb,
                NounFirstRelation(
                  ["Windows"].noun,
                  null,
                ),
              ),
            ),
          )
          ?.toSet(),
      equals({
        ["Alice"].noun,
        ["Bob"].noun,
        ["Eve"].noun,
      }),
    );

    expect(
      base
          .feed(
            Query(
              VerbFirstRelation(
                ["is", "used", "by"].verb,
                NounFirstRelation(
                  ["Eve"].noun,
                  null,
                ),
              ),
            ),
          )
          ?.toSet(),
      equals({
        ["Windows"].noun,
      }),
    );

    expect(
      base
          .feed(
            Query(
              VerbFirstRelation(
                ["likes"].verb,
                NounFirstRelation(
                  ["Microsoft"].noun,
                  null,
                ),
              ),
            ),
          )
          ?.toSet(),
      equals({
        ["Alice"].noun,
      }),
    );

    expect(
      base
          .feed(
            Query(
              VerbFirstRelation(
                ["matches"].verb,
                NounFirstRelation(
                  ["Eve"].noun,
                  null,
                ),
              ),
            ),
          )
          ?.toSet(),
      equals({
        ["Alice"].noun,
        ["Bob"].noun,
        ["Eve"].noun,
      }),
    );
  });
}
