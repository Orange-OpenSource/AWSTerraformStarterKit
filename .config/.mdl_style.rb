all

rule "MD029", style: "ordered"

# our changelog does this, by design
exclude_rule 'MD024'

# Exclude line length
exclude_rule 'MD013'

# Inline HTML
exclude_rule 'MD033'

# Trailing spaces
exclude_rule 'MD009'
