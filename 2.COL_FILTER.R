###filter out bad cols

import_data <- read.csv("/scratch/ope4/LEAF_SPECTRAL/LEAF_SPECTRA_2025/OUTPUT/Apache_midday.csv")

# assume your data frame is called import_data

# Identify the wavelength column (keep it)
wavelength_col <- "Wavelength"

# Get all other columns
other_cols <- setdiff(names(import_data), wavelength_col)

# For each column, check whether ALL values lie within [0, 1]
cols_to_keep <- sapply(import_data[other_cols], function(x) all(x >= 0 & x <= 1))
cols_to_keep <- sapply(import_data[other_cols], function(x) mean(x >= 0 & x <= 1) > 0.99)


# Create cleaned dataset: keep wavelength + valid columns
clean_data <- import_data[, c(wavelength_col, names(cols_to_keep[cols_to_keep]))]
clean_data <- import_data[, c(wavelength_col, names(cols_to_keep[cols_to_keep])), drop = FALSE]
clean_data

df_long <- clean_data %>%
  pivot_longer(
    cols = -Wavelength,       # keep Wavelength column
    names_to = "Sample",
    values_to = "Reflectance"
  ) %>%
  extract(
    col = Sample,
    into = c("AP","Plot","Tree_num","L","Num","Last_digit"),
    regex = "(AP)_(P\\d)_(T\\d)_(L\\d)(\\d+)(\\d)$"
  ) %>%
  # Combine AP, Plot, Tree_num into one Tree column
  unite("Tree_name", AP, Plot, Tree_num, sep = "-")

##Mean per tree and Level
df_mean <- df_long %>%
  group_by(Tree_name, Wavelength) %>%
  summarise(mean_reflectance = mean(Reflectance, na.rm = TRUE)) %>%
  ungroup()

#tree name become unique cols
df_tree_cols <- df_mean %>%
  pivot_wider(
    names_from = Tree_name,
    values_from = mean_reflectance
  )

write.csv(df_tree_cols, "/scratch/ope4/LEAF_SPECTRAL/LEAF_SPECTRA_2025/OUTPUT/clean_data.csv", row.names = FALSE)


ggplot(df_mean, aes(x = Wavelength, 
                    y = mean_reflectance,
                    color = Tree_name)) +
  geom_line(linewidth = 1) +
  labs(
    title = "Mean Reflectance per Tree Across Wavelengths",
    x = "Wavelength (nm)",
    y = "Mean Reflectance"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "right",
    panel.grid.minor = element_blank()
  )

# Now pivot so Wavelength becomes columns
df_wavelength_cols <- df_mean %>%
  #unite("Measurement", Num, Last_digit, sep="_") %>%  # optional: combine L + measurement digits
  pivot_wider(
    names_from = Wavelength,
    values_from = mean_reflectance
  )