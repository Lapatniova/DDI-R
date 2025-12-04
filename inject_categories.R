# 📦 Required packages
library(xml2)
library(tidyverse)
library(openxlsx)

# ===============================
# Function: inject_categories
# ===============================
# Description:
# Injects variable categories from an Excel file into a DDI XML file.
#
# Arguments:
# - xml_path : path to the input XML file
# - excel_path : path to the Excel file containing the categories
# - output_xml_path : path where the modified XML file will be written
# ===============================

inject_categories <- function(xml_path, excel_path, output_xml_path) {
  
  # 📥 Load XML
  xml <- read_xml(xml_path)
  ns <- xml_ns(xml)
  
  # 📥 Load categories from Excel
  categories <- read.xlsx(excel_path, colNames = TRUE)
  
  # 🧼 Clean and harmonize column names
  categories <- categories |> 
    rename(
      var   = nom_variable,       # variable name
      value = code_categorie,     # category code
      label = libelle_categorie   # category label
    ) |> 
    mutate(across(everything(), str_squish),
           var = tolower(var))    # normalize variable names
  
  # 🔍 Extract <var> nodes from XML
  vars_xml <- xml_find_all(xml, ".//d1:var", ns)
  vars_names <- xml_attr(vars_xml, "name") |> str_squish() |> tolower()
  
  # 📊 Injection log
  log <- tibble(
    variable = character(),
    n_categories_added = integer()
  )
  
  # 📌 Variables present in Excel but missing in XML
  vars_missing <- c()
  
  # 🛠️ Loop through variables listed in Excel
  for (var_name in unique(categories$var)) {
    var_index <- which(vars_names == var_name)
    
    # If variable does not exist in XML → log it
    if (length(var_index) == 0) {
      vars_missing <- c(vars_missing, var_name)
      next
    }
    
    var_node <- vars_xml[[var_index]]
    rows <- categories |> filter(var == var_name)
    
    # 🧽 Remove previously existing <catgry> nodes (avoid duplicates)
    old_catgry <- xml_find_all(var_node, ".//d1:catgry", ns)
    if (length(old_catgry) > 0) xml_remove(old_catgry)
    
    # ➕ Add new categories
    for (i in seq_len(nrow(rows))) {
      row <- rows[i, ]
      
      catgry_node <- xml_add_child(var_node, "catgry", ns = ns["d1"])
      
      catValu_node <- xml_add_child(catgry_node, "catValu", ns = ns["d1"])
      xml_text(catValu_node) <- row$value
      
      labl_node <- xml_add_child(catgry_node, "labl", ns = ns["d1"])
      xml_text(labl_node) <- row$label
    }
    
    # ✍️ Update log
    log <- add_row(log,
                   variable = var_name,
                   n_categories_added = nrow(rows))
  }
  
  # 💾 Save modified XML
  write_xml(xml, file = output_xml_path)
  
  # 📊 Display injection report
  cat("\n==============================\n")
  cat("🔎 Injection report\n")
  cat("==============================\n\n")
  
  if (nrow(log) > 0) {
    for (i in seq_len(nrow(log))) {
      cat("-", log$variable[i], ":", log$n_categories_added[i], "categories added\n")
    }
  }
  
  if (length(vars_missing) > 0) {
    cat("\n⚠️ Variables not found in XML:", paste(vars_missing, collapse = ", "), "\n")
  }
  
  cat("\n✅ Modified XML exported to:", output_xml_path, "\n\n")
}
