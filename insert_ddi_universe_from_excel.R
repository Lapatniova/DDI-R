# ============================================================
# Automatically insert DDI <universe> tags into a DDI XML file
# Source XML: Nesstar / NADA export
# Mapping file: Excel (variable name + universe text)
# ============================================================

library(xml2)
library(tidyverse)
library(openxlsx)

# ------------------------------------------------------------
# 1. Load the DDI XML file
# ------------------------------------------------------------
# This XML file must come from Nesstar or NADA
# and already contain <var name="..."> elements

xml_path <- "path/to/input_ddi.xml"
xml_doc  <- read_xml(xml_path)

# Extract namespaces (required for DDI XML)
ns <- xml_ns(xml_doc)

# ------------------------------------------------------------
# 2. Load the Excel file containing universe information
# ------------------------------------------------------------
# Expected columns:
#   - variable : variable name (exact match with XML)
#   - universe : universe / filter text to insert

excel_path <- "path/to/universe_mapping.xlsx"

universe_table <- read.xlsx(excel_path, colNames = TRUE) |>
  as_tibble() |>
  rename(
    var = variable,
    universe = universe
  ) |>
  mutate(across(everything(), str_squish))

# ------------------------------------------------------------
# 3. Keep only variables that exist in the XML
# ------------------------------------------------------------
# Extract all variable names present in the XML
vars_in_xml <- xml_find_all(xml_doc, ".//d1:var", ns) |>
  xml_attr("name")

# Filter Excel table accordingly
universe_table <- universe_table |>
  filter(var %in% vars_in_xml)

# ------------------------------------------------------------
# 4. Function to update or create <universe> tag
# ------------------------------------------------------------
update_universe_tag <- function(var_node, universe_text) {
  
  # Do nothing if universe is empty or missing
  if (is.na(universe_text) || universe_text == "") return()
  
  # Try to find an existing <universe> tag
  universe_node <- xml_find_first(var_node, ".//d1:universe", ns)
  
  # If it does not exist, create it
  if (length(universe_node) == 0) {
    universe_node <- xml_add_child(var_node, "universe", ns = ns["d1"])
  }
  
  # Insert text (formatted for readability)
  xml_text(universe_node) <- paste0("\n        ", universe_text, "\n        ")
}

# ------------------------------------------------------------
# 5. Apply universe updates to each variable
# ------------------------------------------------------------
for (i in seq_len(nrow(universe_table))) {
  
  var_name <- universe_table$var[i]
  universe <- universe_table$universe[i]
  
  # Locate the variable node in the XML
  var_node <- xml_find_first(
    xml_doc,
    paste0(".//d1:var[@name='", var_name, "']"),
    ns
  )
  
  if (length(var_node) == 0) next
  
  # Update or insert universe
  update_universe_tag(var_node, universe)
}

# ------------------------------------------------------------
# 6. Export the updated XML
# ------------------------------------------------------------
write_xml(
  xml_doc,
  file = "path/to/output_ddi_with_universe.xml"
)

Add script to insert DDI universe from Excel
