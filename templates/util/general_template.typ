#import "colours_and_stuff.typ" as resources

#let conf(
  title: none,
  email: none,
  footer_date: none,
  qr_code: true,
  doc_id: none,
  title_page: true,
  date: none,
  line1: "Zeile 1",
  line2: "Zeile 2",
  line3: "Zeile 3, Adresse folgt",
  adress: none,
  website: none,
  footer: resources.footer,
  header: resources.header,
  doc,
) = {
  //General settings
  set text(lang: "de", hyphenate: false)

  set page(background: context [
    #resources.color_sidebar
    #place(left + bottom, dx: 1cm, dy: -page.height / 5)[
      #rotate(270deg, reflow: true, [#text(doc_id + " / " + counter(page).display("1"), size: resources.TINY)])
    ]
    #if (qr_code) {
      place(right + bottom)[
        //#image("qr_code.", format: "svg", height: 5%)
      ]
    }
  ])

  set text(font: "Ubuntu", size: resources.REGULAR)
  show heading: it => {
    v(0.1em)
    it.body
    v(0.1em)
  }

  show heading: set text(resources.volt_purple)
  show heading.where(level: 1): set text(size: resources.H1)
  show heading.where(level: 2): set text(size: resources.H2)
  show heading.where(level: 3): set text(size: resources.H3)
  show heading.where(level: 4): set text(size: resources.H4)
  show heading.where(level: 5): set text(size: resources.H5)

  //Title Page
  if (title_page) {
    set align(center)

    v(10em)
    image("logo.svg", format: "svg", width: 40%)
    v(2em)
    text(title, size: resources.TITLE)
    v(2em)
    text(resources.de-date(date), size: resources.TITLE)

    set text(size: resources.SMALL)

    place(left + bottom)[
      #line1
      #linebreak()
      #line2
      #linebreak()
      #line3
      #linebreak()
      #linebreak()
      #text(weight: "bold")[#adress.at(0)]
      #linebreak()
      #text(adress.at(1))
      #linebreak()
      #text(adress.at(2) + if (adress.at(3) != "") { " | " + adress.at(3) })
      #linebreak()
      #linebreak()
      #if (website != none and website != "") {
        link(website)
      }
      #linebreak()
      #link("mailto:" + email)
    ]

    pagebreak()
  }

  //Setting for pages after title page
  set page(footer: footer(adress, footer_date), header: header(title), margin: (top: 3cm, bottom: 3cm))

  set text(size: resources.REGULAR)
  set align(left)

  set enum(numbering: "1.", indent: 1em)
  show enum: set par(leading: 1em, spacing: 1em, hanging-indent: 0em)

  set list(marker: [-], indent: 1em)
  show list: set par(leading: 1em, spacing: 1em, hanging-indent: 0em)
  doc
}

#show: conf.with(
  title: [
    Allgemeines Template
  ],
  date: datetime.today(),
  adress: ("Volt Deutschland", "Bundesverband", "Choriner Str. 34", "10435 Berlin"),
  website: "voltdeutschland.org",
  email: "vorstand@voltdeutschland.org",
  doc_id: "DAS IST EINE ID",
)
