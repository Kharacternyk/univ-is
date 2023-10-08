#set text(
  font: "IBM Plex Sans",
  lang: "uk",
)
#show raw: set text(
  font: "IBM Plex Mono",
)
#set page(
  numbering: "1 / 1",
)
#set par(
  justify: true,
)
#show link: underline

#align(center, [
  *Звіт до лабораторної роботи №1*

  *База знань*

  _Назар Віннічук. Група МІ-4._
])

Рушій бази знань реалізовано мовою Dart.
Програмний код рушія знаходиться за адресою
https://github.com/Kharacternyk/univ-is/tree/master/lab-1.
Взаємодія з базою знань відбувається мовою,
що була вигадана для цього рушія,
та яка нагадує природній текст англійською мовою з виділенням відношень символами `*`.
Надалі наведений приклад взаємодії з базою знань.
Відповіді бази знань починаються з символу `>`.

```
Linux *is* an operating system.
Windows *is* an operating system.
Photoshop *is* an application.
Photoshop *runs only on* Windows.
Microsoft *develops* Windows.
Microsoft *develops* Surface.
Alice *uses* Surface.
Bob *uses* Photoshop.
Eve *prefers* Linux *to* Windows.

If someone *uses* something & something *runs only on* something else, then someone *uses* something else.
If someone *uses* something & something *is* something else, then someone *uses* something else.
If something *is* an application, then something *is* software.
If something *is* an operating system, then something *is* software.
If something *is* software, then something *has* bugs.
If someone *develops* something & something *has* something else, then someone *is responsible for* something else *in* something.
If someone *uses* something & someone else *is responsible for* bugs *in* something, then someone *is angry at* someone else.
If someone *prefers* something *to* something else, then someone *avoids* something else.
If someone *avoids* something & something else *runs only on* something, then someone *avoids* something else.

Who *is angry at* Microsoft?
> Bob

What Eve *avoids*?
> Windows
> Photoshop

Who *is responsible for* bugs *in* Windows?
> Microsoft

What *has* bugs?
> Photoshop
> Linux
> Windows

What Bob *uses*?
> Photoshop
> Windows
> an application
> an operating system
> software
```

Порядок введення фактів та правил виведення неважливий:

```
If someone *lives in* something, then something *is* home *for* someone.
If someone *lives in* something & something *is* capital *of* something else, then someone *lives in* something else.
Kyiv *is* capital *of* Ukraine.
Nazar *lives in* Kyiv.
What *is* home *for* Nazar?
> Kyiv
> Ukraine
```

Лексер стійкий до різноманітних способів введення:

```
I * write    on*a
  tablet*with  *
a    stylus  .
What I *write on* a tablet *with*?
> a stylus
```

Парсер розпізнає синтаксичні помилки та вміє відновлюватись від них:

```
If something *is* something else?
:(Parsing failure):
What *is* this.
:(Parsing failure):
This ampersand & *does not* belong here.
:(Parsing failure):
This *is* *is* good.
:(Parsing failure):
This *is* good.
What *is* good?
> This
```

Загалом мова взаємодії з базою знань надає особливе значення наступним символам:

- `.`
- `?`
- `&`
- `*`

Також мова має наступні ключові слова, враховуючи регістр літер:

- `If`
- `What`
- `Who`
- `then`

Символи `,` та `;` вважаються роздільниками слів,
так само як і невидимі символи,
що включать пробіли та символи нового рядка.

Мова парситься у послідовність речень.
Кожне речення є фактом, правилом виведення або запитом.

Синтаксична структура факту:

- _Твердження_
- `.`

Синтаксична структура правила виведення:

- `If`
- _Твердження_
- Опційно:
  - `&`
  - _Твердження_
- `then`
- _Твердження_
- `.`

Синтаксична структура запиту:

- `What` або `Who`
- _Твердження_ або _Зміщене твердження_
- `?`

Синтаксична структура _твердження_:

- _Іменник_
- Опційно:
  - _Зміщене твердження_

Синтаксична структура _Зміщеного твердження_:

- _Дієслово_
- Опційно:
  - _Твердження_

_Дієсловом_ називається словосполучення, оточене символами `*`.
Решта словосполучень відповідно називаються _іменниками_.
