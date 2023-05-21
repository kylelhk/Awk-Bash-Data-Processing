#!/usr/bin/env gawk -f

# CITS4407 - Open Source Tools and Scripting
# Authorship: Kyle Leung (23601964), Sem 1 2023, The University of Western Australia

# This is a Gawk script to be called by the top level script "preprocess" for performing data cleaning on an input data file.

# Assumptions for the input tsv file:
# - The 1st row is always the header.
# - The columns are in a fixed order with specified contents, e.g "Location_of_Breached_Information" and "Summary" are always under the 6th and 7th columns respectively.

# Set Input and Output Field Separators as Tab since many fields contain spaces in their contents
BEGIN {
  FS = OFS = "\t"
}

# Exclude "Location_of_Breached_Information" (6th field) and "Summary" (7th field) and add two headers at the end of the 1st row
FNR == 1 {
  print $1, $2, $3, $4, $5 OFS "Month" OFS "Year"
}

# Exclude the header when processing the data
FNR != 1 {
  # If the date in the 4th field is a range, split the range into two parts and save them into any array called "range"
  split($4, range, "[ ]*-[ ]*")

  # Extract the starting date from the "range" array
  start_date = range[1]

  # Extract the month, day and year from "start_date" and save them into an array called "date"
  split(start_date, date, "/")

  # Extract the month from the array "date" and remove any leading zero from the month
  month = date[1] + 0

  # Extract the year from the array "date"
  year = date[3]

  # For year that is not in 4-digit: 
  if (length(year) < 4) {
    # Drop row which contains invalid 3-digit year
    if (length(year) == 3) {
      next
    }
    # For 2-digit year, convert it into a valid 4-digit year
    else if (year <= 23) {
      year = sprintf ("20%s", year)
    } else {
      year = sprintf ("19%s", year)
    }
  }

  # Remove everything after the first comma or slash in the 5th field "Type_of_Breach"
  sub(/[,/].*$/, "", $5)

  # Print all fields (except the 6th and 7th fields) and add two new fields for month and year at the end
  print $1, $2, $3, $4, $5 OFS month OFS year
}