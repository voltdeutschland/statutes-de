#import "colours_and_stuff.typ" as resources

#let dateFromString(date: str) = {
  if date == "" {
    none
  } else {
    let year = date.slice(0, 4)
    let month = date.slice(5, 7)
    let day = date.slice(8, 10)

    day + "." + month + "." + year
  }
}

#let datetimeFromString(date: str) = {
  if date == "" {
    none
  } else {
    datetime(year: int(date.slice(0, 4)), month: int(date.slice(5, 7)), day: int(date.slice(8, 10)))
  }
}


#let placeholderDate(
  label: str,
) = {
  box(
    width: 12em,
    height: 3em,
    fill: rgb(240, 240, 240),
    inset: 0.2em,
    radius: 0.2em,
    baseline: 40%,
  )[
    #align(top + left, text(label, size: resources.TINY))
    #align(center + horizon, "__ __ . __ __ . __ __ __ __")
  ]
}

#let placeholder(
  label: "Bitte füllen",
  width: 3em,
  prefilled: "",
) = {
  box(
    width: width + 1em,
    height: 3em,
    fill: rgb(240, 240, 240),
    inset: 0.2em,
    radius: 0.2em,
    baseline: 40%,
  )[
    #align(top + left, text(label, size: resources.TINY))
    #if (prefilled != "") {
      align(center + horizon, text([#prefilled]))
    }
  ]
}


#let signature(
  role: str,
) = {
  table.cell()[
    #stack(placeholder(label: "Unterschrift", width: 15em), line(length: 100%), linebreak(), text(role))
  ]
}

#let addressToStringMultiline(address) = {
  text([
    #address.street #address.houseNr #linebreak()
    #address.postalCode #address.city (#address.country)
  ])
}
