#let data = yaml("cv.yaml")
#let contact-file = sys.inputs.at("contacts", default: none)
#if contact-file != none {
  data.profile += yaml(contact-file)
}
#let design = yaml("design.yaml")
#let leading = design.line_spacing_em * 1em

#set document(title: data.profile.name + " - CV", author: data.profile.name)
#set page(
  design.paper,
  margin: (x: design.margin_x_in * 1in, y: design.margin_y_in * 1in),
)
#set text(font: design.font, size: design.body_size_pt * 1pt, lang: "en", fill: black)
#set smartquote(enabled: false)
#set par(justify: false, leading: leading, spacing: leading)
#set list(
  tight: false,
  indent: 0pt,
  body-indent: 11pt,
  spacing: leading + design.bullet_gap_pt * 1pt,
)
#set heading(numbering: none)
#show link: set text(fill: black)
#show heading.where(level: 1): it => block(
  above: design.section_gap_pt * 1pt,
  below: 4pt,
  sticky: true,
  width: 100%,
  inset: (bottom: 3pt),
  stroke: (bottom: 0.4pt),
)[
  #text(size: design.section_size_pt * 1pt, weight: "bold", upper(it.body))
]

#let dated-entry(name, location, dates, details, highlights: ()) = {
  let (detail, ..paragraphs) = details
  block(
    below: leading,
    sticky: true,
    grid(
      columns: (1fr, auto),
      column-gutter: 12pt,
      row-gutter: leading,
      align: (left, right),
      strong(name), location,
      detail, dates.filter(value => value != "").join(" - "),
    ),
  )
  for paragraph in paragraphs {
    paragraph
    parbreak()
  }
  if highlights.len() > 0 { list(..highlights) }
  v(design.entry_gap_pt * 1pt)
}

#let compact-row(body) = block(above: 0pt, below: leading, body)

#align(center)[
  #text(size: design.name_size_pt * 1pt, weight: "bold", data.profile.name)
  #let contacts = ()
  #let email = data.profile.at("email", default: "")
  #if email != "" { contacts.push(link("mailto:" + email, email)) }
  #let phone = data.profile.at("phone", default: "")
  #if phone != "" { contacts.push(phone) }
  #let website = data.profile.at("website", default: "")
  #if website != "" { contacts.push(link(website, website)) }
  #if contacts.len() > 0 {
    linebreak()
    contacts.join([#h(0.6em)|#h(0.6em)])
  }
]

= Experience

#for job in data.experience {
  dated-entry(
    job.organization,
    job.location,
    (job.start, job.end),
    (emph(job.position),),
    highlights: job.highlights,
  )
}

= Education

#for school in data.education {
  dated-entry(
    school.institution,
    school.location,
    (school.start, school.end),
    school.details.map(detail => eval(detail, mode: "markup")),
  )
}

= Professional and Community Activities

#for activity in data.activities {
  compact-row[#strong(activity.position), #activity.organization]
}

= Skills and Licenses

#for skill in data.skills {
  compact-row[#strong(skill.label + ": ")#skill.items.join(", ")]
}
