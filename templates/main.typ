#import "util/general_template.typ": conf
#import "util/colours_and_stuff.typ" as resources
#import "util/elements.typ" as elements
#import "@preview/cmarker:0.1.5"

// Legal sentence numbering with superscript numbers
#let superscript-digits = ("⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹")

#let to-superscript(n) = {
  let result = ""
  for c in str(n) {
    result += superscript-digits.at(int(c))
  }
  result
}

#let add-legal-numbering(content) = {
  let blocks = content.split(regex("\n{2,}"))
  let legal-prefix-pattern = regex("^\(\d+\)\s*")

  let processed = blocks.map(block => {
    let trimmed = block.trim()

    // Skip special markdown elements (headers, lists, blockquotes, tables, code blocks)
    if trimmed.starts-with("#") or trimmed.starts-with("-") or trimmed.starts-with("*") or trimmed.starts-with(">") or trimmed.starts-with("|") or trimmed.starts-with("```") or trimmed.match(regex("^\d+\.")) != none {
      block
    } else {
      // Regular paragraph - split by newlines
      let lines = trimmed.split("\n").filter(l => l.trim() != "")

      if lines.len() <= 1 {
        // Single sentence - don't number
        block
      } else {
        // Multiple sentences - add superscript numbers using fold to track counter
        let result = lines.fold((num: 0, parts: ()), (acc, line) => {
          let trimmed-line = line.trim()
          // Check if line starts with legal prefix like (1), (2), etc.
          let prefix-match = trimmed-line.match(legal-prefix-pattern)
          if prefix-match != none {
            let prefix = prefix-match.text
            let rest = trimmed-line.slice(prefix.len()).trim()
            if rest == "" {
              // Prefix alone on a line - just return prefix, don't number
              (num: acc.num, parts: acc.parts + (prefix.trim(),))
            } else {
              // Prefix with content - number the content
              let new-num = acc.num + 1
              (num: new-num, parts: acc.parts + (prefix + to-superscript(new-num) + rest,))
            }
          } else {
            // Regular line - number it
            let new-num = acc.num + 1
            (num: new-num, parts: acc.parts + (to-superscript(new-num) + trimmed-line,))
          }
        })
        result.parts.join(" ")
      }
    }
  })

  processed.join("\n\n")
}

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

  // Page break before level 1 headings
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    it
  }

  // Render markdown content with hanging paragraphs and legal sentence numbering
  set par(hanging-indent: 1.5em)
  cmarker.render(add-legal-numbering(content))

  doc
}

#show: documentation
