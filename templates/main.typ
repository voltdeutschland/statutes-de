#import "util/general_template.typ": conf
#import "util/colours_and_stuff.typ" as resources
#import "util/elements.typ" as elements

#let titleWithSortIfExisting(element: none, sep: none) = {
  if (element.sortTxt != none and element.sortTxt != "") {
    element.sortTxt + " " + sep + " "
  }
  element.title
}

#let elementTemplate(element: none) = {
  if (element == none) {
    return ""
  }

  if (element.type == "PARAGRAPH") {
    heading(level: 2, titleWithSortIfExisting(element: element, sep: "–"))
    element.children.map(c => elementTemplate(element: c)).flatten().join()
  } else if (element.type == "SUBPARAGRAPH") {
    list(marker: element.sortTxt, element.children.map(c => elementTemplate(element: c)).flatten().join(" "))
    v(5pt)
  } else if (element.type == "SENTENCE") {
    if (element.sortTxt != none) {
      super(element.sortTxt)
    }
    text(element.content) + " " + element.children.map(c => elementTemplate(element: c)).flatten().join()
  } else if (element.type == "ENUMERATION") {
    list(
      marker: if (element.sortTxt == none) { "•" } else { element.sortTxt },
      [#element.content #element.children.map(c => elementTemplate(element: c)).flatten().join(" ")],
    )
  } else if (element.type == "SECTION") {
    pagebreak()
    heading(level: 1, titleWithSortIfExisting(element: element, sep: "|"))
    element.children.map(c => elementTemplate(element: c)).flatten().join()
  } else if (element.type == "ATTACHMENT") {
    pagebreak()
    heading(level: 1, titleWithSortIfExisting(element: element, sep: "•"))
    element.children.map(c => elementTemplate(element: c)).flatten().join()
  } else if (element.type == "H3") {
    heading(level: 2, titleWithSortIfExisting(element: element, sep: "–
    "))
    element.children.map(c => elementTemplate(element: c)).flatten().join()
  } else if (element.type == "H4") {
    heading(level: 3, titleWithSortIfExisting(element: element, sep: ""))
    element.children.map(c => elementTemplate(element: c)).flatten().join()
  } else if (element.type == "H5") {
    heading(level: 4, titleWithSortIfExisting(element: element, sep: ""))
    element.children.map(c => elementTemplate(element: c)).flatten().join()
  }
}

#let documentation(
  data: "data.json",
  doc,
) = {
  if (sys.inputs.keys().contains("data")) { data = sys.inputs.data }

  let data = json(data)

  let version = data.document
  let content = data.content
  let association = data.association

  show: conf.with(
    title: version.title,
    date: elements.datetimeFromString(date: version.firstValidAt),
    adress: (association.topName, association.subName, association.address, ""),
    website: association.webValue,
    email: association.mailValue,
    doc_id: version.id,
    title_page: true,
    qr_code: false,
    line1: "Letzte Änderung vom " + elements.dateFromString(date: version.firstValidAt),
    line2: "Redaktionelle Änderung vom " + elements.dateFromString(date: version.submittedAt),
    line3: "Dokument erstellt am " + elements.dateFromString(date: datetime.today().display()),
  )


  outline()

  pagebreak()

  content.map(c => elementTemplate(element: c)).join()

  doc
}

#show: documentation.with()
