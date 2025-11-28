# 📦 Packages requis
library(xml2)
library(tidyverse)
library(openxlsx)

# ===============================
# Fonction : inject_modalities
# ===============================
# Description :
# Injecte les modalités des variables depuis un fichier Excel dans un fichier XML DDI.
# 
# Arguments :
# - xml_path : chemin vers le fichier XML à modifier
# - excel_path : chemin vers le fichier Excel contenant les modalités
# - output_xml_path : chemin du fichier XML modifié à générer
# ===============================

inject_modalities <- function(xml_path, excel_path, output_xml_path) {
  
  # 📥 Charger le XML
  xml <- read_xml(xml_path)
  ns <- xml_ns(xml)
  
  # 📥 Charger les modalités depuis Excel
  modalites <- read.xlsx(excel_path, colNames = TRUE)
  
  # 🧼 Nettoyer et harmoniser les colonnes
  modalites <- modalites |> 
    rename(
      var = nom_variable,       # nom de la variable
      value = code_modalite,    # code de la modalité
      label = libelle_modalite  # libellé de la modalité
    ) |> 
    mutate(across(everything(), str_squish)) |> 
    mutate(var = tolower(var))  # 🔁 Harmonisation en minuscules
  
  # 🔍 Récupérer les balises <var> du XML
  vars_xml <- xml_find_all(xml, ".//d1:var", ns)
  vars_names <- xml_attr(vars_xml, "name") |> str_squish() |> tolower()
  
  # 🛠️ Ajouter les modalités à chaque variable
  for (var_name in unique(modalites$var)) {
    var_index <- which(vars_names == var_name)
    if (length(var_index) == 0) next
    
    var_node <- vars_xml[[var_index]]
    rows <- modalites |> filter(var == var_name)
    
    for (i in seq_len(nrow(rows))) {
      row <- rows[i, ]
      
      catgry_node <- xml_add_child(var_node, "catgry", ns = ns["d1"])
      
      catValu_node <- xml_add_child(catgry_node, "catValu", ns = ns["d1"])
      xml_text(catValu_node) <- row$value
      
      labl_node <- xml_add_child(catgry_node, "labl", ns = ns["d1"])
      xml_text(labl_node) <- row$label
    }
  }
  
  # 💾 Exporter le XML modifié
  write_xml(xml, file = output_xml_path)
  
  # ✅ Message final
  cat("✅ XML modifié exporté vers :", output_xml_path, "\n")
}

# ===============================
# Exemple d'utilisation
# ===============================
# inject_modalities(
#   xml_path = "path/to/input.xml",
#   excel_path = "path/to/modalities.xlsx",
#   output_xml_path = "path/to/output.xml"
# )
