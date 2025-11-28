# DDI-R

R scripts to automate DDI documentation.

---

## Scripts

This repository will contain multiple R scripts to automate the import of variable metadata into DDI XML files.

### inject_modalities.R
The script `inject_modalities.R` injects variable modalities from an Excel file into a DDI XML file. 
It processes multiple variables, harmonizes variable names in lowercase, and creates the corresponding <catgry> tags in the XML. 
Dependencies: `xml2`, `tidyverse`, `openxlsx`.

**Function signature**:

```r
inject_modalities(xml_path, excel_path, output_xml_path)

xml_path : path to the input XML file

excel_path : path to the Excel file containing the modalities

output_xml_path : path to the output XML file

Example usage:

inject_modalities(
  xml_path = "data/input.xml",
  excel_path = "data/modalities.xlsx",
  output_xml_path = "data/output.xml"
)

