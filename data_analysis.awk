#!/usr/bin/env gawk -f

# CITS4407 - Open Source Tools and Scripting
# Authorship: Kyle Leung (23601964), Sem 1 2023, The University of Western Australia

# This is a Gawk script to be called by the top level script "breaches_per_month" for performing data analysis on a file containing the total number of incidents of each month across all the years.

# For calculating MAD - define a function for returning the absolute value of a number
function abs(v) {
  return v < 0 ? -v : v
}

# Create an array "month" that contains the name of each month in order for subsequent formatting
BEGIN {
  split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec", month, " ")
}

# Create an array "total_array" for storing total number of incidents for each month
{total_array[$2] = $1}

# Format the lines in the input file by setting the name of month and its total number of incidents as the 1st and 2nd fields respectively, and redirect the output to a files named "table"
{print month[$2], $1 > "table"}

# 
END {
  # Compute the median across the 12 months
  num = asort(total_array)

  if (num % 2 == 1) {
    median = total_array[ceil(num / 2)]
  } else {
    median = (total_array[num / 2] + total_array[num / 2 + 1]) / 2
  }

  # Compute the median absolute deviation (MAD) across the 12 months
  for (i = 1; i <= num; i++)
    mad_array[i] = abs(total_array[i] - median)

  mad_num = asort(mad_array)

  if (mad_num % 2 == 1) {
    mad = mad_array[ceil(mad_num / 2)]
  } else {
    mad = (mad_array[mad_num / 2] + mad_array[mad_num / 2 + 1]) / 2
  }

  # Print Median and MAD in 2 decimal places
  printf "Median = %.2f\n", median
  printf "MAD = %.2f\n", mad
}
