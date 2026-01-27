#let volt_purple = rgb("#502379")
#let volt_yellow = rgb("#FDC220")
#let volt_green = rgb("#1BBE6F")
#let volt_blue = rgb("#82D0F4")
#let volt_red = rgb("#E63E12")
#let REGULAR = 11pt
#let TITLE = 16pt
#let H1 = 15pt
#let H2 = 14pt
#let H3 = 13pt
#let H4 = 11pt
#let H5 = 11pt
#let SMALL = 9pt
#let TINY = 6pt

#let month-de(date) = (
  "Januar",
  "Februar",
  "März",
  "April",
  "Mai",
  "Juni",
  "Juli",
  "August",
  "September",
  "Oktober",
  "November",
  "Dezember",
).at(date.month() - 1)

#let de-date(date) = text(date.display("[day]. ") + month-de(date) + date.display(" [year]"))



#let iso-date-to-de(date) = {
  date.slice(8, 10) + "." + date.slice(5, 7) + "." + date.slice(0, 4)
}

#let color_sidebar = context [
  #image("color_sidebar.svg", format: "svg", width: 100%)
]

#let header(title) = context [
  #set text(size: SMALL)
  #grid(
    columns: (auto, auto),
    column-gutter: 1fr,
    align: (left, right),
    context [#title], context [#image("logo.svg", format: "svg", width: 55pt)],
  )
  #line(length: 100%)
]

#let footer(adress, date) = context [
  #set text(size: SMALL)
  #line(length: 100%)
  #grid(
    columns: 3,
    column-gutter: 1fr,
    align: (left, center, right),
    context [
      #set par(leading: 1em, spacing: 1em, hanging-indent: 0em)
      #if (adress != none) {
        text(weight: "bold", fill: volt_purple)[#adress.at(0)]
        linebreak()
        text(adress.at(1))
        linebreak()
        text(adress.at(2) + if (adress.at(3) != "") { " | " + adress.at(3) })
      }],
    context [
      #set par(leading: 1em, spacing: 1em, hanging-indent: 0em)
      #text(weight: "bold", fill: volt_purple)[Volt Portal]
      #linebreak()
      Bundesgeschäftsstelle],
    context [
      Seite #context counter(page).display("1 von 1", both: true)
      #linebreak()
      #if (date != none) { de-date(date) }
    ],
  )
]


#let assemblyFooter(assemblyName, eventId, documentType, documentVersion, timestamp, documentId) = (
  adress,
  date,
) => context [
  #set text(size: SMALL)
  #line(length: 100%)
  #text(weight: "bold", fill: volt_purple)[#assemblyName]
  #grid(
    columns: (auto, auto, auto),
    column-gutter: 1fr,
    align: (left, center, right),
    context [
      #set par(leading: 1em, spacing: 1em, hanging-indent: 0em)
      #text[#documentType v#documentVersion]
    ],
    context [
      #set par(leading: 1em, spacing: 1em, hanging-indent: 0em)
      #text(timestamp)
    ],
    context [
      Seite #context counter(page).display("1 von 1", both: true)
    ],
  )
]
