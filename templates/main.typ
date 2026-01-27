#import "util/general_template.typ": conf
#import "util/colours_and_stuff.typ" as resources
#import "util/elements.typ" as elements
#import "@preview/cmarker:0.1.5"

// Get directory from input, default to "satzung" for preview
#let directory = sys.inputs.at("directory", default: "satzung")
#let build_date = sys.inputs.at("date", default: datetime.today().display("[year]-[month]-[day]"))

// Read data files
#let meta = json("/" + directory + "/meta.json")
#let root_meta = json("/meta.json")
#let content = read("/" + directory + "/main.md")

#let documentation(doc) = {
  let address = root_meta.address
  let address_line = address.street + " " + address.nr + ", " + address.postal + " " + address.city

  show: conf.with(
    title: meta.title,
    date: elements.datetimeFromString(date: meta.changed_at),
    adress: (root_meta.association.name, root_meta.association.type, address_line, ""),
    website: root_meta.website,
    email: root_meta.mail,
    doc_id: meta.id_document,
    title_page: true,
    qr_code: false,
    line1: "Letzte Änderung vom " + elements.dateFromString(date: meta.changed_at),
    line2: "Geändert durch: " + meta.changed_by,
    line3: "Dokument erstellt am " + elements.dateFromString(date: build_date),
  )

  outline()

  pagebreak()

  // Render markdown content
  cmarker.render(content)

  doc
}

#show: documentation
